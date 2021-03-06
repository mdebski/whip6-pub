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
 * @author Szymon Acedanski <accek@mimuw.edu.pl>
 */

configuration HplAUXInterruptsPub {
    provides interface ExternalEvent as SW0Int;
    provides interface ExternalEvent as SW1Int;
}
implementation{
    components HplCC26xxIntSrcPub as Sources;

    components new HplSimpleInterruptEventPrv() as SW0IntEvent;
    SW0IntEvent.InterruptSource -> Sources.AUXSW0;
    SW0Int = SW0IntEvent;

    components new HplSimpleInterruptEventPrv() as SW1IntEvent;
    SW1IntEvent.InterruptSource -> Sources.AUXSW1;
    SW1Int = SW1IntEvent;
}
