#ifndef __ISA_H__
#define __ISA_H__

#include <isa-def.h>

// monitor
extern char isa_logo[];
void init_isa();

// reg
extern NPC_CPU_state cpu;
extern uint64_t *cpu_gpr;

void isa_reg_display();
word_t isa_reg_str2val(const char *name, bool *success);

// difftest
bool isa_difftest_checkregs(NPC_CPU_state *ref_r, vaddr_t pc);
void isa_difftest_attach();

#endif
