#include <stdio.h>
#include <assert.h>
#include "./include/fixedptc.h"

int main (int argc, char *argv[])
{
  fixedpt a = fixedpt_rconst(1.2);
  fixedpt b = fixedpt_rconst(-1.2);
  fixedpt c = fixedpt_rconst(0.5);
  fixedpt d = fixedpt_rconst(-0.5);

  assert(fixedpt_floor(a) == fixedpt_rconst(1.0));
  assert(fixedpt_floor(fixedpt_rconst(1.0)) == fixedpt_rconst(1.0));
  assert(fixedpt_floor(b) == fixedpt_rconst(-2.0));
  assert(fixedpt_floor(c) == fixedpt_rconst(0.0));
  assert(fixedpt_floor(d) == fixedpt_rconst(-1.0));

  assert(fixedpt_ceil(a) == fixedpt_rconst(2.0));
  assert(fixedpt_ceil(fixedpt_rconst(1.0)) == fixedpt_rconst(1.0));
  assert(fixedpt_ceil(b) == fixedpt_rconst(-1.0));
  assert(fixedpt_ceil(c) == fixedpt_rconst(1.0));
  assert(fixedpt_ceil(d) == fixedpt_rconst(0.0));
  return 0;
}
