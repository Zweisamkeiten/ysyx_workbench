#include "Vtop.h"
#include "Vtop__Dpi.h"
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdio.h>
#include <stdarg.h>

#define CONFIG_ISA64 1
#define CONFIG_MSIZE 0x8000000
#define CONFIG_MBASE 0x80000000
#define PG_ALIGN __attribute((aligned(4096)))
#define CHOOSE2nd(a, b, ...) b
#define MUXDEF(macro, X, Y)  MUX_MACRO_PROPERTY(__P_DEF_, macro, X, Y)
#define MUX_WITH_COMMA(contain_comma, a, b) CHOOSE2nd(contain_comma a, b)
#define MUX_MACRO_PROPERTY(p, macro, a, b) MUX_WITH_COMMA(concat(p, macro), a, b)
#define __IGNORE(...)
#define __KEEP(...) __VA_ARGS__
#define IFDEF(macro, ...) MUXDEF(macro, __KEEP, __IGNORE)(__VA_ARGS__)
#define PMEM_LEFT  ((paddr_t)CONFIG_MBASE)
#define PMEM_RIGHT ((paddr_t)CONFIG_MBASE + CONFIG_MSIZE - 1)
#define CONFIG_PC_RESET_OFFSET 0x0
#define RESET_VECTOR (PMEM_LEFT + CONFIG_PC_RESET_OFFSET)
typedef uint64_t word_t;
typedef uint64_t paddr_t;

static word_t host_read(void *addr, int len) {
  switch (len) {
    case 1: return *(uint8_t  *)addr;
    case 2: return *(uint16_t *)addr;
    case 4: return *(uint32_t *)addr;
    case 8: return *(uint64_t *)addr;
    default: MUXDEF(CONFIG_RT_CHECK, assert(0), return 0);
  }
}

static uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};
uint8_t* guest_to_host(paddr_t paddr) { return pmem + paddr - CONFIG_MBASE; }

static word_t pmem_read(paddr_t addr, int len) {
  word_t ret = host_read(guest_to_host(addr), len);
  return ret;
}

static const uint32_t img [] = {
  0x00100093,
  0x00200113,
  0x00300193,
  0x00400213,
  0x00500293,
  0x00600313,
  0x00100073,
};

static Vtop *top;
VerilatedContext *contextp = NULL;
VerilatedVcdC *tfp = NULL;

static void single_cycle() {
  top->i_clk = 0;
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
  top->i_clk = 1;
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

static void reset(int n) {
  top->i_rst = 1;
  while (n-- > 0) {
    single_cycle();
  }
  top->i_rst = 0;
}

enum {
  NPC_ABORT,
  NPC_RUNNING,
  NPC_END
};

static int npc_state = NPC_RUNNING;

void set_state_end() {
  npc_state = NPC_END;
}

void set_state_abort() {
  npc_state = NPC_ABORT;
}

int main(int argc, char **argv, char **env) {

  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vtop;

  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");


  reset(10);

  if (argc == 2) {
    FILE *fp = fopen(argv[1], "rb");
    if (fp == NULL) fprintf(stderr, "Can not open '%s\n'", argv[1]);
    assert(fp != NULL);

    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);

    fprintf(stdout, "The image is %s, size = %ld\n", argv[1], size);

    fseek(fp, 0, SEEK_SET);
    int ret = fread(guest_to_host(RESET_VECTOR), size, 1, fp);
    assert(ret == 1);

    fclose(fp);
  }
  else {
    memcpy(guest_to_host(RESET_VECTOR), img, sizeof(img));
  }

  npc_state = NPC_RUNNING;
  word_t last = top->o_pc;
  while (1) {
    top->i_inst = pmem_read(top->o_pc, 4);
    last = top->o_pc;
    // printf("%lx\n", top->o_pc);
    single_cycle();
    if (npc_state != NPC_RUNNING) break;
  }

  switch (npc_state) {
    case NPC_END: printf("Successful exit.\n"); break;
    case NPC_ABORT: printf("Unimplemented inst at PC: 0x%016lx\n", last); exit(1);
  }

  top->final();
  delete top;
  tfp->close();
}
