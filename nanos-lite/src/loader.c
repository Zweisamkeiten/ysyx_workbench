#include <proc.h>
#include <elf.h>

#ifdef __LP64__
# define Elf_Ehdr Elf64_Ehdr
# define Elf_Phdr Elf64_Phdr
#else
# define Elf_Ehdr Elf32_Ehdr
# define Elf_Phdr Elf32_Phdr
#endif


static uintptr_t loader(PCB *pcb, const char *filename) {
  extern uint8_t ramdisk_start;
  Elf_Ehdr *elf = (Elf_Ehdr *)&ramdisk_start;

  // check the magic number.
  assert(*(uint32_t *)elf->e_ident == 0x7f454c46);

  Elf_Phdr *phdr = (Elf_Phdr *)(&ramdisk_start + elf->e_phoff);
  printf("\nProgram header list\n\n");
  for (int i = 0; i < elf->e_phnum; i++) {
       switch(phdr[i].p_type) {
         case PT_LOAD:
           /* * We know that text segment starts * at offset 0.
            * And only one other *
            * possible loadable segment exists *
            * which is the data segment. */
           if (phdr[i].p_offset == 0) printf("Text segment: 0x%x\n", phdr[i].p_vaddr);
    }
  }

  size_t ramdisk_read(void *buf, size_t offset, size_t len);
  ramdisk_read((void *)(uintptr_t)(0x83000000), 0, 0x4f20+0x1038);
  return elf->e_entry;
}

void naive_uload(PCB *pcb, const char *filename) {
  uintptr_t entry = loader(pcb, filename);
  Log("Jump to entry = %p", entry);
  ((void(*)())entry) ();
}

