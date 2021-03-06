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

/**
 * @author Szymon Acedanski
 */

#include "hal_power.h"

generic configuration CC26xxWakeUpSourcePub(uint32_t source) {
    provides interface CC26xxWakeUpSource;
}
implementation {
    enum {
        CHANNEL_ID = unique(HAL_POWER_WAKEUP_CHANNEL),
    };

    components new CC26xxWakeUpSourcePrv(CHANNEL_ID, source) as Impl;
    CC26xxWakeUpSource = Impl;
}
