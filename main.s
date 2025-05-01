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
	IMPORT UPDATE_Modes 


	AREA MYCODE, CODE, READONLY
    EXPORT __main
    ENTRY 
	
__main FUNCTION
	
	BL SETUP
	
	BL MQ2_Init
	BL LDR_Init
	
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
	;BL UPDATE_Modes 
	;BL DISPLAY_TEMP
	;BL DISPLAY_HUM
	
	;BL DHT11_READ           ; Call the DHT11 read function

	
MainLoop
	;mov R4, #5
	;mov r2, #6
	;mov r0,#115  ;X position
	;mov r1,#50 ;Y Position
	;BL DISPLAY_NUMBERS
	;BL 	delay_1_second
	;MOV R4, #4
	;mov r2, #6
	;mov r0,#115  ;X position
	;mov r1,#50 ;Y Position
	;BL DISPLAY_NUMBERS
	BL DHT11_READ           ; Call the DHT11 read function
	MOV R4, R8              ; Copy full 32-bit value to R4      
	AND R4, R4, #0xFF       ; Mask out upper bits ? only keep lowest 8 bits, clear bits 8–31
	mov r5,#10
	UDIV r4,r4,r5
	mov r2, #6
	mov r0,#115  ;X position
	mov r1,#50 ;Y Position
	BL DISPLAY_NUMBERS
	B MainLoop
	
	ENDFUNC
	END
