#ifndef __CONFIG_TRACE
#define __CONFIG_TRACE

#ifdef CONFIG_FTRACE
#include <elf.h>
typedef MUXDEF(CONFIG_ISA64, Elf64_Ehdr, Elf32_Ehdr) Elf_Ehdr;
typedef MUXDEF(CONFIG_ISA64, Elf64_Shdr, Elf64_Shdr) Elf_Shdr;
typedef MUXDEF(CONFIG_ISA64, Elf64_Addr, Elf32_Addr) Elf_Addr;
typedef MUXDEF(CONFIG_ISA64, Elf64_Sym, Elf32_Sym) Elf_Sym;
#define ELF_ST_TYPE(val) MUXDEF(CONFIG_ISA64, ELF64_ST_TYPE(val), ELF32_ST_TYPE)

#endif

#endif
