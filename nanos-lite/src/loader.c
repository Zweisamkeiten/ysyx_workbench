#include <proc.h>
#include <elf.h>

#ifdef __LP64__
# define Elf_Ehdr Elf64_Ehdr
# define Elf_Phdr Elf64_Phdr
# define Elf_Off  Elf64_Off
# define Elf_Addr Elf64_Addr
# define word_t   uint64_t
#else
# define Elf_Ehdr Elf32_Ehdr
# define Elf_Phdr Elf32_Phdr
# define Elf_Off  Elf32_Off
# define Elf_Addr Elf32_Addr
# define word_t   uint32_t
#endif

#if defined(__ISA_AM_NATIVE__)
# define EXPECT_TYPE EM_X86_64
#elif defined(__ISA_X86__)
# define EXPECT_TYPE EM_386 // Intel 80386 X86
#elif defined(__ISA_MIPS32__)
# define EXPECT_TYPE EM_MIPS_RS3_LE	 // MIPS R3000 little-endian
#elif defined(__ISA_RISCV32__) || defined(__ISA_RISCV64__)
# define EXPECT_TYPE EM_RISCV
#elif
# error unsupported ISA __ISA__
#endif

static uintptr_t loader(PCB *pcb, const char *filename) {
  extern uint8_t ramdisk_start;
  Elf_Ehdr *elf = (Elf_Ehdr *)&ramdisk_start;

  // check the magic number.
  assert(*(uint32_t *)elf->e_ident == 0x464c457f);

  // check the ELF ISA type
  printf("Debug: Machine: %d\n", elf->e_machine);
  assert(elf->e_machine == EXPECT_TYPE);

  size_t ramdisk_read(void *buf, size_t offset, size_t len);
  Elf_Phdr *phdr = (Elf_Phdr *)(&ramdisk_start + elf->e_phoff);
  printf("Debug: Program header list\n");
  for (int i = 0; i < elf->e_phnum; i++) {
    switch(phdr[i].p_type) {
      case PT_LOAD: {
        printf("Debug: Offset: 0x%x\n", phdr[i].p_offset);
        printf("Debug: Text segment: 0x%x\n", phdr[i].p_vaddr);
        printf("Debug: FileSiz: 0x%x\n", phdr[i].p_filesz);
        printf("Debug: Memsz: 0x%x\n", phdr[i].p_memsz);

        Elf_Addr vaddr = phdr[i].p_vaddr;
        Elf_Off offset = phdr[i].p_offset;
        word_t filesz = phdr[i].p_filesz;
        word_t memsz = phdr[i].p_memsz;
        ramdisk_read((void *)vaddr, offset, filesz);
        memset((void *)vaddr + filesz, 0, memsz-filesz);
      }
    }
  }

  return elf->e_entry;
}

void naive_uload(PCB *pcb, const char *filename) {
  uintptr_t entry = loader(pcb, filename);
  Log("Jump to entry = %p", entry);
  ((void(*)())entry) ();
}

