	INCLUDE DEFINITIONS.s  ; Include the file with register definitions
	EXPORT TIMER2_INIT


    AREA MYCODE, CODE, READONLY

TIMER2_INIT

    PUSH {R0-R3, LR}              ; Save working registers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Enable Port B for testing
    LDR R0 ,=RCC_APB2ENR ;to enable port B
	LDR R1,[R0]
	ORR R1,R1,#8
	STR R1,[R0]

    LDR R0, =GPIOB_CRL ;to configure first pin of port B as output(medium speed)
	LDR R1,[R0]
	bic r1,r1,#0x0F
	ORR R1,R1,#0x01
	STR R1,[R0]
	
;	LDR R0, =0x40010C0C         ; GPIOB Output Data Register
;    LDR R1, [R0]                ; Read current state
;    ORR R1, R1, #0x01           ; Turn on the LED PB0 (bit 0)
;    STR R1, [R0] 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Enable TIM2 Clock in RCC_APB1ENR
    LDR R0, =RCC_APB1ENR          ; RCC_APB1ENR address
    LDR R1, [R0]                  ; Read current value
    ORR R1, R1, #0x01             ; Set bit 0 to enable TIM2 clock
    STR R1, [R0]                  ; Write back to RCC_APB1ENR

    ; Configure TIM2 Prescaler (PSC)
    LDR R0, =TIM2_BASE            ; TIM2 base address
    LDR R1, =72             ; Prescaler value (for 1 kHz if clock is 16 MHz)
    STR R1, [R0, #0x28]           ; Write to TIM2_PSC

    ; Configure TIM2 Auto-Reload Register (ARR)
    LDR R1, =0xFFFF              ; Auto-reload value (1-second period at 1 kHz)
    STR R1, [R0, #0x2C]           ; Write to TIM2_ARR

    ; Enable Timer Update Interrupt
;    LDR R1, [R0, #0x0C]           ; Read TIM2_DIER (Interrupt Enable Register)
;    ORR R1, R1, #0x01             ; Enable Update Interrupt (UIE, bit 0)
;    STR R1, [R0, #0x0C]           ; Write back to TIM2_DIER

;	LDR R0, =0xE000E100    ; Address of NVIC_ISER0
;	MOV R1, #(1 << 28)     ; TIM2 IRQ is bit 28
;	STR R1, [R0]           ; Enable TIM2 interrupt

    ; Start the Timer
    LDR R0, =TIM2_BASE            ; Base address of TIM2
	LDR R1, [R0, #0x00]           ; Read TIM2_CR1 (Control Register 1)
	ORR R1, R1, #0x01             ; Set CEN bit (bit 0) to start the timer
	STR R1, [R0, #0x00]           ; Write back to TIM2_CR1

    POP {R0-R3, PC}               ; Restore registers and return

	END