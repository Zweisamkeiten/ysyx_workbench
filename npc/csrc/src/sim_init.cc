#include <sim.hpp>
#include <common.h>
#include <isa.h>
extern "C" {
  #include <memory/paddr.h>
}

Vtop *top;
VerilatedContext *contextp = NULL;
VerilatedVcdC *tfp = NULL;
uint64_t * npcpc;

void set_state_end() {
  npc_state.state = NPC_END;
}

void set_state_abort() {
  npc_state.state = NPC_ABORT;
}

extern "C" void set_gpr_ptr(const svOpenArrayHandle r) {
  cpu.gpr = (uint64_t *)(((VerilatedDpiOpenVar*)r)->datap());
}

extern "C" void npc_pmem_read(long long raddr, long long *rdata) {
  // 总是读取地址为`raddr & ~0x7ull`的8字节返回给`rdata`
  *rdata = paddr_read(raddr, 8);
}

static uint8_t serial_base[2];

extern "C" void npc_pmem_write(long long waddr, long long wdata, char wmask) {
  if (waddr == 0xa00003f8) {
    serial_base[0] = wdata;
    putc(serial_base[0], stdout);
    return;
  }
  // 总是往地址为`waddr & ~0x7ull`的8字节按写掩码`wmask`写入`wdata`
  // `wmask`中每比特表示`wdata`中1个字节的掩码,
  // 如`wmask = 0x3`代表只写入最低2个字节, 内存中的其它字节保持不变
  switch ((unsigned char)wmask) {
    case 0x1: paddr_write(waddr, 1, wdata); break;
    case 0x3: paddr_write(waddr, 2, wdata); break;
    case 0xf: paddr_write(waddr, 4, wdata); break;
    default: paddr_write(waddr, 8, wdata); break;
  }
}

extern "C" void single_cycle() {
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

extern "C" void init_sim() {
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vtop;

  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("dump.vcd");

  reset(10);

  npc_state.state = NPC_RUNNING;

  npcpc = &(top->rootp->ysyx_22050710_npc__DOT__pc);
  cpu.inst = (uint32_t *)&(top->rootp->ysyx_22050710_npc__DOT__u_ifu__DOT__rdata);
  cpu.pc = *npcpc;
}

extern "C" void end_sim() {
  top->final();
  delete top;
  tfp->close();
}
