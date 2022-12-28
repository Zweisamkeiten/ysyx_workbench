#include <fs.h>

typedef size_t (*ReadFn) (void *buf, size_t offset, size_t len);
typedef size_t (*WriteFn) (const void *buf, size_t offset, size_t len);

typedef struct {
  char *name;
  size_t size;
  size_t disk_offset;
  ReadFn read;
  WriteFn write;
  size_t open_offset;
} Finfo;

enum {FD_STDIN, FD_STDOUT, FD_STDERR, FD_FB};

size_t invalid_read(void *buf, size_t offset, size_t len) {
  panic("should not reach here");
  return 0;
}

size_t invalid_write(const void *buf, size_t offset, size_t len) {
  panic("should not reach here");
  return 0;
}

/* This is the information about all files in disk. */
static Finfo file_table[] __attribute__((used)) = {
  [FD_STDIN]  = {"stdin", 0, 0, invalid_read, invalid_write},
  [FD_STDOUT] = {"stdout", 0, 0, invalid_read, invalid_write},
  [FD_STDERR] = {"stderr", 0, 0, invalid_read, invalid_write},
#include "files.h"
};

#define ARRLEN(arr) (int)(sizeof(arr) / sizeof(arr[0]))
#define NR_FILES ARRLEN(file_table)

void init_fs() {
  // TODO: initialize the size of /dev/fb
}

int fs_open(const char *pathname, int flags, int mode) {
  for (int i = 0; i < NR_FILES; i++) {
    if (strcmp(pathname, file_table[i].name) == 0) {
      return i;
    }
  }

  panic("cant find the pathname");
}

extern size_t ramdisk_read(void *buf, size_t offset, size_t len);
extern size_t ramdisk_write(const void *buf, size_t offset, size_t len);

size_t fs_read(int fd, void *buf, size_t len) {
  assert(0 <= fd && fd < NR_FILES);

  if (fd <= 2) return 0;

  if (file_table[fd].open_offset + len > file_table[fd].size) {
    len = file_table[fd].size - file_table[fd].open_offset;
  }

  size_t read_n = ramdisk_read(buf, file_table[fd].disk_offset + file_table[fd].open_offset, len); 
  file_table[fd].open_offset += read_n;

  return read_n;
}

size_t fs_write(int fd, const void *buf, size_t len) {
  assert(0 <= fd && fd < NR_FILES);
  if (fd <= 2) {
    if (fd == 1 || fd == 2) {
      uint64_t written = 0;
      while (written <= len) {
        putch(*((char *)(buf) + written));
        written++;
      }
      return written;
    }
    return 0;
  } else {
    if (file_table[fd].open_offset + len > file_table[fd].size) {
      len = file_table[fd].size - file_table[fd].open_offset;
    }

    size_t written_n = ramdisk_write(buf, file_table[fd].disk_offset + file_table[fd].open_offset, len);
    file_table[fd].open_offset += written_n;

    return written_n;
  }
}

size_t fs_lseek(int fd, size_t offset, int whence) {
  assert(0 <= fd && fd < NR_FILES);

  if (fd <= 2) {
    return -1;
  }

  switch (whence) {
    case SEEK_SET: 
      {
        if (offset < file_table[fd].size) {
          file_table[fd].open_offset = offset;
          break;
        }
        // else TO SEEK_END
      }
    case SEEK_CUR: 
      {
        if (file_table[fd].open_offset + offset < file_table[fd].size) {
          file_table->open_offset += offset;
          break;
        }
        // else TO SEEK_END
      }
    case SEEK_END: file_table[fd].open_offset = file_table[fd].size; break;
    default: return -1;
  }

  return file_table[fd].open_offset;
}

int fs_close(int fd) {
  file_table[fd].open_offset = 0;
  // sfs has not file close state, return 0 as close success.
  return 0;
}
