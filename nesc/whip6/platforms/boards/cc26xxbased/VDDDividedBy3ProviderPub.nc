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

#include "DimensionTypes.h"

generic configuration VDDDividedBy3ProviderPub() {
  provides interface DimensionalRead<TMilliVolt, int16_t> as VDDDividedBy3;
}
implementation {
  components new HalMCUVoltagePub();
  VDDDividedBy3 = HalMCUVoltagePub.VDDDividedBy3;
}

