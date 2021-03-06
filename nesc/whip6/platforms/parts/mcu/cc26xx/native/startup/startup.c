//*****************************************************************************
//! @file       startup.c
//! @brief      Startup code for CC26xx for use with GCC.
//!
//! Revised     $Date: 2014-02-05 11:52:39 +0100 (on, 05 feb 2014) $
//! Revision    $Revision: 12073 $
//
//  Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com/
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//    Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
//    Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
//    Neither the name of Texas Instruments Incorporated nor the names of
//    its contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//****************************************************************************/

#include <stdint.h>
#include <string.h>
#include <inc/hw_types.h>
#include <inc/hw_sysctl.h>
#include <inc/hw_ints.h>
#include <driverlib/setup.h>


//*****************************************************************************
//
// The following are constructs created by the linker, indicating where the
// the "data" and "bss" segments reside in memory.  The initializers for the
// for the "data" segment resides immediately following the "text" segment.
//
//*****************************************************************************
extern uint8_t _ldata;
extern uint8_t _data;
extern uint8_t _edata;
extern uint8_t _bss;
extern uint8_t _ebss;
extern uint8_t _estack;


//*****************************************************************************
//
// Fault handlers
//
//*****************************************************************************

// Provided by cortex-m3/native/fault_handler.c
void HardFaultISR(void);
// Provided by cortex-m3/native/hal_process.c
void PendSVISR(void);

// Default implementation if not using context switching.
__attribute__((weak)) void PendSVISR(void) {
    for(;;);
}


//*****************************************************************************
//
// Function prototypes
//
//*****************************************************************************
extern int main (void);
void ResetISR(void);

#define INT(num, name) void name##Handler(void);
#include "../../interrupts/CC26xxIntSources.h"
#undef INT

__attribute__ ((section(".vectors"), used))
void (* const gVectors[])(void) =
{
    #define INT(num, name) [num] = name##Handler,
    #include "../../interrupts/CC26xxIntSources.h"
    #undef INT
    [ 0] = (void (*)(void))&_estack,  // Stack pointer
    [ 1] = ResetISR,                  // Reset handler
    [ 3] = HardFaultISR,              // Hadr fault
    [14] = PendSVISR,                 // Context switch
};


//*****************************************************************************
//
// Reset handler.
//
//*****************************************************************************


void
ResetISR (void)
{
    //
    // Final trim of device
    //
    trimDevice();

    //
    // Copy the data segment initializers from flash to SRAM.
    //
    memcpy(&_data, &_ldata, &_edata - &_data);

    //
    // Zero fill the bss segment.
    //
    memset(&_bss, 0, &_ebss - &_bss);

    //
    // Call the application's entry point.
    //
    main();

    //
    // End here if return from main()
    //
    for(;;);
}


