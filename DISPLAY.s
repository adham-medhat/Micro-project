	INCLUDE TFT.s
	;INCLUDE DHT1.s
	AREA MYCODE, CODE, READONLY
	;EXPORT DRAW_IMG


; USAGE
;-------
; provide images of width 9 and height 12 pixels
; define a scaler and a starting point
; colors are constant, make them variable if needed
DRAW_IMG
	; r0 = Xstart (top-left X)
	; r1 = Ystart (top-left Y)
	; r2 = scaler -> int
	; r3 = Bitmap Address (pointer to bitmap data)
	; r6 = width
	; r11 = height
	push {r0-r12, lr}
	
	ldr r7, [r3] ; load the first double-word
	
	; initilaize them with Xstart and Ystart
	; r4 -> Xi
	; r5 -> Yi
	; r6 -> width
	; r11 -> height
	mov r4, r0
	mov r5, r1 
;	mov r6, #9
;	mov r11, #12
infinite_loop
    mov r8, #32             ; Set r8 to 32 for processing 32 bits
process_bits
	
	MUL R9, R2, R6      ; R9 = scaler * width (R2 = scaler)
    ADD R9, R9, R0      ; R9 = Xstart + (scaler * width) (R0 = Xstart)
	cmp r4, r9          ; Compare Xi (R4) with R9 = (Xstart + scaler * width) 
	blo not_end_of_row
	
	; if (Xi >= Xstart + scaler * width)
	mov r4, r0 ; Xi(r4) = Xstart(r0)
	add r5, r2 ; Yi(r5) = Yi + scaler(r2)
	
	; if (Yi >= Ystart + scaler * height)
	MUL R9, R2, R11     ; R9 = scaler * height (R2 = scaler)
    ADD R9, R9, R1      ; R2 = Ystart + (scaler * height) (R1 = Ystart)
	cmp r5, r9          ; Compare Yi (R5) with R9 = (Ystart + scaler * height) 
	bhs end_of_image

not_end_of_row	
    lsr r9, r7, #31         ; Extract the most significant bit (MSB)
    cmp r9, #1              ; Test if the bit is 1 or 0
	
    push {r0-r10} ; Save the current state of Xi, Yi, and color
	;Explaination
	;-----
	;x1 = Xi,
    ;y1 = Yi,
    ;x2 = Xi + scaler,
    ;y2 = Yi + scaler;
	
	mov r0, r4 ;x1 = Xi(r4),
	mov r1, r5 ;y1 = Yi(r5),
	
	;x2 = Xi(r0) + scaler(r2),
	mov r3, r0
	ADD r3, r2
	
	;y2 = Yi(r1) + scaler(r2);
	mov r4, r1
	ADD r4, r2
	
	; colors in use
    moveq r10, #BLACK          ; If bit is 0, use BLACK
    movne r10, #WHITE          ; If bit is 1, use WHITE
	
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	;COLOR = [] r10
	BL DRAW_RECTANGLE_FILLED
	pop {r0-r10} ; Restore the previous state of Xi, Yi, and color
	
    ADD r4, r2 				; next bit Xi = Xi + scaler

    lsl r7, r7, #1          ; Shift the double-word left to prepare for the next bit
    subs r8, r8, #1         ; Decrement the bit counter
    bne process_bits        ; Repeat if there are more bits in the current double-word

    ; Move to the next double-word in the bitmap after processing 32 bits
	ADD r3, #4
	ldr r7, [r3]
    b infinite_loop               ; Continue if there are more pixels to draw

; if (Yi >= Ystart + scaler * height)
end_of_image
	
	pop {r0-r12, pc}
	
	
	
	
DISPLAY_NUMBERS
	PUSH{R0-R12,LR}
	
	mov r5, #4
	
	; needed by DRAW_IMG
	MOV R6, #9 ; width of digits
	MOV R11, #12 ; height of digits
	
	LDR r3, =ZERO_DIGIT
	cmp R4,#0
	BLEQ DRAW_IMG
	
	
	LDR r3, =ONE_DIGIT
	cmp R4,#1
	BLEQ DRAW_IMG
	
	
	LDR r3, =TWO_DIGIT
	cmp R4,#2
	BLEQ DRAW_IMG
	
	LDR r3, =THREE_DIGIT
	cmp R4,#3
	BLEQ DRAW_IMG
	
	LDR r3, =FOUR_DIGIT
	cmp R4,#4
	BLEQ DRAW_IMG
	
	LDR r3, =FIVE_DIGIT
	cmp R4,#5
	BLEQ DRAW_IMG
	
	LDR r3, =SIX_DIGIT
	cmp R4,#6
	BLEQ DRAW_IMG
	
	LDR r3, =SEVEN_DIGIT
	cmp R4,#7
	BLEQ DRAW_IMG
	
	LDR r3, =EIGHT_DIGIT
	cmp R4,#8
	BLEQ DRAW_IMG
	
	LDR r3, =NINE_DIGIT
	cmp R4,#9
	BLEQ DRAW_IMG

	POP	{R0-R12,PC}
	
	END