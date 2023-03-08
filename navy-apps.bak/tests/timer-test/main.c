#include <stdio.h>
#include <NDL.h>

int main() {
  NDL_Init(0);

  int halfsec = 1;
  while (1) {
    while (NDL_GetTicks() / 500 < halfsec);
    printf("time pass 0.5s\n");
    halfsec++;
  }

  NDL_Quit();
  return 0;
}
