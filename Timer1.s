	INCLUDE DEFINITIONS.s  ; Include the file with register definitions
	EXPORT TIMER2_INIT
	;EXPORT TIMER3_INIT
	;EXPORT TIMER4_INIT

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
	
	
	
	
;TIMER3_INIT
	
	;PUSH {R0-R12,LR}
    ; Enable TIM3 Clock in RCC_APB1ENR
    ;LDR R0, =RCC_APB1ENR          ; RCC_APB1ENR address
    ;LDR R1, [R0]                  ; Read current value
    ;ORR R1, R1, #0x02             ; Set bit 0 to enable TIM3 clock
    ;STR R1, [R0]                  ; Write back to RCC_APB1ENR
	
	; Configure TIM3 Prescaler (PSC)
    ;LDR R0, =TIM3_PSC            ; TIM3 base address
    ;LDR R1, =64000            ; Prescaler value (for ~1 kHz if clock is 72 MHz)
    ;STR R1, [R0]           ; Write to TIM2_PSC
	
	; Configure TIM3 Auto-Reload Register (ARR)
	;LDR R0,=TIM3_ARR
    ;LDR R1, =1125             ; Auto-reload value (1-second period at 1 kHz)
    ;STR R1, [R0]           ; Write to TIM3_ARR
	
	; Enable Timer Update Interrupt
	;LDR R0,=TIM3_DIER
    ;LDR R1, [R0]           ; Read TIM3_DIER (Interrupt Enable Register)
    ;ORR R1, R1, #0x01             ; Enable Update Interrupt (UIE, bit 0)
    ;STR R1, [R0]           ; Write back to TIM3_DIER
	
	;LDR R0, =NVIC_ISER0    ; Address of NVIC_ISER0
	;LDR R1,[R0]
	;ORR R1,R1, #(1 << 29)     ; TIM3 IRQ is bit 29
	;STR R1, [R0]           ; Enable TIM3 interrupt

    ; Start the Timer
    ;LDR R0, =TIM3_CR1            ; Base address of TIM3
	;LDR R1, [R0]           ; Read TIM3_CR1 (Control Register 1)
	;ORR R1, R1, #0x01             ; Set CEN bit (bit 0) to start the timer
	;STR R1, [R0]           ; Write back to TIM3_CR1
	
	;POP {R0-R12,PC}
	
	
;TIMER4_INIT
	
	;PUSH {R0-R12,LR}
    ; Enable TIM4 Clock in RCC_APB1ENR
    ;LDR R0, =RCC_APB1ENR          ; RCC_APB1ENR address
    ;LDR R1, [R0]                  ; Read current value
    ;ORR R1, R1, #0x04             ; Set bit 0 to enable TIM4 clock
    ;STR R1, [R0]                  ; Write back to RCC_APB1ENR
	
	; Configure TIM4 Prescaler (PSC)
    ;LDR R0, =TIM4_PSC            ; TIM2 base address
    ;LDR R1, =64000            ; Prescaler value (for ~1 kHz if clock is 72 MHz)
    ;STR R1, [R0]           ; Write to TIM4_PSC
	
	; Configure TIM4 Auto-Reload Register (ARR)
	;LDR R0,=TIM4_ARR
    ;LDR R1, =1125             ; Auto-reload value (1-second period at 1 kHz)
    ;STR R1, [R0]           ; Write to TIM4_ARR
	
	; Enable Timer Update Interrupt
	;LDR R0,=TIM4_DIER
    ;LDR R1, [R0]           ; Read TIM4_DIER (Interrupt Enable Register)
    ;ORR R1, R1, #0x01             ; Enable Update Interrupt (UIE, bit 0)
    ;STR R1, [R0]           ; Write back to TIM4_DIER
	
	;LDR R0, =NVIC_ISER0    ; Address of NVIC_ISER0
	;LDR R1,[R0]
	;ORR R1,R1, #(1 << 30)     ; TIM4 IRQ is bit 30
	;STR R1, [R0]           ; Enable TIM4 interrupt

    ; Start the Timer
    ;LDR R0, =TIM4_CR1            ; Base address of TIM4
	;LDR R1, [R0]           ; Read TIM4_CR1 (Control Register 1)
	;ORR R1, R1, #0x01             ; Set CEN bit (bit 0) to start the timer
	;STR R1, [R0]           ; Write back to TIM4_CR1
	
	;POP {R0-R12,PC}