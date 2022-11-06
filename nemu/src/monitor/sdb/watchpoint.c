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
  const char * expr;
  uint64_t value;

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
  head = head->next;
  wp->next = free_;
  free_ = wp;
}

void set_watchpoint(char *e) {
  bool success = true;
  uint64_t value = expr(e, &success);
  if (success) {
    WP* new = new_wp();
    new->expr = e;
    new->value = value;
    printf(ANSI_FMT("Hardware watchpoint %d: %s\n", ANSI_FG_GREEN), new->NO, new->expr);
  }
  else {
    printf(ANSI_FMT("Invalid expression.\n", ANSI_FG_RED));
  }
}
