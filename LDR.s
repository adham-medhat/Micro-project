;; MQ2.s — PB7 as input, PB8 as output
		INCLUDE DEFINITIONS.s
        AREA    LDR_Module, CODE, READONLY
        EXPORT  LDR_Init
        EXPORT  LDR_Update

; Base addresses for F1 (STM32F103C8T6)
;GPIOB_BASE     EQU     0x40010C00
;RCC_APB2ENR    EQU     0x40021018

; Offsets for GPIOB registers
;GPIO_CRH       EQU     0x04        ; config pins 8–15
;GPIO_IDR       EQU     0x08        ; input data register
;GPIO_ODR       EQU     0x0C        ; output data register

;-----------------------------------------
; MQ2_Init: enable GPIOB, set PB7 input, PB8 output
;-----------------------------------------
LDR_Init
        PUSH    {r0-r12, lr}

        ; Enable GPIOB clock (IOPBEN = bit 3)
        LDR     r0, =RCC_APB2ENR
        LDR     r1, [r0]
        ORR     r1, r1, #(1 << 3)
        STR     r1, [r0]

        ; PB7 = floating input
        LDR     r0, =GPIOB_BASE
        LDR     r1, [r0, #GPIOx_CRH]
        BIC     r1, r1, #(0xF << ((7-8)*4 + 28))    ; clear bits 28–31 (PB7)
        ORR     r1, r1, #(1 << ((7-8)*4 + 30))      ; CNF7=01, MODE7=00
        STR     r1, [r0, #GPIOx_CRH]

        ; PB8 = 2 MHz push-pull output
        LDR     r1, [r0, #GPIOx_CRH]
        BIC     r1, r1, #(0xF << ((8-8)*4))         ; clear bits 0–3 (PB8)
        ORR     r1, r1, #(2 << ((8-8)*4))           ; MODE8=10, CNF8=00
        STR     r1, [r0, #GPIOx_CRH]

        POP     {r0-r12, pc}


;-----------------------------------------
; MQ2_Update: read PB7 ? drive PB8
;-----------------------------------------
LDR_Update
        PUSH    {r0-r12, lr}

        LDR     r0, =GPIOB_BASE

        ; Read PB7
        LDR     r1, [r0, #GPIOx_IDR]
        ANDS    r1, r1, #(1 << 7)          ; isolate bit 7
        BNE     set_high

clear_low
        ; Clear PB8
        LDR     r2, [r0, #GPIOx_ODR]
        BIC     r2, r2, #(1 << 8)
        STR     r2, [r0, #GPIOx_ODR]
        B       done
		
set_high
        ; Set PB8
        LDR     r2, [r0, #GPIOx_ODR]
        ORR     r2, r2, #(1 << 8)
        STR     r2, [r0, #GPIOx_ODR]

done
        POP     {r0-r12, pc}

        END