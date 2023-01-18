#include <sim.hpp>
#include <common.h>
#include <isa.h>
#include <memory/host.h>
extern "C" {
  #include <memory/paddr.h>
}

Vtop *top;
#ifdef CONFIG_VCD_TRACE
VerilatedContext *contextp = NULL;
VerilatedVcdC *tfp = NULL;
#endif
uint64_t * npcpc;

void set_state_end() {
  npc_state.state = NPC_END;
  npc_state.halt_pc = *npcpc;
  npc_state.halt_ret = cpu.gpr[10];
}

void set_state_abort() {
  if (npc_state.state != NPC_STOP) {
    printf("There are two cases which will trigger this unexpected exception:\n"
        "1. The instruction at PC = " FMT_WORD " is not implemented.\n"
        "2. Something is implemented incorrectly.\n", cpu.pc);
    printf("Find this PC(" FMT_WORD ") in the disassembling result to distinguish which case it is.\n\n", cpu.pc);
    printf(ANSI_FMT("If it is the first case, see\n%s\nfor more details.\n\n"
          "If it is the second case, remember:\n"
          "* The machine is always right!\n"
          "* Every line of untested code is always wrong!\n\n", ANSI_FG_RED), isa_logo);
  }
  npc_state.state = NPC_ABORT;
  npc_state.halt_pc = cpu.pc;
  npc_state.halt_ret = -1;
}

extern "C" void set_gpr_ptr(const svOpenArrayHandle r) {
  cpu.gpr = (uint64_t *)(((VerilatedDpiOpenVar*)r)->datap());
}

extern "C" void set_csr_ptr(const svOpenArrayHandle r) {
  cpu.csr = (uint64_t *)(((VerilatedDpiOpenVar*)r)->datap());
}

extern "C" void npc_pmem_read(long long raddr, long long *rdata) {
  // 总是读取地址为`raddr & ~0x7ull`的8字节返回给`rdata`
  word_t addr = raddr & ~0x7ull;
  *rdata = paddr_read(addr, 8);
}

extern "C" void npc_pmem_write(long long waddr, long long wdata, char wmask) {
  // 总是往地址为`waddr & ~0x7ull`的8字节按写掩码`wmask`写入`wdata`
  // `wmask`中每比特表示`wdata`中1个字节的掩码,
  // 如`wmask = 0x3`代表只写入最低2个字节, 内存中的其它字节保持不变
  word_t addr = waddr & ~0x7ull;
  for (int i = 7; i >= 0; i--, addr++) {
    if ((wmask & 0x1) == 0x1) {
      paddr_write(addr, 1, wdata & 0xff);
    }
    wdata = wdata >> 8;
    wmask = wmask >> 1;
  }
}

extern "C" void single_cycle() {
  top->i_clk = 0;
  top->eval();
#ifdef CONFIG_VCD_TRACE
  contextp->timeInc(1);
  tfp->dump(contextp->time());
#endif
  top->i_clk = 1;
  top->eval();
#ifdef CONFIG_VCD_TRACE
  contextp->timeInc(1);
  tfp->dump(contextp->time());
#endif
}

static void reset(int n) {
  top->i_rst = 1;
  while (n-- > 0) {
    single_cycle();
  }
  top->i_rst = 0;
}

extern "C" void init_sim() {
#ifdef CONFIG_VCD_TRACE
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
#endif
  top = new Vtop;

#ifdef CONFIG_VCD_TRACE
  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");
#endif

  reset(10);

  npc_state.state = NPC_RUNNING;

  npcpc = &(top->rootp->ysyx_22050710_npc__DOT__pc);
  cpu.pc = *npcpc;
}

extern "C" void end_sim() {
  top->final();
  delete top;
#ifdef CONFIG_VCD_TRACE
  tfp->close();
#endif
}
