#include <nterm.h>
#include <SDL.h>
#include <SDL_bdf.h>
#include <vorbis.h>

#define MUSIC_PATH "/share/music/boot.ogg"
#define SAMPLES 4096
#define MAX_VOLUME 128

stb_vorbis *v = NULL;
stb_vorbis_info info = {};
int is_end = 0;
int16_t *stream_save = NULL;
int volume = MAX_VOLUME;

static const char *font_fname = "/share/fonts/Courier-7.bdf";
static BDF_Font *font = NULL;
static SDL_Surface *screen = NULL;
Terminal *term = NULL;

void FillAudio(void *userdata, uint8_t *stream, int len) {
  int nbyte = 0;
  int samples_per_channel = stb_vorbis_get_samples_short_interleaved(v,
      info.channels, (int16_t *)stream, len / sizeof(int16_t));
  if (samples_per_channel != 0) {
    int samples = samples_per_channel * info.channels;
    nbyte = samples * sizeof(int16_t);
  } else {
    is_end = 1;
  }
  if (nbyte < len) memset(stream + nbyte, 0, len - nbyte);
  memcpy(stream_save, stream, len);
}

void builtin_sh_run(char *envp[]);
void extern_app_run(const char *app_path);

int main(int argc, char *argv[], char *envp[]) {
  SDL_Init(0);
  font = new BDF_Font(font_fname);

  // setup display
  int win_w = font->w * W;
  int win_h = font->h * H;
  screen = SDL_SetVideoMode(win_w, win_h, 32, SDL_HWSURFACE);

  FILE *fp = fopen(MUSIC_PATH, "r");
  assert(fp);
  fseek(fp, 0, SEEK_END);
  size_t size = ftell(fp);
  void *buf = malloc(size);
  assert(size);
  fseek(fp, 0, SEEK_SET);
  int ret = fread(buf, size, 1, fp);
  assert(ret == 1);
  fclose(fp);

  int error;
  v = stb_vorbis_open_memory((const unsigned char *)buf, size, &error, NULL);
  assert(v);
  info = stb_vorbis_get_info(v);

  SDL_AudioSpec spec;
  spec.freq = info.sample_rate;
  spec.channels = info.channels;
  spec.samples = SAMPLES;
  spec.format = AUDIO_S16SYS;
  spec.userdata = NULL;
  spec.callback = FillAudio;
  SDL_OpenAudio(&spec, NULL);

  stream_save = (int16_t *)malloc(SAMPLES * info.channels * sizeof(*stream_save));
  assert(stream_save);
  printf("Playing %s(freq = %d, channels = %d)...\n", MUSIC_PATH, info.sample_rate, info.channels);
  SDL_PauseAudio(0);

  term = new Terminal(W, H);

  if (argc < 2) { builtin_sh_run(envp); }
  else { extern_app_run(argv[1]); }

  SDL_CloseAudio();
  stb_vorbis_close(v);
  free(stream_save);
  free(buf);

  // should not reach here
  assert(0);
}

static void draw_ch(int x, int y, char ch, uint32_t fg, uint32_t bg) {
  SDL_Surface *s = BDF_CreateSurface(font, ch, fg, bg);
  SDL_Rect dstrect = { .x = (int16_t)x, .y = (int16_t)y };
  SDL_BlitSurface(s, NULL, screen, &dstrect);
  SDL_FreeSurface(s);
}

void refresh_terminal() {
  int needsync = 0;
  for (int i = 0; i < W; i ++)
    for (int j = 0; j < H; j ++)
      if (term->is_dirty(i, j)) {
        draw_ch(i * font->w, j * font->h, term->getch(i, j), term->foreground(i, j), term->background(i, j));
        needsync = 1;
      }
  term->clear();

  static uint32_t last = 0;
  static int flip = 0;
  uint32_t now = SDL_GetTicks();
  if (now - last > 500 || needsync) {
    int x = term->cursor.x, y = term->cursor.y;
    uint32_t color = (flip ? term->foreground(x, y) : term->background(x, y));
    draw_ch(x * font->w, y * font->h, ' ', 0, color);
    SDL_UpdateRect(screen, 0, 0, 0, 0);
    if (now - last > 500) {
      flip = !flip;
      last = now;
    }
  }
}

#define ENTRY(KEYNAME, NOSHIFT, SHIFT) { SDLK_##KEYNAME, #KEYNAME, NOSHIFT, SHIFT }
static const struct {
  int keycode;
  const char *name;
  char noshift, shift;
} SHIFT[] = {
  ENTRY(ESCAPE,       '\033', '\033'),
  ENTRY(SPACE,        ' ' , ' '),
  ENTRY(RETURN,       '\n', '\n'),
  ENTRY(BACKSPACE,    '\b', '\b'),
  ENTRY(1,            '1',  '!'),
  ENTRY(2,            '2',  '@'),
  ENTRY(3,            '3',  '#'),
  ENTRY(4,            '4',  '$'),
  ENTRY(5,            '5',  '%'),
  ENTRY(6,            '6',  '^'),
  ENTRY(7,            '7',  '&'),
  ENTRY(8,            '8',  '*'),
  ENTRY(9,            '9',  '('),
  ENTRY(0,            '0',  ')'),
  ENTRY(GRAVE,        '`',  '~'),
  ENTRY(MINUS,        '-',  '_'),
  ENTRY(EQUALS,       '=',  '+'),
  ENTRY(SEMICOLON,    ';',  ':'),
  ENTRY(APOSTROPHE,   '\'', '"'),
  ENTRY(LEFTBRACKET,  '[',  '{'),
  ENTRY(RIGHTBRACKET, ']',  '}'),
  ENTRY(BACKSLASH,    '\\', '|'),
  ENTRY(COMMA,        ',',  '<'),
  ENTRY(PERIOD,       '.',  '>'),
  ENTRY(SLASH,        '/',  '?'),
  ENTRY(A,            'a',  'A'),
  ENTRY(B,            'b',  'B'),
  ENTRY(C,            'c',  'C'),
  ENTRY(D,            'd',  'D'),
  ENTRY(E,            'e',  'E'),
  ENTRY(F,            'f',  'F'),
  ENTRY(G,            'g',  'G'),
  ENTRY(H,            'h',  'H'),
  ENTRY(I,            'i',  'I'),
  ENTRY(J,            'j',  'J'),
  ENTRY(K,            'k',  'K'),
  ENTRY(L,            'l',  'L'),
  ENTRY(M,            'm',  'M'),
  ENTRY(N,            'n',  'N'),
  ENTRY(O,            'o',  'O'),
  ENTRY(P,            'p',  'P'),
  ENTRY(Q,            'q',  'Q'),
  ENTRY(R,            'r',  'R'),
  ENTRY(S,            's',  'S'),
  ENTRY(T,            't',  'T'),
  ENTRY(U,            'u',  'U'),
  ENTRY(V,            'v',  'V'),
  ENTRY(W,            'w',  'W'),
  ENTRY(X,            'x',  'X'),
  ENTRY(Y,            'y',  'Y'),
  ENTRY(Z,            'z',  'Z'),
};

char handle_key(const char *buf) {
  char key[32];
  static int shift = 0;
  sscanf(buf + 2, "%s", key);

  if (strcmp(key, "LSHIFT") == 0 || strcmp(key, "RSHIFT") == 0)  { shift ^= 1; return '\0'; }

  if (buf[0] == 'd') {
    if (key[0] >= 'A' && key[0] <= 'Z' && key[1] == '\0') {
      if (shift) return key[0];
      else return key[0] - 'A' + 'a';
    }
    for (auto item: SHIFT) {
      if (strcmp(item.name, key) == 0) {
        if (shift) return item.shift;
        else return item.noshift;
      }
    }
  }
  return '\0';
}

char handle_key(SDL_Event *ev) {
  static int shift = 0;
  int key = ev->key.keysym.sym;
  if (key == SDLK_LSHIFT || key == SDLK_RSHIFT) { shift ^= 1; return '\0'; }

  if (ev->type == SDL_KEYDOWN) {
    for (auto item: SHIFT) {
      if (item.keycode == key) {
        if (shift) return item.shift;
        else return item.noshift;
      }
    }
  }
  return '\0';
}
