/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NPC is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#ifndef __COMMON_H__
#define __COMMON_H__

#include <stdint.h>
#include <inttypes.h>
#include <stdbool.h>
#include <string.h>
#include <macro.h>
#include <conf.h>
#include <generated/autoconf.h>

#include <assert.h>
#include <stdlib.h>
typedef uint64_t word_t;
typedef int64_t  sword_t;
#define FMT_WORD "0x%016lx"

typedef word_t vaddr_t;
typedef uint64_t paddr_t;
#define FMT_PADDR "0x%016lx"

#include <debug.h>

#ifdef CONFIG_FTRACE
#include <elf.h>
typedef Elf64_Ehdr Elf_Ehdr;
typedef Elf64_Shdr Elf_Shdr;
typedef Elf64_Addr Elf_Addr;
typedef Elf64_Sym Elf_Sym;
#define ELF_ST_TYPE(val) ELF64_ST_TYPE(val)

#endif

#endif
