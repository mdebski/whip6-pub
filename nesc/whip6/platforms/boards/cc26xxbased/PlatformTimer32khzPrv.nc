/*
 * whip6: Warsaw High-performance IPv6.
 *
 * Copyright (c) 2012-2016 InviNets Sp z o.o.
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached LICENSE     
 * files. If you do not find these files, copies can be found by writing
 * to technology@invinets.com.
 */

#include "PlatformTimerPrv.h"

configuration PlatformTimer32khzPrv {
  provides interface Timer<T32khz, uint32_t> as Timer32khz[uint8_t id];
  provides interface TimerOverflow;
}
implementation {
  components HalCC26xxRTCPub as HalTimer;
  components new TimerMuxPub(T32khz, uint32_t, uniqueCount(UQ_TIMER_32KHZ));
  TimerMuxPub.TimerFrom -> HalTimer;
  Timer32khz = TimerMuxPub;
  TimerOverflow = HalTimer;
}
