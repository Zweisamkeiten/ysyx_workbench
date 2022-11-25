#include <isa.h>
#include <cpu/cpu.h>
#include <common.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <memory/paddr.h>
#include "sdb.h"

void init_regex();
void init_wp_pool();

/* We use the `readline' library to provide more flexibility to read from stdin. */
static char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline(ANSI_FMT("(npc) ", ANSI_FG_YELLOW));

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_x(char *args) {
  if (args != NULL) {
    char *esp_str;
    char *n_str = strtok_r(args, " ", &esp_str);

    if (n_str != NULL) {
      char **invalid = (char **)malloc(sizeof(char *));
      *invalid = NULL;
      uint64_t n = strtoull(n_str, invalid, 10);

      if (*n_str != '\0' && **invalid == '\0') {
        free(invalid);

        if (esp_str != NULL) {
          bool success = true;
          uint64_t addr = expr(esp_str, &success);

          if (success) {
            for (int i = 0; i < n; addr += 4, ++i) {
              uint32_t data = paddr_read(addr, 4);
              printf("%#lx:\t0x%08x\n", addr, data);
            }
            return 0;
          }
        }
      }
    }
  }

  printf(ANSI_FMT("ERROR: x <N> <EXPR>\n", ANSI_FG_RED));
  return 0;
}

static int cmd_info(char *args) {
  char *sub_cmd = strtok(args, " ");
  if (sub_cmd != NULL) {
    if (strcmp(sub_cmd, "r") == 0) {
      // print the reg state
      isa_reg_display();
      printf(ANSI_FMT("%s:", ANSI_FG_BLUE) ANSI_FMT("\t0x%016lx\t", ANSI_FG_GREEN) ANSI_FMT("%020lu\n", ANSI_FG_MAGENTA), "pc", cpu.pc, cpu.pc);
      return 0;
    }
    else if (strcmp(sub_cmd, "w") == 0) {
      // print the watchpoint state
      watchpoints_display();
      return 0;
    }
  }
  printf(ANSI_FMT("ERROR: info <r/w>\n", ANSI_FG_RED));
  return 0;
}

static int cmd_si(char *args) {
  char *steps_str = strtok(args, " ");

  if (steps_str != NULL) {
    char **invalid = (char **)malloc(sizeof(char *));
    *invalid = NULL;
    uint64_t steps = strtoull(steps_str, invalid, 10);
    if (*steps_str != '\0' && **invalid == '\0') {
      cpu_exec(steps);
      free(invalid);
      return 0;
    }
  } else {
    cpu_exec(1);
    return 0;
  }

  printf(ANSI_FMT("ERROR: si [steps]\n", ANSI_FG_RED));
  return 0;
}

static int cmd_c(char *args) {
  cpu_exec(-1);
  return 0;
}


static int cmd_q(char *args) {
  npc_state.state = NPC_QUIT;
  return -1;
}

static int cmd_w(char *args) {
  char *e= args;

  if (e != NULL) {
    bool success = true;
    word_t result = expr(e, &success);
    if (success == true) {
      int No = set_watchpoint(e, result);
      printf(ANSI_FMT("Watchpoint %d: %s\n", ANSI_FG_GREEN), No, e);
    }
    else {
      printf(ANSI_FMT("Invalid expression.\n", ANSI_FG_RED));
    }
    return 0;
  }
  printf(ANSI_FMT("ERROR: w <EXPR>\n", ANSI_FG_RED));
  return 0;
}

static int cmd_d(char *args) {
  char *n_str = strtok(args, " ");

  if (n_str != NULL) {
    char **invalid = (char **)malloc(sizeof(char *));
    *invalid = NULL;
    int n = strtol(n_str, invalid, 10);
    if (*n_str != '\0' && **invalid == '\0') {
      free(invalid);
      if(delete_watchpoint(n) == true) {
        printf(ANSI_FMT("Watchpoint number %d deleted\n", ANSI_FG_GREEN), n);
      }
      else {
        printf(ANSI_FMT("No watchpoint number %d\n", ANSI_FG_RED), n);
      }
      return 0;
    }
  }
  return 0;
}

static int cmd_help(char *args);

static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table [] = {
  { "help", "Display information about all supported commands", cmd_help },
  { "c", "Continue the execution of the program", cmd_c },
  { "q", "Exit NPC", cmd_q },
  { "si", "single step", cmd_si },
  { "info", "print the program state", cmd_info },
  { "x", "scan memory", cmd_x },
  { "w", "set a new watchpoint", cmd_w },
  { "d", "delete a watchpoint", cmd_d },
};

#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

void sdb_mainloop() {
  for (char *str; (str = rl_gets()) != NULL; ) {
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL) { continue; }

    /* treat the remaining string as the arguments,
     * which may need further parsing
     */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end) {
      args = NULL;
    }

    int i;
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(cmd, cmd_table[i].name) == 0) {
        if (cmd_table[i].handler(args) < 0) { return; }
        break;
      }
    }

    if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
  }
}

void init_sdb() {
  /* Compile the regular expressions. */
  init_regex();

  /* Initialize the watchpoint pool. */
  init_wp_pool();
}
