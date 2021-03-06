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

configuration HalUART0PinsPub {
    uses interface CC26xxPin as RX @atmostonce();
    uses interface CC26xxPin as TX @atmostonce();

    provides interface CC26xxPin as PRX @atmostonce();
    provides interface CC26xxPin as PTX @atmostonce();
}

implementation {
    PRX = RX;
    PTX = TX;
}
