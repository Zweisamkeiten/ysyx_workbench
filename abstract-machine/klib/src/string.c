#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

/*
 * strlen(): calculate the length of a string
 * The  strlen() function calculates the length
 * of the string pointed to by s, excluding the
 * terminating null byte ('\0').
 * if the "string" without terminating null byte, it is an undefined behavior
 */
size_t strlen(const char *s) {
  size_t len = 0;
  const char *char_ptr = s;

  while (*char_ptr != '\0') {
    len++;
    char_ptr++;
  }

  return len;
}

/*
 * strcpy - copy a string
 * Beware of buffer overruns!
 * if the dest string of a strcpy() is not
 * large enough, then anything might happen.
 */
char *strcpy(char *dst, const char *src) {
  return memcpy(dst, src, strlen(src) + 1);
}

/*
 * strncpy() - copy a string
 * at most 'n' bytes of src are copied.
 * Warning: If there is no null byte among the first 'n'
 * bytes of 'src', the string placed in 'dest' "will not" be null-terminated
 *
 * if the length of src is less than n, strncpy() writes additional null bytes to dest
 * to ensure that a total of 'n' bytes are written.
 */
char *strncpy(char *dst, const char *src, size_t n) {
  size_t size = strlen(src);
  if (size < n) {
    memset(dst + size, '\0', n - size);
  }
  return memcpy(dst, src, size);
}

/*
 * strcat - concatenate two strings
 */
char *strcat(char *dst, const char *src) {
  strcpy(dst + strlen(dst), src);
  return dst;
}

/*
 * strcmp - compare two strings
 */
int strcmp(const char *s1, const char *s2) {
  unsigned char c1 = '\0';
  unsigned char c2 = '\0';
  
  do {
    c1 = (unsigned char) *s1++;
    c2 = (unsigned char) *s2++;
    if (c1 == '\0') {
      return c1 - c2;
    }
  } while (c1 == c2);
  
  return c1 - c2;
}

/*
 * strncmp - compare two strings
 */
int strncmp(const char *s1, const char *s2, size_t n) {
  unsigned char c1 = '\0';
  unsigned char c2 = '\0';
  
  while (n > 0)
    {
      c1 = (unsigned char)*s1++;
      c2 = (unsigned char)*s2++;
      if (c1 == '\0' || c1 != c2)
        return c1 - c2;
      n--;
    }
  
  return c1 - c2;
}

/*
 * fill memory with a constant byte 'c'
 */
void *memset(void *s, int c, size_t n) {
  unsigned char *sp = (unsigned char *)s;

  for (size_t i = 0; i < n; i++) {
    *(sp + i) = c;
  }

  return sp;
}

/*
 * same as memcpy(), but memmove() first copies
 * memory area src to a temporary array to avoid memory areas overlap.
 * Then it copies array to dest.
 */
void *memmove(void *dst, const void *src, size_t n) {
  unsigned char *dstp = (unsigned char *)dst;
  unsigned char *srcp = (unsigned char *)src;

  unsigned char tmp[n];
  memcpy(tmp, srcp, n);

  return memcpy(dstp, tmp, n);
}

/*
 * memcpy() copies 'n' bytes from memory area src to memory area dest
 * The memory areas must not overlap(重叠).
 * Use memmove() if the memory areas do overlap.
 */
void *memcpy(void *out, const void *in, size_t n) {
  unsigned char *cin = (unsigned char *)in;
  unsigned char *cout = (unsigned char *)out;

  for (size_t i = 0; i < n; i++) {
    cout[i] = cin[i];
  }

  return cout;
}

/*
 * The memcmp() function compares the first n bytes
 * (each interpreted as unsigned char) of the memory areas s1 and s2. 
 */
int memcmp(const void *s1, const void *s2, size_t n) {
  unsigned char *s1p = (unsigned char *)s1;
  unsigned char *s2p = (unsigned char *)s2;
  int compareStatus = 0;

  // both pointer pointing same memory block
  if (s1 == s2) {
    return compareStatus;
  }

  for (size_t i = 0; i < n; i++) {
    if (*(s1p + i) != *(s2p + i)) {
      compareStatus = *(s1p + i) - *(s2p + i);
      break;
    }
  }

  return compareStatus;
}

#endif
