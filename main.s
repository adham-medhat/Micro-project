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
	;mov r4,#7
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
	
	BL DISPLAY_TEMP
	BL DISPLAY_HUM
	
MainLoop
	BL UPDATE_Temp_Humidity
	;BL MQ2_Update
	;BL LDR_Update
	B MainLoop
	
	ENDFUNC
	END
