#include <am.h>
#include <nemu.h>
#include <klib.h>

static uint64_t boot_time = 0;

static uint64_t read_time() {
  volatile uint32_t lo = inl(RTC_ADDR);
  volatile uint32_t hi = inl(RTC_ADDR + 4);
  volatile uint64_t time = ((uint64_t)hi << 32) | lo;
  // uint64_t time = (((uint64_t)inl(RTC_ADDR + 4)) << 32) | inl(RTC_ADDR);
  return time;
}

void __am_timer_init() {
  boot_time = read_time();
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  uptime->us = read_time() - boot_time;
  // uptime->us = (((uint64_t)inl(RTC_ADDR + 4)) << 32) | inl(RTC_ADDR);
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
