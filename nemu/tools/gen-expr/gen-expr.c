// clang-format off
/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <string.h>

enum {
  PLUS,
  MINUS,
  MULTIPLY,
  DIVIDE,
  N_OP,
};

static struct operator {
  char op;
  int type;
} operators[] = {
  {'+', PLUS},    // plus
  {'-', MINUS},    // minus
  {'*', MULTIPLY}, // multiply
  {'/', DIVIDE},   // divide
};


// this should be enough
static char buf[65536] = {};
static char *buf_p = buf;
static int is_overflow = 0;
static char code_buf[65536 + 128] = {}; // a little larger than `buf`
static char *code_format =
"#include <stdio.h>\n"
"int main() { "
"  unsigned long long result = %s; "
"  printf(\"%%llu\", result); "
"  return 0; "
"}";

int check_overflow(char *buf_p, int length) {
  if (buf_p - buf + length >= 65536 - 1) {
    is_overflow = 1;
  }
  return is_overflow;
}

uint64_t choose(uint64_t n) {
  uint64_t r = 0;
  for (int i = 0; i < 64; i++) {
    r = r * 2 + rand() % 2;
  }
  return r % n;
}

void gen_random_space() {
  int gen = rand() % 2;
  if (gen == 1) {
    if (check_overflow(buf_p, 1) == 0) {
      buf_p += sprintf(buf_p, " ");
      *buf_p = '\0';
    }
  }
}

void gen_num() {
  uint64_t num = choose(-1);
  if (check_overflow(buf_p, snprintf(NULL, 0, "%luu", num)) == 0) {
    buf_p += sprintf(buf_p, "%luu", num);
    *buf_p = '\0';
  }
}

void gen(char ch) {
  if (check_overflow(buf_p, 1) == 0) {
    buf_p += sprintf(buf_p, "%c", ch);
    *buf_p = '\0';
  }
}

void gen_rand_op() {
  if (check_overflow(buf_p, 1) == 0) {
    int r = choose(N_OP);
    buf_p += sprintf(buf_p, "%c", operators[r].op);
    *buf_p = '\0';
  }
}

// clang-format on
static void gen_rand_expr() {
  if (is_overflow) {
    return;
  }
  switch (choose(3)) {
  case 0:
    gen_random_space();
    gen_num();
    gen_random_space();
    break;
  case 1:
    gen('(');
    gen_rand_expr();
    gen(')');
    break;
  default:
    gen_rand_expr();
    gen_random_space();
    gen_rand_op();
    gen_random_space();
    gen_rand_expr();
    break;
  }
}
// clang-format off

int main(int argc, char *argv[]) {
  int seed = time(0);
  srand(seed);
  int loop = 1;
  if (argc > 1) {
    sscanf(argv[1], "%d", &loop);
  }
  int i;
  for (i = 0; i < loop; i ++) {
    buf[0] = '\0';
    buf_p = buf;
    gen_rand_expr();
    if (is_overflow == 1) {
      is_overflow = 0;
      i -= 1;
      continue;
    }

    sprintf(code_buf, code_format, buf);

    FILE *fp = fopen("/tmp/.code.c", "w");
    assert(fp != NULL);
    fputs(code_buf, fp);
    fclose(fp);

    int ret = system("gcc /tmp/.code.c -o /tmp/.expr -Wall -Werror");
    if (ret != 0) continue;

    fp = popen("/tmp/.expr", "r");
    assert(fp != NULL);

    unsigned long long int result;
    fscanf(fp, "%lld", &result);
    pclose(fp);

    printf("%llu %s\n", result, buf);
  }
  return 0;
}
