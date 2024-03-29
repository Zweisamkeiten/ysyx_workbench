#include <isa.h>
#include <memory/host.h>
#include <memory/paddr.h>
#include <device/mmio.h>

static uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};
uint8_t* guest_to_host(paddr_t paddr) { return pmem + paddr - CONFIG_MBASE; }
paddr_t host_to_guest(uint8_t *haddr) { return haddr - pmem + CONFIG_MBASE; }

static word_t pmem_read(paddr_t addr, int len) {
  word_t ret = host_read(guest_to_host(addr), len);
  return ret;
}

static void pmem_write(paddr_t addr, int len, word_t data) {
  host_write(guest_to_host(addr), len, data);
}

static void out_of_bound(paddr_t addr) {
  panic("address = " FMT_PADDR " is out of bound of pmem [" FMT_PADDR ", " FMT_PADDR "] at pc = " FMT_WORD,
      addr, PMEM_LEFT, PMEM_RIGHT, cpu.pc);
}

void init_mem() {
#ifdef CONFIG_MEM_RANDOM
  uint32_t *p = (uint32_t *)pmem;
  int i;
  for (i = 0; i < (int) (CONFIG_MSIZE / sizeof(p[0])); i ++) {
    p[i] = rand();
  }
#endif
  printf("physical memory area [" FMT_PADDR ", " FMT_PADDR "]\n", PMEM_LEFT, PMEM_RIGHT);
}

word_t paddr_read(paddr_t addr, int len) {
#ifdef CONFIG_MTRACE
  IFDEF(CONFIG_MTRACE, printf(ANSI_FMT("Reading memory from address: ", ANSI_FG_MAGENTA)
                              ANSI_FMT(FMT_PADDR, ANSI_FG_CYAN)
                              ANSI_FMT(" size: ", ANSI_FG_MAGENTA)
                              ANSI_FMT("%d\n", ANSI_FG_CYAN), addr, 8));
#endif
  if (likely(in_pmem(addr))) return pmem_read(addr, len);
  IFDEF(CONFIG_DEVICE, return mmio_read(addr, len));
  // out_of_bound(addr);
  return 0;
}

void paddr_write(paddr_t addr, int len, word_t data) {
#ifdef CONFIG_MTRACE
  IFDEF(CONFIG_MTRACE, printf(ANSI_FMT("Writing memory from address: ", ANSI_FG_MAGENTA)
                              ANSI_FMT(FMT_PADDR, ANSI_FG_CYAN)
                              ANSI_FMT(" size: ", ANSI_FG_MAGENTA)
                              ANSI_FMT("%d\n", ANSI_FG_CYAN), addr, len));
#endif
  if (likely(in_pmem(addr))) { pmem_write(addr, len, data); return; }
  IFDEF(CONFIG_DEVICE, mmio_write(addr, len, data); return);
  out_of_bound(addr);
}
