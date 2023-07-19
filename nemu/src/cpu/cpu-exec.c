/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <cpu/cpu.h>
#include <cpu/decode.h>
#include <cpu/difftest.h>
#include <locale.h>
#ifdef CONFIG_WATCHPOINT
extern void diff_watchpoint_value();
#endif

/* The assembly code of instructions executed is only output to the screen
 * when the number of instructions executed is less than this value.
 * This is useful when you use the `si' command.
 * You can modify this value as you want.
 */
#define MAX_INST_TO_PRINT 10

CPU_state cpu = {};
uint64_t g_nr_guest_inst = 0;
static uint64_t g_timer = 0; // unit: us
static bool g_print_step = false;

#ifdef CONFIG_FTRACE
#include <trace.h>
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
  table->pairs[table->n_pairs] = malloc(sizeof(sym_str_pair));
  table->pairs[table->n_pairs]->addr = pair.addr;
  table->pairs[table->n_pairs]->str = malloc(strlen(pair.str) + 1);
  table->pairs[table->n_pairs]->size = pair.size;
  strcpy(table->pairs[table->n_pairs]->str, pair.str);
  table->n_pairs = table->n_pairs + 1;
}

static bool is_ftrace_inited = false;

void init_func_sym_str_table() {
  if (is_ftrace_inited == true) return;

  Elf_Shdr *shdr = (Elf_Shdr *)&elf_mem_p[ehdr->e_shoff];

  // the first section header is null
  for (int i = 1; i < ehdr->e_shnum; i++) {
    if (shdr[i].sh_type == SHT_SYMTAB) {
      func_sym_str_table = malloc(sizeof(sym_str_table));
      func_sym_str_table->pairs = NULL;
      func_sym_str_table->n_pairs = 0;
      char *strtab = (char *)&elf_mem_p[shdr[shdr[i].sh_link].sh_offset];
      Elf_Sym *symt = (Elf_Sym *)&elf_mem_p[shdr[i].sh_offset];
      for (int j = 0; j < shdr[i].sh_size / sizeof(Elf_Sym); j++) {
        // st_name 保存了指向符号表中字符串表（位于.dynstr 或者.strtab）
        // 的偏移地址，偏移地址存放着符号的名称，如 printf。
        // st_value 存放符号的值（可能是地址或者位置偏移量）。
        if (ELF_ST_TYPE(symt->st_info) == STT_FUNC) {
          func_sym_str_table->pairs = realloc(func_sym_str_table->pairs, sizeof(sym_str_pair *) * (func_sym_str_table->n_pairs + 1));
          sym_str_pair func_sym_str_pair = {.addr = symt->st_value, .str = &strtab[symt->st_name], .size = symt->st_size};
          add_pair_to_table(func_sym_str_table, func_sym_str_pair);
        }
        symt++;
      }
      break;
    }
  }

  is_ftrace_inited = true;
}

char * check_is_func_call(word_t pc) {
  for (int i = 0; i < func_sym_str_table->n_pairs; i++) {
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
  int ilen_max = MUXDEF(CONFIG_ISA_x86, 8, 4);
  int space_len = ilen_max - ilen;
  if (space_len < 0) space_len = 0;
  space_len = space_len * 3 + 1;
  memset(p, ' ', space_len);
  p += space_len;

  void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
  disassemble(p, logbuf + bufsize - p,
      MUXDEF(CONFIG_ISA_x86, snpc, pc), (uint8_t *)inst_val, ilen);
#ifdef CONFIG_FTRACE
  char * q = ftrace_buf;
  if (strncmp(p, "ret", 3) == 0) {
    char *func_str = NULL;
    if((func_str = check_is_func_call(pc)) != NULL) {
      q += snprintf(q, 128, FMT_WORD ":", pc);
      stack_depth--;
      for (int i = 0; i < stack_depth; i++) {
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
      for (int i = 0; i < stack_depth; i++) {
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
  Log(ANSI_FMT("INSTRUCTIONS RING STRACE:\n", ANSI_FG_RED));

  iringbuf_index = iringbuf_index + 16 - 1;
  iringbuf_index %= 16;
  memmove(iringbuf[iringbuf_index], " --> ", 4);
  for (int i = 0; iringbuf[i] != NULL && i < 16; i++) {
    if (i == iringbuf_index) {
      Log(ANSI_FMT("%s", ANSI_FG_RED), iringbuf[i]);
    }
    else {
      Log(ANSI_FMT("%s", ANSI_FG_GREEN), iringbuf[i]);
    }
    free(iringbuf[i]);
  }
}
#endif
#endif

void device_update();

static void trace_and_difftest(Decode *_this, vaddr_t dnpc) {
#ifdef CONFIG_ITRACE_COND
  if (ITRACE_COND) {
    log_write("%s\n", _this->logbuf);
  }
#endif
#ifdef CONFIG_IRINGTRACE_COND
  if (IRINGTRACE_COND) {
    int arrow_len = strlen(" --> ");
    iringbuf[iringbuf_index] = realloc(iringbuf[iringbuf_index], arrow_len + strlen(_this->logbuf) + 1);
    char *p = iringbuf[iringbuf_index];
    memset(p, ' ', arrow_len);
    p += arrow_len;
    strcpy(p, _this->logbuf);
    iringbuf_index++;
    iringbuf_index %= 16;
  }
#endif
#ifdef CONFIG_FTRACE
  if (inst_state != INST_OTHER) {
    if (FTRACE_COND) log_write(ANSI_FMT("[FTRACE] %s\n", ANSI_FG_MAGENTA), ftrace_buf);
    printf(ANSI_FMT("[FTRACE] %s\n", ANSI_FG_MAGENTA), ftrace_buf);
    inst_state = INST_OTHER;
  }
#endif
  if (g_print_step) { IFDEF(CONFIG_ITRACE, puts(_this->logbuf)); }
  IFDEF(CONFIG_DIFFTEST, difftest_step(_this->pc, dnpc));
  IFDEF(CONFIG_WATCHPOINT, diff_watchpoint_value());
}

static void exec_once(Decode *s, vaddr_t pc) {
  s->pc = pc;
  s->snpc = pc;
  isa_exec_once(s);
  cpu.pc = s->dnpc;
#ifdef CONFIG_ITRACE
  disassemble_inst_to_buf(s->logbuf, 128, (uint8_t *)&s->isa.inst.val, s->pc, s->snpc);
#endif
}

static void execute(uint64_t n) {
  static uint64_t skip = 0;
  Decode s;
  for (;n > 0; n --) {
    exec_once(&s, cpu.pc);
    g_nr_guest_inst ++;
    trace_and_difftest(&s, cpu.pc);
    if (nemu_state.state != NEMU_RUNNING) break;
    if (skip < 100000) {
      skip++;
    } else {
      IFDEF(CONFIG_DEVICE, device_update());
      skip = 0;
    }
  }
}

static void statistic() {
  IFNDEF(CONFIG_TARGET_AM, setlocale(LC_NUMERIC, ""));
#define NUMBERIC_FMT MUXDEF(CONFIG_TARGET_AM, "%", "%'") PRIu64
  Log("host time spent = " NUMBERIC_FMT " us", g_timer);
#ifdef CONFIG_MULTI_COUNT
  extern uint64_t multi_count;
  Log("total multi instructions = " NUMBERIC_FMT, multi_count);
#endif
  Log("total guest instructions = " NUMBERIC_FMT, g_nr_guest_inst);
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
  switch (nemu_state.state) {
    case NEMU_END: case NEMU_ABORT:
      printf("Program execution has ended. To restart the program, exit NEMU and run again.\n");
      return;
    case NEMU_QUIT: statistic(); return;
    default: nemu_state.state = NEMU_RUNNING;
  }
  IFDEF(CONFIG_FTRACE, init_func_sym_str_table();)

  uint64_t timer_start = get_time();

  execute(n);

  uint64_t timer_end = get_time();
  g_timer += timer_end - timer_start;

  switch (nemu_state.state) {
    case NEMU_RUNNING: nemu_state.state = NEMU_STOP; break;

    case NEMU_ABORT:
#ifdef CONFIG_IRINGTRACE_COND
      if (IRINGTRACE_COND) print_iringbuf();
#endif
    case NEMU_END:
      Log("nemu: %s at pc = " FMT_WORD,
          (nemu_state.state == NEMU_ABORT ? ANSI_FMT("ABORT", ANSI_FG_RED) :
           (nemu_state.halt_ret == 0 ? ANSI_FMT("HIT GOOD TRAP", ANSI_FG_GREEN) :
            ANSI_FMT("HIT BAD TRAP", ANSI_FG_RED))),
          nemu_state.halt_pc);
      // fall through
    case NEMU_QUIT: statistic();
  }
}
