#include <sim.hpp>
#include <common.h>
#include <isa.h>
#include <memory/host.h>
extern "C" {
  #include <device/map.h>
  #include <cpu/difftest.h>
  #include <memory/paddr.h>
  #include "../local-include/reg.h"
}

Vtop *top;
#ifdef CONFIG_VCD_TRACE
VerilatedContext *contextp = NULL;
VerilatedVcdC *tfp = NULL;
#endif
#ifdef CONFIG_IPC_CAL
uint64_t cycles = 0;
uint64_t insts = 0;
#endif
uint64_t cycles = 0;

void finish_handle(long long pc, long long dnpc, long long inst, svLogic memen, long long memaddr) {
  extern vaddr_t last_pc;
  extern int a_inst_finished;
  last_pc = pc;
  cpu.inst = inst;
  cpu.pc = dnpc;
#ifdef CONFIG_IPC_CAL
  insts++;
#endif
  a_inst_finished = 1;
  if (memen) {
    if (is_mmio_addr(memaddr)) {
      difftest_skip_ref();
    }
  }
#ifdef CONFIG_VCD_TRACE
  printf("cycle: %lu, pc: %lx, inst: %lx\n", cycles, (word_t)pc, (word_t)inst);
#endif
}

void set_state_end() {
  npc_state.state = NPC_END;
  npc_state.halt_pc = cpu.pc;
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

extern "C" void npc_pmem_read(long long raddr, long long *rdata) {
  // 总是读取地址为`raddr & ~0x7ull`的8字节返回给`rdata`
  word_t addr;
  if (likely(in_pmem(raddr))) {
    addr = raddr & ~0x7ull;
  } else {
    addr = raddr;
  }
  *rdata = paddr_read(addr, 8);
}

extern "C" void npc_pmem_write(long long waddr, long long wdata, char wmask) {
  // 总是往地址为`waddr & ~0x7ull`的8字节按写掩码`wmask`写入`wdata`
  // `wmask`中每比特表示`wdata`中1个字节的掩码,
  // 如`wmask = 0x3`代表只写入最低2个字节, 内存中的其它字节保持不变
  word_t addr = waddr & ~0x7ull;
  uint8_t *p = (uint8_t *)&wdata;
  for (int i = 0; i < 8; i++) {
    if ((wmask & 0x1) == 0x1) {
      paddr_write(addr + i, 1, *(p + i));
    }
    wmask = wmask >> 1;
  }
}

extern "C" void single_cycle(int rst) {
  cycles++;
#ifdef CONFIG_IPC_CAL
  cycles++;
#ifdef CONFIG_VCD_TRACE
  printf("cycle: %lu\n", cycles);
#endif
#endif
  top->i_clk = 0;
  top->i_rst = rst;
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
  while (n-- > 0) {
    single_cycle(1); // always reset
  }
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

  reset(2);

  npc_state.state = NPC_RUNNING;

  QData ** csr = (QData **)malloc(NR_CSREGS * sizeof(uint64_t *));
  csr[MSTATUS] = &(top->rootp->ysyx_22050710_top__DOT__u_cpu_top__DOT__u_core__DOT__u_id_stage__DOT__u_csrs__DOT__mstatus);
  csr[MTVEC] = &(top->rootp->ysyx_22050710_top__DOT__u_cpu_top__DOT__u_core__DOT__u_id_stage__DOT__u_csrs__DOT__mtvec);
  csr[MEPC] = &(top->rootp->ysyx_22050710_top__DOT__u_cpu_top__DOT__u_core__DOT__u_id_stage__DOT__u_csrs__DOT__mepc);
  csr[MCAUSE] = &(top->rootp->ysyx_22050710_top__DOT__u_cpu_top__DOT__u_core__DOT__u_id_stage__DOT__u_csrs__DOT__mcause);

  cpu.csr = csr;
}

extern "C" void end_sim() {
  free(cpu.csr);
  top->final();
  delete top;
#ifdef CONFIG_VCD_TRACE
  tfp->close();
#endif
#ifdef CONFIG_IPC_CAL
  printf("cycles: %lu, insts: %lu\n", cycles, insts);
  printf("ipc: %lf\n", (double)insts / cycles);
#endif
}
