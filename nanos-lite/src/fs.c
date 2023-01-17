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

enum {FD_STDIN, FD_STDOUT, FD_STDERR, FD_FB, FD_SB, FD_SBCTL};

size_t invalid_read(void *buf, size_t offset, size_t len) {
  panic("should not reach here");
  return 0;
}

size_t invalid_write(const void *buf, size_t offset, size_t len) {
  panic("should not reach here");
  return 0;
}

extern size_t serial_write(const void *buf, size_t offset, size_t len);
extern size_t events_read(void *buf, size_t offset, size_t len);
extern size_t dispinfo_read(void *buf, size_t offset, size_t len);
extern size_t fb_write(const void *buf, size_t offset, size_t len);
extern size_t sb_write(const void *buf, size_t offset, size_t len);
extern size_t sbctl_read(void *buf, size_t offset, size_t len);
extern size_t sbctl_write(const void *buf, size_t offset, size_t len);

/* This is the information about all files in disk. */
static Finfo file_table[] __attribute__((used)) = {
  [FD_STDIN]  = {"stdin", 0, 0, invalid_read, invalid_write},
  [FD_STDOUT] = {"stdout", 0, 0, invalid_read, serial_write},
  [FD_STDERR] = {"stderr", 0, 0, invalid_read, serial_write},
  [FD_FB]     = {"/dev/fb", 0, 0, invalid_read, fb_write},
  [FD_SB]     = {"/dev/sb", 0, 0, invalid_read, sb_write},
  [FD_SBCTL]  = {"/dev/sbctl", 0, 0, sbctl_read, sbctl_write},

  {"/dev/events", 0, 0, events_read, invalid_write},
  {"/proc/dispinfo", 0, 0, dispinfo_read, invalid_write},

#include "files.h"
};

#define ARRLEN(arr) (int)(sizeof(arr) / sizeof(arr[0]))
#define NR_FILES ARRLEN(file_table)

void init_fs() {
  // initialize the size of /dev/fb
  int w = io_read(AM_GPU_CONFIG).width;
  int h = io_read(AM_GPU_CONFIG).height;
  file_table[FD_FB].size = w * h * 4; // 00RRGGBB 4byte
}

int fs_open(const char *pathname, int flags, int mode) {
  for (int i = 0; i < NR_FILES; i++) {
    if (strcmp(pathname, file_table[i].name) == 0) {
      return i;
    }
  }

  printf("cant find the pathname\n");
  return 1;
  // panic("cant find the pathname");
}

extern size_t ramdisk_read(void *buf, size_t offset, size_t len);
extern size_t ramdisk_write(const void *buf, size_t offset, size_t len);

size_t fs_read(int fd, void *buf, size_t len) {
  assert(0 <= fd && fd < NR_FILES);

  if (file_table[fd].size != 0 && file_table[fd].open_offset + len > file_table[fd].size) {
    len = file_table[fd].size - file_table[fd].open_offset;
  }

  if (file_table[fd].read == NULL) {
    size_t read_n = ramdisk_read(buf, file_table[fd].disk_offset + file_table[fd].open_offset, len);
    file_table[fd].open_offset += read_n;

    return read_n;
  } else {
    // vfs api
    size_t nread = file_table[fd].read(buf, file_table[fd].disk_offset + file_table[fd].open_offset, len);
    file_table[fd].open_offset += nread;
    return nread;
  }

}

size_t fs_write(int fd, const void *buf, size_t len) {
  assert(0 <= fd && fd < NR_FILES);

  // stdout stderr size == 0
  if (file_table[fd].size != 0 && file_table[fd].open_offset + len > file_table[fd].size) {
    len = file_table[fd].size - file_table[fd].open_offset;
  }

  if (file_table[fd].write == NULL) {
    size_t written_n = ramdisk_write(buf, file_table[fd].disk_offset + file_table[fd].open_offset, len);
    file_table[fd].open_offset += written_n;

    return written_n;
  } else {
    // vfs api
    size_t nwrite = file_table[fd].write(buf, file_table[fd].disk_offset + file_table[fd].open_offset, len);
    file_table[fd].open_offset += nwrite;
    return nwrite;
  }
}

size_t fs_lseek(int fd, size_t offset, int whence) {
  assert(0 <= fd && fd < NR_FILES);

  if (fd <= 2 || fd == FD_SB || fd == FD_SBCTL) {
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

#ifdef CONFIG_STRACE
char * trans_fd_to_filename(int fd) {
  return file_table[fd].name;
}
#endif
