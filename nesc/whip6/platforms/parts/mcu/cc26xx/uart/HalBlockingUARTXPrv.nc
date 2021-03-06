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
 * A generic configuration that exposes an UART in blocking mode.
 *
 * @author Konrad Iwanicki
 * @author Przemyslaw Horban
 * @author Szymon Acedanski
 */
generic configuration HalBlockingUARTXPrv(
        uint32_t uartBase,
        uint32_t baud
)
{
    provides
    {
        interface Init @exactlyonce();
        interface BlockingRead<uint8_t>;
        interface BlockingWrite<uint8_t>;
    }
    uses
    {
        interface CC26xxPin as RXPin;
        interface CC26xxPin as TXPin;
        interface ShareableOnOff as PowerDomain;
        interface ExternalEvent as Interrupt @exactlyonce();
    }
}
implementation
{
    // Can't use FIFO, because of no TX-complete interrupt,
    // see HalUARTBlockingWritePrv.nc.
    components new HalConfigureUARTPrv(uartBase, baud, FALSE) as CfgPrv;

    components new HalUARTBlockingReadPrv(uartBase) as UARTReadPrv;
    components new HalUARTBlockingWritePrv(uartBase) as UARTWritePrv;

    CfgPrv.PowerDomain = PowerDomain;
    CfgPrv.RXPin = RXPin;
    CfgPrv.TXPin = TXPin;
    CfgPrv.Interrupt = Interrupt;

    components HalCC26xxSleepPub;
    CfgPrv.ReInitRegisters <- HalCC26xxSleepPub.AtomicAfterDeepSleepInit;

    components new HalAskBeforeSleepPub();
    UARTWritePrv.AskBeforeSleep -> HalAskBeforeSleepPub;

    Init = CfgPrv.Init;
    BlockingRead = UARTReadPrv;
    BlockingWrite = UARTWritePrv;

    Interrupt = UARTWritePrv.Interrupt;
}
