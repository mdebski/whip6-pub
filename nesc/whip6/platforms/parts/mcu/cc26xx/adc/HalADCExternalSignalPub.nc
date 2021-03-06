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
 * Exposes interfaces for reading the ADC in a single-read mode.
 *
 * @author Michal Marschall <m.marschall@invinets.com>
 * @author Szymon Acedanski
 */

#include "adc.h"
#include "DimensionTypes.h"
#include "hal_adc_resource.h"

generic configuration HalADCExternalSignalPub() {
    provides interface DimensionalRead<TMilliVolt, int16_t>;
    uses interface CC2538Pin as Pin;
}
implementation {
    enum { 
        USER_ID = unique(HAL_ADC_RESOURCE),
    };
    
    components HalADCSingleReadArbPrv as SubADC;
    components new HalADCSingleReadAutoArbPrv() as ADC;

    ADC.ArbiterInfo -> SubADC.ArbiterInfo;
    ADC.Resource -> SubADC.Resource[USER_ID];
    ADC.SubRead -> SubADC.ReadSource;

    components new HalADCExternalSignalPrv(USER_ID) as Impl;
    Impl.SubRead -> ADC.ReadSource;
    Impl.Pin -> Pin;
    DimensionalRead = Impl.Read;
}
