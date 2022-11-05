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

#include <isa.h>

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <regex.h>

enum {
  TK_NOTYPE = 256,
  TK_DECIMALINT,
  TK_EQ,
  TK_PLUS,
  TK_MINUS,
  TK_MULTIPLY,
  TK_DIVIDE,
  TK_BRACKET_L,
  TK_BRACKET_R,
};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more rules.
   * Pay attention to the precedence level of different rules.
   */

  {" +", TK_NOTYPE},    // spaces
  {"[[:digit:]]+", TK_DECIMALINT}, // decimal integer
  {"\\+", TK_PLUS},     // plus
  {"-", TK_MINUS},      // minus
  {"\\*", TK_MULTIPLY}, // minus
  {"\\/", TK_DIVIDE},   // divide
  {"\\(", TK_BRACKET_L},// bracket_L
  {"\\)", TK_BRACKET_R},// bracket_R
  {"==", TK_EQ},        // equal
};

#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

static Token tokens[32] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;

static bool make_token(char *e) {
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
            i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */

        switch (rules[i].token_type) {
          case TK_NOTYPE:
            break;
          default:
            tokens[nr_token].type = rules[i].token_type;
            if (substr_len >= 32) {
              Assert(0, "token string too long.\n");
              return false;
            }
            strncpy(tokens[nr_token].str, substr_start, substr_len);
            nr_token += 1;
        }

        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }

  return true;
}

int find_main_operator(int p, int q) {
  int op_position = p;
  bool in_parentheses = false;
  for (int i = p; i <= q; i++) {
    int current_type = tokens[i].type;
    switch (current_type) {
    case TK_DECIMALINT:
      break;
    case TK_BRACKET_L:
      in_parentheses = true;
      break;
    case TK_BRACKET_R:
      in_parentheses = false;
      break;
    default:
      if (in_parentheses == false && current_type <= tokens[op_position].type ) {
        op_position = i;
      }
    }
  }

  return op_position;
}

/*
 * check if the expression is surrounded
 * by a matching pair of parentheses
 */
bool check_parentheses(int p, int q, bool *is_valid) {
  // false, the whole expression is not surrounded by a matched
  if (tokens[p].type != TK_BRACKET_L || tokens[q].type != TK_BRACKET_R) {
    return false;
  }

  bool flag = true;
  int parentheses_stack = 1;
  for (int i = p+1; i <= q; i++) {
    if (tokens[i].type == TK_BRACKET_L) {
      parentheses_stack++;
    }
    else if (tokens[i].type == TK_BRACKET_R) {
      parentheses_stack--;
    }

    if (parentheses_stack == 0 && i != q) {
      flag = false;
    }

    if (parentheses_stack < 0) {
      *is_valid = false;
    }
  }
  return flag;
}

/*
 * eval the sub expression.
 */
word_t eval(int p, int q, bool *is_valid) {
  if (*is_valid == false) {
    return 0;
  }

  if (p > q) {
    /* Bad expression */
    Assert(0, "Bad expression.\n");
  }
  else if (p == q) {
    /*
     * Single token.
     * For now this token should be a number.
     * Return the value of the number
     */
    return strtol(tokens[p].str, NULL, 0);
  }
  else if (check_parentheses(p, q, is_valid) == true) {
    /*
     * The expression is surrounded by a matched pair of parentheses.
     * If that is the case, just throw away the parentheses.
     */
    return eval(p+1, q-1, is_valid);
  }
  else {
    // check_parentheses found illegal
    if (*is_valid == false) {
      return 0;
    }
    int op = find_main_operator(p, q);
    word_t val1 = eval(p, op - 1, is_valid);
    word_t val2 = eval(op + 1, q, is_valid);

    switch (tokens[op].type) {
      case TK_PLUS: return val1 + val2;
      case TK_MINUS: return val1 - val2;
      case TK_MULTIPLY: return val1 * val2;
      case TK_DIVIDE: return val1 / val2;
      default: assert(0);
    }
  }
}


word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }

  /* TODO: Insert codes to evaluate the expression. */
  word_t result = eval(0, nr_token - 1, success);
  return result;
}
