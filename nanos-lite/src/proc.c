#include <proc.h>

#define MAX_NR_PROC 4

static PCB pcb[MAX_NR_PROC] __attribute__((used)) = {};
static PCB pcb_boot = {};
PCB *current = NULL;

void switch_boot_pcb() {
  current = &pcb_boot;
}

void hello_fun(void *arg) {
  int j = 1;
  while (1) {
    Log("Hello World from Nanos-lite with arg '%p' for the %dth time!", (uintptr_t)arg, j);
    j ++;
    yield();
  }
}

/**
 * @brief 调用 kcontext() 创建上下文, 并将返回的指针记录到 PCB 的 cp 中
 */
void context_kload(PCB *pcb, void (*entry)(void *), void * args) {
  pcb->as.area.end = pcb->stack;
  pcb->as.area.start = pcb->stack + (STACK_SIZE * sizeof(uint8_t));

  pcb->cp = kcontext(pcb->as.area, entry, args);
}

void init_proc() {
  context_kload(&pcb[0], hello_fun, NULL);
  switch_boot_pcb();

  Log("Initializing processes...");

  // load program here
  /* void naive_uload(PCB *pcb, const char *filename); */
  /* naive_uload(NULL, "/bin/nterm"); */

}

Context* schedule(Context *prev) {
  // save the context pointer
  current->cp = prev;

  // always select pcb[0] as the new process
  current = &pcb[0];

  Log("%lx", (Context *)current->cp->mepc);
  // then return the new context
  return current->cp;
}
