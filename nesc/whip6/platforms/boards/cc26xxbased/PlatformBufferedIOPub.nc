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

configuration PlatformBufferedIOPub {
    provides interface BufferedRead;
    provides interface BufferedWrite;
}
implementation {
    components BufferedUART0ProviderPub;
    BufferedRead = BufferedUART0ProviderPub;
    BufferedWrite = BufferedUART0ProviderPub;
}
