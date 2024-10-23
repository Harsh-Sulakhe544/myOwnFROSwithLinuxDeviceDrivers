#include "timer.h"
#include "../drivers/display.h"
#include "../drivers/ports.h"
#include "../kernel/util.h"
#include "isr.h"

uint32_t tick = 0;

static void timer_callback(registers_t *regs) {
    tick++;
    print_string("Tick: ");

    char tick_ascii[256]; // Buffer to hold the ASCII representation of tick
    int_to_string(tick, tick_ascii); // Convert tick count to string - TICK-ASCII
    print_string(tick_ascii);
    print_nl();
}

void init_timer(uint32_t freq) {
    /* Install the function we just wrote */
    register_interrupt_handler(IRQ0, timer_callback);

    /* Get the PIT value: hardware clock at 1193180 Hz */
    uint32_t divisor = 1193180 / freq;
    uint8_t low  = (uint8_t)(divisor & 0xFF); // Get the low byte of the divisor
    uint8_t high = (uint8_t)( (divisor >> 8) & 0xFF); // Get the HIGH byte of the divisor
    
    /* Send the command */
    port_byte_out(0x43, 0x36); // Send command to the PIT (Programmable Interval Timer) /* Command port */
    port_byte_out(0x40, low);   // Send the low byte to the PIT
    port_byte_out(0x40, high);  // Send the high byte to the PIT
    
}
