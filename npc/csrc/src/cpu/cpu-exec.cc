#include <cpu/cpu.h>
#include <sim.hpp>
extern "C" {
  #include <isa.h>
  #include <cpu/difftest.h>
  #include <memory/paddr.h>
}
int a_inst_finished = 0;
vaddr_t last_pc; // use at IRINGTRACE and difftest 现在指上一状态 刚执行过的指令的PC
#ifdef CONFIG_WATCHPOINT
extern "C" void diff_watchpoint_value();
#endif

NPC_CPU_state cpu = {};
static uint64_t g_timer = 0; // unit: us
#define BUFSIZE 128
#define MAX_INST_TO_PRINT 10
uint64_t g_nr_guest_inst = 0;
static bool g_print_step = false;
#ifdef CONFIG_ITRACE
char itrace_logbuf[BUFSIZE];
extern "C" void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
#endif

#ifdef CONFIG_FTRACE
extern uint8_t * elf_mem_p;
extern Elf_Ehdr *ehdr;

enum {INST_CALL, INST_RET, INST_OTHER};
static int inst_state = INST_OTHER;
static char ftrace_buf[128];

typedef struct sym_str_pair_t {
  Elf_Addr addr;
  word_t size;
  char * str;
} sym_str_pair;

typedef struct sym_str_t {
  sym_str_pair ** pairs;
  size_t n_pairs;
} sym_str_table;

static size_t stack_depth = 0;
static sym_str_table * func_sym_str_table;

void add_pair_to_table(sym_str_table * table, sym_str_pair pair) {
  table->pairs[table->n_pairs] = (sym_str_pair *)malloc(sizeof(sym_str_pair));
  table->pairs[table->n_pairs]->addr = pair.addr;
  table->pairs[table->n_pairs]->str = (char *)malloc(strlen(pair.str) + 1);
  table->pairs[table->n_pairs]->size = pair.size;
  strcpy(table->pairs[table->n_pairs]->str, pair.str);
  table->n_pairs = table->n_pairs + 1;
}

void init_func_sym_str_table() {
  Elf_Shdr *shdr = (Elf_Shdr *)&elf_mem_p[ehdr->e_shoff];

  // the first section header is null
  for (int i = 1; i < ehdr->e_shnum; i++) {
    if (shdr[i].sh_type == SHT_SYMTAB) {
      func_sym_str_table = (sym_str_table *)malloc(sizeof(sym_str_table));
      func_sym_str_table->pairs = NULL;
      func_sym_str_table->n_pairs = 0;
      char *strtab = (char *)&elf_mem_p[shdr[shdr[i].sh_link].sh_offset];
      Elf_Sym *symt = (Elf_Sym *)&elf_mem_p[shdr[i].sh_offset];
      for (size_t j = 0; j < shdr[i].sh_size / sizeof(Elf_Sym); j++) {
        // st_name 保存了指向符号表中字符串表（位于.dynstr 或者.strtab）
        // 的偏移地址，偏移地址存放着符号的名称，如 printf。
        // st_value 存放符号的值（可能是地址或者位置偏移量）。
        if (ELF_ST_TYPE(symt->st_info) == STT_FUNC) {
          func_sym_str_table->pairs = (sym_str_pair **)realloc(func_sym_str_table->pairs, sizeof(sym_str_pair *) * (func_sym_str_table->n_pairs + 1));
          sym_str_pair func_sym_str_pair = {.addr = symt->st_value, .size = symt->st_size, .str = &strtab[symt->st_name]};
          add_pair_to_table(func_sym_str_table, func_sym_str_pair);
        }
        symt++;
      }
      break;
    }
  }
}

char * check_is_func_call(word_t pc) {
  for (size_t i = 0; i < func_sym_str_table->n_pairs; i++) {
    sym_str_pair *curpair = func_sym_str_table->pairs[i];
    if (curpair->addr <= pc && pc < curpair->addr + curpair->size) {
      return func_sym_str_table->pairs[i]->str;
    }
  }
  return NULL;
}
#endif


#ifdef CONFIG_ITRACE
void disassemble_inst_to_buf(char *logbuf, size_t bufsize, uint8_t * inst_val, vaddr_t pc, vaddr_t snpc) {
  char *p = logbuf;
  p += snprintf(p, bufsize, FMT_WORD ":", pc);
  int ilen = snpc - pc;
  int i;
  uint8_t *inst = (uint8_t *)inst_val;
  for (i = ilen - 1; i >= 0; i --) {
    p += snprintf(p, 4, " %02x", inst[i]);
  }
  int ilen_max = 4;
  int space_len = ilen_max - ilen;
  if (space_len < 0) space_len = 0;
  space_len = space_len * 3 + 1;
  memset(p, ' ', space_len);
  p += space_len;

  disassemble(p, logbuf + bufsize - p, pc, (uint8_t *)inst_val, ilen);
#ifdef CONFIG_FTRACE
  char * q = ftrace_buf;
  if (strncmp(p, "ret", 3) == 0) {
    char *func_str = NULL;
    if((func_str = check_is_func_call(pc)) != NULL) {
      q += snprintf(q, 128, FMT_WORD ":", pc);
      stack_depth--;
      for (size_t i = 0; i < stack_depth; i++) {
        q += snprintf(q, 128, "  ");
      }
      q += snprintf(q, 128, "ret [%s]", func_str);
      inst_state = INST_RET;
    }
  }
  else if (strncmp(p, "jal", 3) == 0) {
    char *func_str = NULL;
    if((func_str = check_is_func_call(cpu.pc)) != NULL) {
      q += snprintf(q, 128, FMT_WORD ":", pc);
      for (size_t i = 0; i < stack_depth; i++) {
        q += snprintf(q, 128, "  ");
      }
      q += snprintf(q, 128, "call [%s@" FMT_WORD "]", func_str, cpu.pc);
      stack_depth++;
      inst_state = INST_CALL;
    }
  }
#endif
}

#ifdef CONFIG_IRINGTRACE
static int iringbuf_index = 0;
static char *iringbuf[16] = {NULL};

void print_iringbuf() {
  printf(ANSI_FMT("INSTRUCTIONS RING STRACE:\n", ANSI_FG_RED));

  iringbuf_index = iringbuf_index + 16 - 1;
  iringbuf_index %= 16;
  memmove(iringbuf[iringbuf_index], " --> ", 4);
  for (int i = 0; iringbuf[i] != NULL && i < 16; i++) {
    if (i == iringbuf_index) {
      printf(ANSI_FMT("%s\n", ANSI_FG_RED), iringbuf[i]);
    }
    else {
      printf(ANSI_FMT("%s\n", ANSI_FG_GREEN), iringbuf[i]);
    }
    free(iringbuf[i]);
  }
}
#endif
#endif

extern "C" void device_update();

static void trace_and_difftest(vaddr_t dnpc) {
#ifdef CONFIG_IRINGTRACE_COND
  if (IRINGTRACE_COND) {
    int arrow_len = strlen(" --> ");
    iringbuf[iringbuf_index] = (char *)realloc(iringbuf[iringbuf_index], arrow_len + strlen(itrace_logbuf) + 1);
    char *p = iringbuf[iringbuf_index];
    memset(p, ' ', arrow_len);
    p += arrow_len;
    strcpy(p, itrace_logbuf);
    iringbuf_index++;
    iringbuf_index %= 16;
  }
#endif
#ifdef CONFIG_FTRACE
  if (inst_state != INST_OTHER) {
    printf(ANSI_FMT("[FTRACE] %s\n", ANSI_FG_MAGENTA), ftrace_buf);
    inst_state = INST_OTHER;
  }
#endif
  if (g_print_step) { IFDEF(CONFIG_ITRACE, puts(itrace_logbuf)); }
  IFDEF(CONFIG_DIFFTEST, difftest_step(last_pc, dnpc));
  IFDEF(CONFIG_WATCHPOINT, diff_watchpoint_value());
}

void exec_once() {
  // printf("%lx\n", top->o_pc);
  int cpi = 0;
  while (a_inst_finished == 0) {
    cpi++;
    single_cycle(0);
    if (cpi > 50) {
      npc_state.state = NPC_ABORT;
      npc_state.halt_pc = cpu.pc;
      npc_state.halt_ret = -1;
      return;
    };
  }
  // single_cycle(0);
  a_inst_finished = 0;
#ifdef CONFIG_ITRACE
  // cpu.inst = paddr_read(last_pc, 4);
  disassemble_inst_to_buf(itrace_logbuf, 128, (uint8_t *)&(cpu.inst), last_pc, last_pc + 4);
#endif
  trace_and_difftest(cpu.pc);
}

static void execute(uint64_t n) {
  for (;n > 0; n --) {
    exec_once();
    g_nr_guest_inst ++;
    if (npc_state.state != NPC_RUNNING) break;
    IFDEF(CONFIG_DEVICE, device_update());
  }
}

static void statistic() {
  IFNDEF(CONFIG_TARGET_AM, setlocale(LC_NUMERIC, ""));
#define NUMBERIC_FMT MUXDEF(CONFIG_TARGET_AM, "%", "%'") PRIu64
  Log("host time spent = " NUMBERIC_FMT " us", g_timer);
  Log("total guest instructions = " NUMBERIC_FMT, g_nr_guest_inst);
  extern uint64_t cycles;
  Log("total guest cycles = " NUMBERIC_FMT, cycles);
  if (g_timer > 0) Log("simulation frequency = " NUMBERIC_FMT " inst/s", g_nr_guest_inst * 1000000 / g_timer);
  else Log("Finish running in less than 1 us and can not calculate the simulation frequency");
}


void assert_fail_msg() {
#ifdef CONFIG_IRINGTRACE_COND
  if (IRINGTRACE_COND) print_iringbuf();
#endif
  isa_reg_display();
  statistic();
}

/* Simulate how the CPU works. */
void cpu_exec(uint64_t n) {
  g_print_step = (n < MAX_INST_TO_PRINT);
  IFDEF(CONFIG_FTRACE, init_func_sym_str_table();)
  switch (npc_state.state) {
  case NPC_END:
  case NPC_ABORT:
    printf("Program execution has ended. To restart the program, exit NPC and "
           "run again.\n");
    return;
  default:
    npc_state.state = NPC_RUNNING;
  }

  uint64_t timer_start = get_time();

  execute(n);

  uint64_t timer_end = get_time();
  g_timer += timer_end - timer_start;

  switch (npc_state.state) {
  case NPC_RUNNING:
    npc_state.state = NPC_STOP;
    break;

  case NPC_ABORT:
#ifdef CONFIG_IRINGTRACE_COND
    if (IRINGTRACE_COND) print_iringbuf();
#endif
  case NPC_END:
    Log("npc: %s at pc = " FMT_WORD,
        (npc_state.state == NPC_ABORT
             ? ANSI_FMT("ABORT", ANSI_FG_RED)
             : (npc_state.halt_ret == 0
                    ? ANSI_FMT("HIT GOOD TRAP", ANSI_FG_GREEN)
                    : ANSI_FMT("HIT BAD TRAP", ANSI_FG_RED))),
        last_pc);
    // fall through
  case NPC_QUIT: statistic(); break;
  }
}
