#ifndef __ISA_RISCV64_H__
#define __ISA_RISCV64_H__

#include <common.h>

typedef struct {
  word_t gpr[32];
  vaddr_t pc;
} CPU_state;

// decode
typedef struct {
  union {
    uint32_t val;
  } inst;
} ISADecodeInfo;

#endif
