#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

/*
 * Code adapted from bsdlibc, glibc, and
 * https://github.com/MrBad/vsnprintf/blob/master/vsnprintf.c
 */
enum {
  S_DEFAULT,
  S_FLAGS,
  S_WIDTH,
  S_PRECIS,
  S_LENGTH,
  S_CONV
};

enum {
  L_CHAR = 1,
  L_SHORT,
  L_LONG,
  L_LLONG
};

void buf_w(char *buffer, int pos, size_t size, int ch) {
  if (buffer != NULL && pos < size)
    *(buffer + pos) = ch;
}

int printf(const char *fmt, ...) {
  int ret;
	va_list ap;

	va_start(ap, fmt);
	ret = vsnprintf(NULL, 0, fmt, ap);
	va_start(ap, fmt);
  char serial_buf[ret+1];
	ret = vsprintf(serial_buf, fmt, ap);
	va_end(ap);
  putstr(serial_buf);
	return (ret);
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  return vsnprintf(out, -1, fmt, ap);
}

int sprintf(char *out, const char *fmt, ...) {
  int ret;
	va_list ap;

	va_start(ap, fmt);
	ret = vsprintf(out, fmt, ap);
	va_end(ap);
	return (ret);
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  int ret;
	va_list ap;

	va_start(ap, fmt);
	ret = vsnprintf(out, n, fmt, ap);
	va_end(ap);
	return (ret);
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  int state = 0;                            // default S_DEFAULT
  int ch;                                   // character from fmt because char undefinedcharactor from fmt, 0-255
  const char *cp;                                 // handy char pointer (for short terms)
  int /* flags, width, precision, */ lflags = 0;  // flags as above
  int ret = 0;                              // return value accumulator

  for (;;) {
    ch = *fmt;
    fmt++;

    if (ch == '\0')
      break;

    if (state == S_DEFAULT) {
      if (ch == '%') {
        fmt--;
        state = S_FLAGS;
        // flags = 0;
      }
      else {
        buf_w(out, ret++, n, ch);
      }
    } 
    else if (state == S_FLAGS) {
      // p: 413
      switch (ch) {
        case '-': break;
        case '+': break;
        case ' ': break;
        case '#': break;
        case '0': break;
        default: fmt--; /* width = 0 */; state = S_WIDTH;
      }
    }
    else if (state == S_WIDTH) {
      /* TODO */
      /* switch (ch) {
        case '*': width = va_arg(ap, int);
      } */
      fmt--;
      state = S_PRECIS;
    }
    else if (state == S_PRECIS) {
      /* TODO */
      fmt--;
      state = S_LENGTH;
    }
    else if (state == S_LENGTH) {
      switch (ch) {
        case 'l': lflags = (lflags == L_LONG) ?  L_LLONG : L_LONG; break;
        default: fmt--; state = S_CONV;
      }
    }
    else if (state == S_CONV) {
      signed long long int signed_num;
      int base = 10;
      switch (ch) {
        case 'i':
        case 'd': {
          switch (lflags) {
            case L_LONG: signed_num = va_arg(ap, long); break;
            case L_LLONG: signed_num = va_arg(ap, long long); break;
            default: signed_num = va_arg(ap, int); break;
          }

          char nbuf[64];
          int bufidx = 0;
          if (signed_num < 0) {
            buf_w(out, ret++, n, '-');
            signed_num = -signed_num;
          }
          do {
            nbuf[bufidx++] = signed_num % 10 + '0';
            signed_num= signed_num/base;
            ret++;
          } while (signed_num!= 0);

          // reverse
          while (bufidx != 0)
          {
            buf_w(out, ret-bufidx, n, nbuf[bufidx-1]);
            bufidx--;
          }

          break;
        }
        case 'o': base = 8; goto unsigned_convert;
        case 'x':
        case 'X': base = 16; goto unsigned_convert;
        case 'u': {
          unsigned long long int unsigned_num;
unsigned_convert:
          switch (lflags) {
            case L_LONG: unsigned_num = va_arg(ap, unsigned long int); break;
            case L_LLONG: unsigned_num = va_arg(ap, unsigned long long int); break;
            default: unsigned_num = va_arg(ap, unsigned int); break;
          }

          int write_flag = 0;
          int shift_pos = 0;
          if (base == 16) {
            do {
              unsigned int num = (unsigned_num >> 60) & 0xf;
              unsigned_num = unsigned_num << 4;
              shift_pos += 4;
              if (write_flag == 0 && num != 0) write_flag = 1;
              if (write_flag == 1) buf_w(out, ret++, n, (num > 9) ? num - 10 + 'a' : num + '0');
            } while (shift_pos < 64);
            if (write_flag == 0) buf_w(out, ret++, n, '0');
          } else if (base == 8) {
            do {
              unsigned int num = (unsigned_num >> 61) & 0x7;
              unsigned_num = unsigned_num << 3;
              shift_pos += 3;
              if (write_flag == 0 && num != 0) write_flag = 1;
              if (write_flag == 1) buf_w(out, ret++, n, (num > 9) ? num - 10 + 'a' : num + '0');
            } while (shift_pos < 64);
            if (write_flag == 0) buf_w(out, ret++, n, '0');
          } else if (base == 10) {
            char nbuf[64];
            int bufidx = 0;
            do {
              nbuf[bufidx++] = unsigned_num % 10 + '0';
              unsigned_num= unsigned_num/base;
              ret++;
            } while (unsigned_num!= 0);

            // reverse
            while (bufidx != 0)
              {
                buf_w(out, ret-bufidx, n, nbuf[bufidx-1]);
                bufidx--;
              }
          }

          break;
        }
        case 'p': {
          base = 16;
          unsigned long long int unsigned_num = (unsigned long long int)va_arg(ap, void *);
          int write_flag = 0;
          int shift_pos = 0;
          do {
            unsigned int num = (unsigned_num >> 60) & 0xf;
            unsigned_num = unsigned_num << 4;
            shift_pos += 4;
            if (write_flag == 0 && num != 0) write_flag = 1;
            if (write_flag == 1) buf_w(out, ret++, n, (num > 9) ? num - 10 + 'a' : num + '0');
          } while (shift_pos < 64);
          if (write_flag == 0) buf_w(out, ret++, n, '0');
          break;
        }
        case 's': {
          cp = va_arg(ap, char *);
          while (*cp != '\0') {
            buf_w(out, ret++, n, *cp++);
          }
          break;
        }
        case '%': {
          buf_w(out, ret++, n, '%');
          break;
        }
        case 'c': {
          char ch = va_arg(ap, int);
          buf_w(out, ret++, n, ch);
          break;
        }
      }
      state = S_DEFAULT;
      buf_w(out, n - 1, n, '\0');
    }
  }
  return ret;
}

#endif
