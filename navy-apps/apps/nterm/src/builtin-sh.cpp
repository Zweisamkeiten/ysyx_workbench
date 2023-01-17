#include <nterm.h>
#include <stdarg.h>
#include <unistd.h>
#include <SDL.h>
#include <string.h>

char handle_key(SDL_Event *ev);
static char ** builtin_envp = NULL;

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

static int cmd_help(char *args);
static int cmd_echo(char *args);

typedef struct cmd_t {
  const char *command;
  const char *description;
  int (*handler) (char *);
} cmd;

static cmd cmd_table [] = {
  { "help", "Display information about all supported commands", cmd_help },
  { "echo", "display a line of text", cmd_echo },
};

#define ARRLEN(arr) (int)(sizeof(arr) / sizeof(arr[0]))
#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args) {
  /* extract the first argument */
  int i;

  if (args == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      sh_printf("%s - %s\n", cmd_table[i].command, cmd_table[i].description);
    }
  }
  else {
    char *end = strchr(args, '\n');
    for (i = 0; i < NR_CMD; i ++) {
      if (strncmp(args, cmd_table[i].command, end - args) == 0) {
        sh_printf("%s - %s\n", cmd_table[i].command, cmd_table[i].description);
        return 0;
      }
    }
    sh_printf("Unknown command %s", args);
  }
  return 0;
}

static int cmd_echo(char *args) {
  sh_printf("%s", args);
  return 0;
}


static void sh_handle_cmd(const char *cmd) {
  if (cmd[0] == '\n') return;
  const char *args = strchrnul(cmd, ' ') + 1;
  int i;

  if (*(args - 2) == '\n') {
    for (i = 0; i < NR_CMD; i ++) {
      if (strncmp(cmd, cmd_table[i].command, args - 2 - cmd) == 0) {
        if (cmd_table[i].handler(NULL) < 0) { return; }
        break;
      }
    }
  } else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strncmp(cmd, cmd_table[i].command, args - cmd - 1) == 0) {
        if (cmd_table[i].handler((char *)args) < 0) { return; }
        break;
      }
    }
  }

  const char *exec_argv[3];
  exec_argv[0] = NULL;
  exec_argv[1] = NULL;
  exec_argv[2] = NULL;

  int n = 0;
  for (char *str = (char *)cmd; n < 3; str = NULL, n++) {
    exec_argv[n] = strtok(str, " \n");
    if (exec_argv[n] == NULL) break;
  }

  execve(exec_argv[0], (char**)exec_argv, (char**)builtin_envp);

  if (i == NR_CMD) { sh_printf("sh: command not found: %s\n", cmd); }
}

void builtin_sh_run(char *envp[]) {
  sh_banner();
  sh_prompt();

  builtin_envp = envp;

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
