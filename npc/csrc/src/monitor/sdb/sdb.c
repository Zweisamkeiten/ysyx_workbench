#include <common.h>
#include <readline/readline.h>
#include <readline/history.h>

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
