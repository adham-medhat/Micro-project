  ;; MQ2.s � standalone, self-contained
		INCLUDE TFT.s
        AREA    Flame_Module, CODE, READONLY
        EXPORT  Flame_Init
        EXPORT  Flame_Update
		;IMPORT DRAW_RECTANGLE_FILLED

; Base addresses for F1 (STM32F103C8T6)
;GPIOB_BASE     EQU     0x40010C00
;RCC_APB2ENR    EQU     0x40021018

; Offsets for GPIOB registers
;GPIO_CRL       EQU     0x00        ; config pins 0�7
;GPIO_IDR       EQU     0x08        ; input data register
;GPIO_ODR       EQU     0x0C        ; output data register

;-----------------------------------------
; MQ2_Init: enable GPIOB, set PB3 output, PB4 input
;-----------------------------------------
Flame_Init
    PUSH {R0-R2, LR}

    LDR R0, =GPIOB_CRL
    LDR R1, [R0]

    ; Configure PB0 as output push-pull
    BIC R1, R1, #(0xF << 0)      ; Clear bits 3:0 for PB0
    ORR R1, R1, #(0x2 << 0)      ; MODE0 = 10 (2 MHz), CNF0 = 00

    BIC R1, R1, #(0xF << 16)
	ORR R1, R1, #(0x4 << 16)

    STR R1, [R0]

    POP {R0-R2, PC}

;-----------------------------------------
; MQ2_Update: read PB4 ? drive PB3
;-----------------------------------------
Flame_Update
		PUSH {R0-R2, LR}                 ; Save working registers

    ; Read GPIOB input data register
		LDR R0, =GPIOB_IDR               ; Address of GPIOB input data register
		LDR R1, [R0]                     ; Read current input states

    ; Check PB5 (bit 5)
		TST R1, #(1 << 4)               ; Test if PB4 is HIGH or LOW

    ; If PB5 is HIGH (flame), skip to setting PB0
		BNE FLAME_DETECTED            ; Branch if bit  is nonzero 

    ; Flame not detected (PB5 is LOW), set PB0 low
		LDR R0, =(0x40010C0C)          ; GPIOB Output Data Register
		LDR R1, [R0]                ; Read current state
		BIC R1, R1, #0x01          ; TURN OFF PB0 (bit 0)
		STR R1, [R0]                ; Write back to GPIOB_ODR
		mov r0,#430
		mov r3,#460
		mov r1,#20
		mov r4,#50
		mov r10,#WHITE
		BL DRAW_RECTANGLE_FILLED
		B DONE 
FLAME_DETECTED
		LDR R0, =(0x40010C0C)          ; GPIOB Output Data Register
		LDR R1, [R0]                ; Read current state
		ORR R1, R1, #0x01           ; TURN ON PB0 (bit 0)
		STR R1, [R0]                ; Write back to GPIOB_ODR
		mov r0,#430
		mov r3,#460
		mov r1,#20
		mov r4,#50
		mov r10,#RED
		BL DRAW_RECTANGLE_FILLED
		B DONE 

 		; Skip the no-smoke path
    ; Optionally, clear PB0 if no smoke (uncomment if desired)
    ; LDR R0, =GPIOB_ODR
    ; LDR R1, [R0]
    ; BIC R1, R1, #0x01             ; Clear bit 0 (PB0 LOW)
    ; STR R1, [R0]

DONE
		POP {R0-R2, PC}                  ; Restore registers and return
		
		END