#ifndef __ISA_H__
#define __ISA_H__

#include <isa-def.h>

// monitor
extern char isa_logo[];
void init_isa();

// reg
extern CPU_state cpu;
extern uint64_t *cpu_gpr;

void isa_reg_display();
word_t isa_reg_str2val(const char *name, bool *success);

#endif
