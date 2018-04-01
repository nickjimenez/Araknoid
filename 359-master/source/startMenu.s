@ Code section
.section .text

.global startMenu

startMenu:

	push 	{r10, lr}
	ldr		r0, =frameBufferInfo
	bl		initFbInfo	
	
	mov 	r0, #50			@X
	mov 	r1, #50			@Y
	
	ldr		r2, =mainMenu
	
	//bl	DrawMenu
	
	
////////////////////////////////////////////////////////////////////////

	mov		r10, #1			@holds the cursor location: 1 or 0
	
cursorCheck:

	mov		r0, #53
	mov		r1, #426
	
	ldr		r2, =cursor
	
	//bl		DrawCursor
	
	cmp		r10, #1
	moveq	r1,	#426
	movne	r1, #531
	
	ldr		r2, =eraseCursor
	
	//bl		DrawCursor
	
buttonInput:

	//bl		init_snes		@ need to set up button input
	cmp		r0, #4
	moveq	r10, #1
	beq		cursorCheck
	cmp		r0, #5
	moveq	r10, #0
	beq		cursorCheck
	cmp		r0, #8
	beq		mainMenuReturn
	b		buttonInput
	
mainMenuReturn:
	mov		r0, r10
	pop		{r10, pc}
