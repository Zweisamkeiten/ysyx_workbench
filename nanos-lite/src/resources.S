.section .data
.global ramdisk_start, ramdisk_end
ramdisk_start:
.align 3
.incbin "build/ramdisk.img"
ramdisk_end:

.section .rodata
.globl logo
logo:
.align 3
.incbin "resources/logo.txt"
.byte 0
