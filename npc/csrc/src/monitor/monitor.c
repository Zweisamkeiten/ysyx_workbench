#include <isa.h>
#include <memory/paddr.h>

void init_rand();
void init_mem();
void init_isa();
void init_sdb();
void init_sim();
void init_disasm(const char *triple);
void init_elf(const char * elf_file);
void init_difftest(char *ref_so_file, long img_size, int port);

static int difftest_port = 1234;

void sdb_set_batch_mode();

static void welcome() {
  printf("Trace: %s", MUXDEF(CONFIG_TRACE, ANSI_FMT("ON\n", ANSI_FG_GREEN), ANSI_FMT("OFF\n", ANSI_FG_RED)));
  IFDEF(CONFIG_TRACE, printf("If trace is enabled, a log file will be generated "
        "to record the trace. This may lead to a large log file. "
        "If it is not necessary, you can disable it in menuconfig\n"));
  printf("Build time: %s, %s\n", __TIME__, __DATE__);
  printf("Welcome to %s-npc!\n", ANSI_FMT("riscv64", ANSI_FG_YELLOW ANSI_BG_RED));
  printf("For help, type \"help\"\n");
}

static long load_img(int argc, char ** argv) {
  if (argc < 2) {
    printf("No image is given. Use the default built-in image.\n");
    return 0;
  }
  else {
    FILE *fp = fopen(argv[1], "rb");
    if (fp == NULL) fprintf(stderr, "Can not open '%s\n'", argv[1]);
    assert(fp != NULL);

    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);

    fprintf(stdout, "The image is %s, size = %ld\n", argv[1], size);

    fseek(fp, 0, SEEK_SET);
    int ret = fread(guest_to_host(RESET_VECTOR), size, 1, fp);
    assert(ret == 1);

    fclose(fp);
    return size;
  }
}

void init_monitor(int argc, char *argv[]) {

  if (argc == 5 && strcmp("1", argv[4]) == 0) {
    printf("Running in batchmode\n");
    sdb_set_batch_mode();
  }
  /* Set random seed. */
  init_rand();

  /* Initialize memory. */
  init_mem();

  init_sim();

  /* Perform ISA dependent initialization. */
  init_isa();

  /* Load the image to memory. This will overwrite the built-in image. */
  long img_size = load_img(argc, argv);

  /* Initialize differential testing. */
  init_difftest(argv[3], img_size, difftest_port);

  IFDEF(CONFIG_FTRACE, init_elf(argv[2]));

  /* Initialize the simple debugger. */
  init_sdb();

  init_disasm("riscv64-pc-linux-gnu");

  /* Display welcome message. */
  welcome();
}
