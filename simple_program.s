         .include "address_map_arm.s"

          .text
          .global _start
_start:
    // Initialize GPIO for LED control
    ldr r4, =0xFF200074 // Address for setting direction of GPIO pins
    ldr r2, =0xFF // Set D0, D1, D2 as outputs
    str r2, [r4]
	ldr r1, =JP2_BASE
 ldr r9, =ADC_BASE
	mov r11,#1
	str r11,[r9]
 	
loop:
	ldr r2, =0b0100 // Turn on D2 as default state
    str r2, [r1]
    // Read ADC value
   

    // Determine traffic light state based on ADC value
	
green_on:
    // Turn on green LED
    mov r2, #0b0100 // Turn on D2
    str r2, [r1]
	LDR r5, [r9,#8] // Ch2
	bl delay
	LSR r5,r5, #2 // shift 2 bits to align with LEDR_BASE
    // Read ADC value from specified channel
	LDR r3, = LEDR_BASE
	STR r5, [r3]
	ldr r10, =0x3FF
	Cmp r5, r10
	Bge yellow_on
    b loop

yellow_on:
    // Turn on yellow LED
    mov r2, #0b0010 // Turn on D1 
    str r2, [r1]
	bl delay
red_on:
    // Turn on red LED
    mov r2, #0b0001 // Turn on D0 
    str r2, [r1]
	bl delay
    b loop

delay:
	LDR r7, = 0xFFFFFA69 //delay 
delay_loop:
	SUB r7, #1
	CMP r7, #1
	BNE delay_loop
	bx lr
.end


