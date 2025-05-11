	INCLUDE DISPLAY.s
	;INCLUDE MQ2.s
	;INCLUDE DHT1.s
	;INCLUDE Timer1.s
	IMPORT DHT11_READ
    IMPORT UPDATE_Temp_Humidity
	IMPORT DISPLAY_HUM
	IMPORT DISPLAY_TEMP
	IMPORT  MQ2_Init
	IMPORT  MQ2_Update
	IMPORT  LDR_Init
    IMPORT  LDR_Update
	IMPORT TIMER2_INIT
	IMPORT  Flame_Init
    IMPORT  Flame_Update

	AREA MYCODE, CODE, READONLY
    EXPORT __main
    ENTRY 
	
__main FUNCTION
	
	BL SETUP

	
	;	; Enable clock for GPIOB
	;LDR R0, =RCC_APB2ENR   ; RCC_APB2ENR Address
	;LDR R1, [R0]
	;ORR R1, R1, #(1 << 3) ; Enable GPIOB clock
	;STR R1, [R0]
	;LDR     R2, [R0, #0x00]        ; Read GPIOB_CRL (for pins 0–7)
    ;BIC     R2, R2, #(0xF << (0 * 4)) ; Clear CNF0[1:0] + MODE0[1:0]
    ;ORR     R2, R2, #(0x2 << (0 * 4)) ; Set MODE0 = 10 (2 MHz output), CNF0 = 00 (GP push-pull)
    ;STR     R2, [R0, #0x00]        ; Write back to GPIOB_CRL
	  ; PB8 = 2 MHz push-pull output
    ;LDR     r1, [r0, #GPIOx_CRH]
    ;BIC     r1, r1, #(0xF << ((8-8)*4))         ; clear bits 0–3 (PB8)
    ;ORR     r1, r1, #(2 << ((8-8)*4))           ; MODE8=10, CNF8=00
    ;STR     r1, [r0, #GPIOx_CRH]

	
	mov r0,#0
	mov r3,#480
	mov r1,#0
	mov r4,#320
	mov r10,#WHITE
	BL DRAW_RECTANGLE_FILLED
	
	
	mov r0, #280
	mov r1, #200
	mov r2, #4
	mov r6, #25
	mov r11, #25
	LDR r3, =celsius_25
	BL DRAW_IMG
	
	mov r0, #280
	mov r1, #50
	mov r2, #4
	mov r6, #26
	mov r11, #20
	LDR r3, =percentage
	BL DRAW_IMG
	
	
	;Tens position of Temprature
	;mov r4,#2
	;mov r2, #6
	;mov r0,#115  ;X position
	;mov r1,#220  ;Y Position
	;BL DISPLAY_NUMBERS
	
	
	;Units position of Temprature
	;mov r4,#4
	;mov r2, #6
	;mov r0,#180
	;mov r1,#220
	;BL DISPLAY_NUMBERS
	
	
	;Tens position of Humidity
	;BL DHT11_READ           ; Call the DHT11 read function
	;MOV R4, R8              ; Copy full 32-bit value to R4
	;LSR R4, R4, #24         ; Shift right 24 ? move humidity int (bits 31–24) to bits 0–7
	;AND R4, R4, #0xFF       ; Mask out upper bits ? only keep lowest 8 bits, clear bits 8–31
	;mov r5,#10
	;UDIV r4,r4,r5
	;mov r2, #6
	;mov r0,#115  ;X position
	;mov r1,#50 ;Y Position
	;BL DISPLAY_NUMBERS
	
	
	;Units position of Humidity
	;mov r4,#4
	;mov r2, #6
	;mov r0,#180 ;X position
	;mov r1,#50 ;Y position
	;BL DISPLAY_NUMBERS

	
	;BL DHT11_READ           ; Call the DHT11 read function
    ; Write back to GPIOB_ODR

	BL TIMER2_INIT
	BL MQ2_Init
	BL Flame_Init

	;BL LDR_Init


MainLoop
	BL DHT11_READ
	;10s of humidity
	AND R1, R1, #0xFF 
	;mov r1,#62
	mov r5,#10
	udiv r4,r1,r5
	;mov r4,#3
	mov r2, #6
	mov r0,#115  ;X position
	mov r1,#50 ;Y Position
	BL DISPLAY_NUMBERS
	;1s of humidity
	AND R1, R1, #0xFF 
	mul r6,r4,r5
	sub r4,r1,r6
	mov r2, #6
	mov r0,#180 ;X position
	mov r1,#50 ;Y position
	BL DISPLAY_NUMBERS
	;10s of temp
	LSR R1, R8, #16
	AND R1, R1, #0xFF 
	;mov r1,#62
	mov r5,#10
	udiv r4,r1,r5
	;mov r4,#3
	mov r2, #6
	mov r0,#115  ;X position
	mov r1,#50 ;Y Position
	BL DISPLAY_NUMBERS
	;1s of temp
	LSR R1, R8, #16
	AND R1, R1, #0xFF 
	mul r6,r4,r5
	sub r4,r1,r6
	mov r2, #6
	mov r0,#180 ;X position
	mov r1,#50 ;Y position
	BL DISPLAY_NUMBERS
	;1s of humidity
	;LSR R1, R8, #0
	;AND R1, R1, #0xFF 
	;mov r1,#62
	;mul r4,r4,r5
	;sub r4,r1,r4
	;mov r4,#2
	;mov r2, #6
	;mov r0,#180 ;X position
	;mov r1,#50 ;Y position
	;BL DISPLAY_NUMBERS

	
	;BL 	delay_1_second
	;MOV R4, #4
	;mov r2, #6
	;mov r0,#115  ;X position
	;mov r1,#50 ;Y Position
	;BL DISPLAY_NUMBERS        
	BL MQ2_Update
	BL Flame_Update
	
	; Call the DHT11 read function
	;BL DHT11_READ
	;10s of temp
    ;LSR R1, R8, #16  ; Shift R8 16 bits to the right, so R1 holds the 3rd byte
	;AND R1, R1, #0xFF ; Mask out the other bytes, leaving only the 3rd byte
	;mov R5,#10
	;UDIV R4,R1,R5
	;MUL
	;mov r4,#3
	;mov r2, #6
	;mov r0,#115  ;X position
	;mov r1,#220  ;Y Position
	;BL DISPLAY_NUMBERS
	
	
	;mov r2, #6
	;mov r0,#180
	;mov r1,#220
	;BL DISPLAY_NUMBERS
	;10s of humidity
	;AND R1, R8, #0xFF ; Mask out the other bytes, leaving only the 3rd byte
	;mov R5,#10
	;UDIV R4,R1,R5
	;mov r2, #6
	;mov r0,#115  ;X position
	;mov r1,#50 ;Y Position
	;BL DISPLAY_NUMBERS
	;1s of humidity
	;MOV R4, R1       ; Copy value to R4
	;MOV R5, #10
;LOOP_SUB2
    ;CMP R4, R5
    ;BLT DONE2
    ;SUB R4, R4, R5
    ;B LOOP_SUB2
;DONE2
	;mov r2, #6
	;mov r0,#180 ;X position
	;mov r1,#50 ;Y position
	;BL DISPLAY_NUMBERS
	
	
; R4 now contains R1 mod 10 (last digit)
	

 
;clear_PB0
    ;LDR R0, =0x40010C10
    ;MOV R3, #(1 << 16)
    ;STR R3, [R0]
;after_PB0
    ;B MainLoop
	
    ; Extract TEMP_INT (bits 16-23)
    ;LSR R2, R8, #16          ; Shift right by 16 bits
    ;AND R2, R2, #0xFF
	;MOV R5,#10
	;UDIV R2,R2,R5
	;;MOV R4,R2
	;mov r2, #6
	;mov r0,#115  ;X position
	;mov r1,#220  ;Y Position
	;BL DISPLAY_NUMBERS
	B MainLoop
	
	ENDFUNC
	END