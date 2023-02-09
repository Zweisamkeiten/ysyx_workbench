#include <isa.h>
#include <memory/paddr.h>

// this is not consistent with uint8_t
// but it is ok since we do not access the array directly
static const uint32_t img [] = {
  0x02000793,
  0x30579073,
  // bug load inst write to itself
  0x00009117,  // auipc sp, 0x9
  0x00812103, // lw sp, 8(sp)
  //
  0x01212423, //                sw      s2,8(sp)
  0x00f00593, //                li      a1,15
  0x01400613, //                li      a2,20
  0x00c58933, //                add     s2,a1,a2
  0x01212423, //                sw      s2,8(sp)
  0x00812783, // lw a5, 8(sp)
  0x00100513,  // li      a0,1
  0x00200593,  // li      a1,2
  0x00200613,  // li      a2,2
  0x00200693,  // li      a3,2
  0x00c58933,  // add     s2,a1,a2
  0x00a13423,  // sd      a0,8(sp)
  0x00100073,  // ebreak (used as nemu_trap)
  0xdeadbeef,  // some data
};

static void restart() {
  /* Set the initial program counter. */
  cpu.pc = RESET_VECTOR;
}

void init_isa() {
  /* Load built-in image. */
  memcpy(guest_to_host(RESET_VECTOR), img, sizeof(img));

  /* Initialize this virtual computer system. */
  restart();
}
