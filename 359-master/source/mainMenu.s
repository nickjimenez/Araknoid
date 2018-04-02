.section .text
.global mainMenu

mainMenu:	
		mov fp, sp
		push {r4- r10, lr}
		
		//mov		r0,	#0x10000
		//bl		delayMicroseconds
		//mov		r0,	#0x10000
		//bl		delayMicroseconds
		
@------------------------------ Main Menu ------------------------------		
drawMainUpdate:
		mov 	r0, #200					@ pass mainMenu x coordinate
		mov 	r1, #100					@ pass mainMenu y coordinate
		ldr		r2, =mainMenuImg			@ load mainMenu Image
		
		bl		drawMainMenu				@ calls global draw main menu
		
@------------------------------ Cursor ---------------------------------

		mov 	r10, #1						@ cursor location 1 on start, 0 on quit

updateMainCursor:		
		@ update x and y coordinates later
		mov 	r4, #290
		mov 	r5, #520
		mov 	r0, r4						@ pass cursor x coordinate
		mov 	r1, r5						@ pass cursor y coordinate					
		ldr 	r2, =cursorImg 				@ load cursor Image 

		bl 		drawCursor					@ calls global draw cursor

		@mov 	pc, lr						@ return
		@ erase previous image!!! 
		
mainMenuUserInput:
		bl 		buttonFind					@ CHANGE BUTTON CHOSE CLASS NAME !!!!!!!
		
		bl		drawMainUpdate				@ draw MainMenu over again to hide cursor
		
		cmp 	r0, #4						@ compares SNES input to move up
		moveq	r10, #1						@ return 1 to move up
		mov 	r4, #290					@ pass cursor x coordinate
		mov 	r5, #520					@ pass cursor y coordinate	 
		bl		updateMainCursor			@ update cursor on screen	

		cmp 	r0, #5 						@ compares SNES input to move down
		moveq	r10, #0						@ return 0 to move down		
											@ return 1 to move up
		mov 	r4, #290					@ pass cursor x coordinate
		mov 	r5, #670					@ pass cursor y coordinate	 
		beq		updateMainCursor 			@ update cursor on screen
		
		cmp 	r0, #8						@ compareSNES input to A
		
		beq	returnInput						@ returns to calling function
		
		b 		mainMenuUserInput			@ loops back to buttonChose 	

returnInput:	
		mov 	r0, r10						@ loads up/down instruction to r0 to return to calling code
		pop		{r4- r10, fp, pc}
		mov 	pc, lr


		  
		
		
