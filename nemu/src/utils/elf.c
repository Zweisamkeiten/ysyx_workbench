#ifdef CONFIG_FTRACE
#include <common.h>

// load elf file to mem;
uint8_t * const elf_mem_p = NULL;
Elf_Ehdr *ehdr = NULL;

void init_elf(const char * elf_file) {
  if (elf_file == NULL) {
    Log("No elf file is given.");
    return;
  }

  FILE *fp = fopen(elf_file, "rb");
  Assert(fp, "Can not open '%s", elf_file);

  fseek(fp, 0, SEEK_END);
  long size = ftell(fp);

  Log("The elf is %s, size = %ld", elf_file, size);
  
  fseek(fp, 0, SEEK_SET);
  elf_mem_p = malloc(size);
  fread(elf_mem_p, size, 1, fp);

  ehdr = Elf_Ehdr *elf_mem_p;

  /* * Check to see if the ELF magic (The first 4 bytes) * match up as 0x7f E L
   * F */
  if (elf_mem_p[0] != 0x7f && strcmp((char *)&elf_mem_p[1], "ELF")) {
    Assert("%s is not an ELF file\n", elf_file);
  }

  if (ehdr->e_type != ET_EXEC) {
    Assert("%s is not an executable\n", elf_file);
  }

  Log("Program Entry point: 0x%lx\n", ehdr->e_entry);
}

#endif
