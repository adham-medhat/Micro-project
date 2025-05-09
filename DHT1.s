	INCLUDE DEFINITIONS.s  ; Include the file with register definitions
	EXPORT DHT11_READ
	EXPORT DELAY_MICROSECONDS
    AREA MYCODE, CODE, READONLY
		
DHT11_READ
    PUSH {R0-R7, LR}             ; Save working registers
;	; Enable clock for GPIOB
;	LDR R0, =RCC_APB2ENR   ; RCC_APB2ENR Address
;	LDR R1, [R0]
;	ORR R1, R1, #(1 << 3) ; Enable GPIOB clock
;	STR R1, [R0]

	;configure PB9 as output
	LDR R0, =GPIOB_CRH
    LDR R1, [R0]
    BIC R1, R1, #(0xF << 4)     ; Clear PB9 configuration
    ORR R1, R1, #(0x3 << 4)     ; Configure PB9 as Output, 10MHz
    STR R1, [R0]
	
	;set PB9 as low
	LDR R0, =GPIOB_ODR           ; Access GPIOB Output Data Register
    LDR R1, [R0]
    BIC R1, R1, #(1 << 9)       ; PB9 = Low
    STR R1, [R0]
	

	MOV R2, #18000               ; 18 ms delay
    BL DELAY_MICROSECONDS
	


	;set PB9 as high
	LDR R0, =GPIOB_ODR           ; Access GPIOB Output Data Register
    LDR R1, [R0]
	ORR R1, R1, #(1 << 9)       ; PB9 = High
    STR R1, [R0]


	
    MOV R2, #30                  ; 30 µs delay
    BL DELAY_MICROSECONDS
	

	
	;configure PB14 as input
	LDR R0, =GPIOB_CRH
    LDR R1, [R0]
    BIC R1, R1, #(0xF << 4)     ; Clear PB9 configuration
    ORR R1, R1, #(0x8 << 4)     ; Input Mode with Pull-Up
    STR R1, [R0]
	

	MOV R2, #40                  ; 40 µs delay
    BL DELAY_MICROSECONDS

	
WAIT_LOW
	LDR R0, =GPIOB_IDR           ; Input Data Register
    LDR R1, [R0]
    TST R1, #(1 << 9)           ; Wait for PB9 to go Low
    BNE WAIT_LOW

	MOV R2, #80                  ; 40 µs delay
    BL DELAY_MICROSECONDS
	
WAIT_HIGH
	LDR R0, =GPIOB_IDR           ; Input Data Register
    LDR R1, [R0]
    TST R1, #(1 << 9)           ; Wait for PB9 to go High
    BEQ WAIT_HIGH

    MOV R6, #5                   ; Total bytes to read
    MOV R7, #0                   ; Bit position (0, 8, 16, 24)
    MOV R8, #0                   ; Clear R8 for storing the 4 bytes

READ_BYTE_LOOP

    MOV R4, #0                   ; Clear current byte buffer
    MOV R5, #8                   ; Bits per byte

READ_BIT_LOOP
    ; Wait for PB9 to go Low 

WAIT_BIT_LOW
	LDR R0, =GPIOB_IDR           ; Input Data Register
    LDR R1, [R0]
    TST R1, #(1 << 9)
    BNE WAIT_BIT_LOW
	

    ; Wait for PB9 to go High
WAIT_BIT_HIGH
	LDR R0, =GPIOB_IDR           ; Input Data Register
    LDR R1, [R0]
    TST R1, #(1 << 9)
    BEQ WAIT_BIT_HIGH
	
	
	MOV R2, #0
WAIT_ZERO
	LDR R0, =GPIOB_IDR           ; Input Data Register
    LDR R1, [R0]
	ADD R2,R2,#1
	TST R1, #(1 << 9)
	BNE WAIT_ZERO
	; Check PB9 State to determine the bit value
	;LDR R0, =GPIOB_IDR           ; Input Data Register
    ;LDR R1, [R0]
	MOV R4, R4, LSL #1 
    ;TST R1, #(1 << 9)           ; Check if PB9 is High
	CMP R2,#110
	BLS zero
	ORR R4, R4, #1
zero	

    SUBS R5, R5, #1              ; Decrement bit counter
	
	BNE READ_BIT_LOOP

 ; Store the completed byte in R8
    LSL R4, R4, R7               ; Shift the byte to the correct position
    ORR R8, R8, R4               ; Combine with existing data in R8
    ADD R7, R7, #8               ; Increment position for the next byte
    SUBS R6, R6, #1              ; Decrement total byte counter

	
    BNE READ_BYTE_LOOP          ; Repeat for all 5 bytes
	
	

    POP {R0-R7, PC}
	
		
DELAY_MICROSECONDS
    PUSH {R0-R5, LR}             ; Save registers
    LDR R0, =TIM2_BASE           ; TIM2 base address

    ; Get current counter value (TIM2_CNT)
    LDR R3, [R0, #0x24]          ; R3 = Current TIM2_CNT
WAIT_CHANGE
	LDR R5, [R0, #0x24]
	CMP R3, R5
	BEQ WAIT_CHANGE

WAIT_LOOP
	SUBS R2,R2,#1
	CMP R2, #0
	BEQ EXIT
	B WAIT_CHANGE
	
EXIT
    POP {R0-R5, PC}              ; Restore registers and return
	
	
	END