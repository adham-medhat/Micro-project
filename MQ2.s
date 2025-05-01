  ;; MQ2.s — standalone, self-contained
		INCLUDE DEFINITIONS.s
        AREA    MQ2_Module, CODE, READONLY
        EXPORT  MQ2_Init
        EXPORT  MQ2_Update

; Base addresses for F1 (STM32F103C8T6)
;GPIOB_BASE     EQU     0x40010C00
;RCC_APB2ENR    EQU     0x40021018

; Offsets for GPIOB registers
;GPIO_CRL       EQU     0x00        ; config pins 0–7
;GPIO_IDR       EQU     0x08        ; input data register
;GPIO_ODR       EQU     0x0C        ; output data register

;-----------------------------------------
; MQ2_Init: enable GPIOB, set PB3 output, PB4 input
;-----------------------------------------
MQ2_Init
        PUSH    {r0-r12, lr}

        ; Enable GPIOB clock (IOPBEN = bit 3)
        LDR     r0, =RCC_APB2ENR
        LDR     r1, [r0]
        ORR     r1, r1, #(1 << 3)
        STR     r1, [r0]

        ; PB3 = 2 MHz push-pull output
        LDR     r0, =GPIOB_BASE
        LDR     r1, [r0, #GPIOx_CRL]
        BIC     r1, r1, #(0xF << (3*4))     ; clear bits 12–15
        ORR     r1, r1, #(2 << (3*4))       ; MODE3=10, CNF3=00
        STR     r1, [r0, #GPIOx_CRL]

        ; PB4 = floating input
        LDR     r1, [r0, #GPIOx_CRL]
        BIC     r1, r1, #(0xF << (4*4))     ; clear bits 16–19
        ORR     r1, r1, #(1 << ((4*4)+2))   ; CNF4=01, MODE4=00
        STR     r1, [r0, #GPIOx_CRL]

        POP     {r0-r12, pc}


;-----------------------------------------
; MQ2_Update: read PB4 ? drive PB3
;-----------------------------------------
MQ2_Update
        PUSH    {r0-r12, lr}

        LDR     r0, =GPIOB_BASE

        ; Read PB4
        LDR     r1, [r0, #GPIOx_IDR]
        ANDS    r1, r1, #(1 << 4)          ; isolate bit 4
        BNE     set_high

clear_low
        ; Clear PB3
        LDR     r2, [r0, #GPIOx_ODR]
        BIC     r2, r2, #(1 << 3)
        STR     r2, [r0, #GPIOx_ODR]
        B       done

set_high
        ; Set PB3
        LDR     r2, [r0, #GPIOx_ODR]
        ORR     r2, r2, #(1 << 3)
        STR     r2, [r0, #GPIOx_ODR]

done
        POP     {r0-r12, pc}

        END