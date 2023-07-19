#include <am.h>
#include <riscv/riscv.h>
#include <klib.h>

static Context* (*user_handler)(Event, Context*) = NULL;

Context* __am_irq_handle(Context *c) {
  if (user_handler) {
    Event ev = {0};
    switch (c->mcause) {
      case Ex_ECALL_FROM_M_MODE: {
        if (c->GPR1 == -1) {
          ev.event = EVENT_YIELD; // yield
        } else {
          ev.event = EVENT_SYSCALL; // syscall
        }
        c->mepc += 4;
        break;
      }
      default: ev.event = EVENT_ERROR; break;
    }

    c = user_handler(ev, c);
    assert(c != NULL);
  }

  printf("%p\n", c);
  printf("%lx\n", c->mepc);
  return c;
}

extern void __am_asm_trap(void);

bool cte_init(Context*(*handler)(Event, Context*)) {
  // initialize exception entry
  asm volatile("csrw mtvec, %0" : : "r"(__am_asm_trap));

  // register event handler
  user_handler = handler;

  return true;
}

Context *kcontext(Area kstack, void (*entry)(void *), void *arg) {
  Context * c = (Context *)kstack.end;
  c->mepc = (uintptr_t)entry;

  Context ** cp = (Context **)(kstack.start - sizeof(Context *));
  *cp = (Context *)kstack.end;

  return *cp;
}

void yield() {
  asm volatile("li a7, -1; ecall");
}

bool ienabled() {
  return false;
}

void iset(bool enable) {
}
