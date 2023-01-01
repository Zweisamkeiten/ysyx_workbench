#include <nterm.h>
#include <stdarg.h>
#include <unistd.h>
#include <SDL.h>

char handle_key(SDL_Event *ev);

static void sh_printf(const char *format, ...) {
  static char buf[256] = {};
  va_list ap;
  va_start(ap, format);
  int len = vsnprintf(buf, 256, format, ap);
  va_end(ap);
  term->write(buf, len);
}

static void sh_banner() {
  sh_printf("Built-in Shell in NTerm (NJU Terminal)\n\n");
}

static void sh_prompt() {
  sh_printf("sh> ");
}

static int cmd_help(const char *args);
static int cmd_echo(const char *args);

typedef struct cmd_t {
  const char *command;
  const char *description;
  int (*handler) (const char *);
} cmd;

static cmd cmd_table [] = {
  { "help", "Display information about all supported commands", cmd_help },
  { "echo", "display a line of text", cmd_echo },
};

#define ARRLEN(arr) (int)(sizeof(arr) / sizeof(arr[0]))
#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(const char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      sh_printf("%s - %s\n", cmd_table[i].command, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].command) == 0) {
        sh_printf("%s - %s\n", cmd_table[i].command, cmd_table[i].description);
        return 0;
      }
    }
    sh_printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

static int cmd_echo(const char *args) {
  char *arg = strtok(NULL, " ");
  sh_printf("%s\n", *arg);
  return 0;
}


static void sh_handle_cmd(const char *cmd) {
  char *cmd_c = strtok((char *)cmd, "\n");
  if (cmd_c == NULL) { return; }
  int i;
  for (i = 0; i < NR_CMD; i ++) {
    if (strcmp(cmd_c, cmd_table[i].command) == 0) {
      if (cmd_table[i].handler(cmd_c) < 0) { return; }
      break;
    }
  }

  if (i == NR_CMD) { sh_printf("Unknown command '%s'", cmd_c); }
}

void builtin_sh_run() {
  sh_banner();
  sh_prompt();

  while (1) {
    SDL_Event ev;
    if (SDL_PollEvent(&ev)) {
      if (ev.type == SDL_KEYUP || ev.type == SDL_KEYDOWN) {
        const char *res = term->keypress(handle_key(&ev));
        if (res) {
          sh_handle_cmd(res);
          sh_prompt();
        }
      }
    }
    refresh_terminal();
  }
}
