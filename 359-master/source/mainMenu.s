.section .text
.global mainMenu

mainMenu:	
		push {r4- r10, lr}
		
		mov		r0,	#0x10000
		bl		delayMicroseconds
		mov		r0,	#0x10000
		bl		delayMicroseconds
		
@------------------------------ Main Menu ------------------------------		
drawMainUpdate:
		mov 	r0, #200					@ pass mainMenu x coordinate
		mov 	r1, #100					@ pass mainMenu y coordinate
		ldr		r2, =mainMenuImg			@ load mainMenu Image
		
		bl		drawMainMenu				@ calls global draw main menu

		mov     r0, #290
		mov     r1, #520
		ldr     r2, =cursorImg
		bl		drawCursor

	
		mov  r0, #1
			
getInput:	

		bl   mainMenuUserInput
		mov  r4, r0							@ Button press value
		mov  r1, r1							@ flag
	
		ldr  r0, =fmt
		bl   printf	
			
		mov  r0, r1							@ flag
		bl   updateMainCursor
	
		
		cmp  r4, #8
		beq  done
		bne    getInput  
done:		
		
	
		pop		{r4- r10, fp, pc}
		mov 	pc, lr
		
.global updateMainCursor

//Take r10 flag as arg
updateMainCursor:	
		push {r4- r10, lr}
					
		mov r4, r0
		cmp r4, #1						@ check if user wants up
		beq	cursorUp
		bne	cursorDown		

			
cursorUp:
		mov		r0, #290
		mov		r1, #670
		ldr		r2, =eraseCursorImg
		bl		drawCursor					@ use registered y to draw cursor

		mov		r0, #290
		mov		r1, #520
		ldr		r2, =cursorImg
		bl		drawCursor					@ use registered y to draw cursor
		pop		{r4- r10, fp, pc}
		
cursorDown:

		mov		r0, #290
		mov		r1, #520
		ldr		r2, =eraseCursorImg
		bl		drawCursor					@ use registered y to draw cursor

		mov		r0, #290
		mov		r1, #670
		ldr		r2, =cursorImg
		bl		drawCursor					@ use registered y to draw cursor
					
		pop		{r4- r10, fp, pc}


//Take r10 flag as parameter
mainMenuUserInput:
		push {r4, r5, lr}
		mov     r4, r0
		
		bl 		buttonFind					@ branch links to buttonFind in buttonFind 

		mov     r5, r0						@

		cmp 	r5, #4						@ compares returned r0 to up
		moveq	r4, #1						@ reassigns user input to up

		cmp 	r5, #5						@ compares button find return r0 to 5 = down
		moveq	r4, #0						@ if yes, assign 0 to r10 indicating down
	
		mov     r0, r5						@ Button press value
		mov     r1, r4						@ Flag value
		pop		{r4, r5, fp, pc}

.data
fmt: .string "helloooo\n"
