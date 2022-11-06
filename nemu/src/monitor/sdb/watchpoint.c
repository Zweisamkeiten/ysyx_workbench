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

#include "sdb.h"

#define NR_WP 32

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  /* TODO: Add more members if necessary */
  char * expr;
  word_t value;

} WP;

static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;

void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
  }

  head = NULL;
  free_ = wp_pool;
}

WP* new_wp() {
  if (free_ == NULL) {
    Assert(0, ANSI_FMT("No free watchpoints!\n", ANSI_FG_RED));
  }
  else {
    WP* tmp = free_->next;
    free_->next = head;
    head = free_;
    free_ = tmp;
    return head;
  }
}

void free_wp(WP *wp) {
  free(wp->expr);
  for (WP *i = head; i != NULL; i = i->next) {
    if (i->next == wp) {
      i->next = wp->next;
      break;
    }
  }
  wp->next = free_;
  free_ = wp;
}

int set_watchpoint(char *e, word_t value) {
  WP* new = new_wp();
  char *expr = calloc(1, sizeof(char) * (strlen(e) + 1));
  strcpy(expr, e);
  new->expr = expr;
  new->value = value;
  return new->NO;
}

bool delete_watchpoint(int n) {
  if (n < 0 || n >= NR_WP) {
    return false;
  }
  else {
    for (WP *i = head; i != NULL; i = i->next) {
      if (i->NO == n) {
        printf(ANSI_FMT("expr: %s delted\n", ANSI_FG_RED), i->expr);
        free_wp(i);
        return true;
      }
    }
  }

  return false;
}
