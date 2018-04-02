@ Code section
.section    .text
.global DrawTile
.global DrawPaddle
.global Drawimage
.global drawMainMenu
@.global DrawEraseCursor

.global draw
draw:
	ldr	r0, =frameBufferInfo
	bl	initFbInfo	
 
	mov r4, #0								@ i index
	mov r5, #0								@ j index
	
	mov r6, #200 							@ x coord
	mov r7, #100							@ y coord

top:
	mov	r0,	r4				 				@ i index
	mov	r1,	r5								@ j index
  
    bl  calcOffset							@ Branch to calculate offset
	
	mov r8, r0								@ Pass offset into DrawInitialGrid

	mov	r0,	r6								@ Pass x into DrawInitialGrid
	mov	r1,	r7								@ Pass y into DrawInitialGrid
	mov r2, r8								@ Pass the offset into DrawInitialGrid
	ldr r3, =startState						@ Pass the StartStateArray into DrawInitialGrid
	
	bl  DrawInitialGrid						@ Branch to DrawInitialGrid

	add  r6, #32							@ Increment by 32 pixels in the X direction, this spaces our pixels by the size of each cell
	cmp  r6, #872							@ Check if x pixels have reached the max value
	bgt  next								@ If so, branch to next
	ble  check								@ If not check index values
	
next:
	mov  r6, #200							@ Reinitialize the x value
	add  r7, #32							@ Increment the y value
	
	cmp  r7, #904							@ Check to see if our X ahs reached a desired position
	ble  check								@ If so, we fall through, if not, we retiterate

check:
	add r4, #1								@ Increment the i index
		
	cmp r4, #21								@ Check if i has reached a max
	bgt checkIndeces						@ If so, branch to checkIndeces 
	ble top									@ If no, reiterate the overall loop
	
checkIndeces:
	add r5, #1
	mov r4, #0
	
	cmp r5, #22
	bgt done 
	blt top
	
done:

	mov r0, #520
	mov r1, #750
	ldr r2, =paddleImg 

	bl  DrawPaddle

	bl  DrawChar

	haltLoop$:
	b 	  haltLoop$

	  
calcOffset:
	push {r4- r10, lr}						@	
	mov   r4, r0							@ Desired 'i' index 
    mov   r5, r1							@ Desired 'j' index
    
    mov   r6, #4							@ Size of element
	mov   r7, #22							@ Total 'j' index of our array
	
	mul   r8, r7, r5 						@ ((m*i)
    add   r8, r4							@ ((m*i)+j)*(element-size)
    lsl   r8, #2
	
	mov   r0, r8							@	
	pop  {r4-r10, pc}						@
	
	
DrawInitialGrid:
	push {r4- r10, lr}						@


	mov   r4, r0							@ X start coordinate
	mov   r5, r1							@ Y start coordinate
	mov   r6, r2							@ Offset
	mov   r7, r3							@ initial state
				
	ldr   r8, [r7, r6]						@

topGrid:									@
	cmp   r8, #0
	beq   printBackground					@
	bne   else			

printBackground:							
	ldr   r10, =backgroundTileImg				@	
	
	mov	  r0, r4							@ Pass x coordinate into DrawTile
	mov	  r1, r5							@ Pass y coordinate into DrawTile
	mov   r2, r10							@ Pass ascii value into DrawTile
	
	bl    DrawTile							@ Branch and link to DrawTile
	b     done24							@
	
else:
	cmp   r8, #10							@
	beq   printCeiling
	bne   else1	
												
printCeiling:
	ldr   r10, =ceilingTileImg					@
	
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	mov   r2, r10							@ 
	
	bl    DrawTile							@ 
	b     done24
	
else1:
	cmp   r8, #12							@
	beq   printRightWall
	bne   else2	
												
printRightWall:
	ldr   r10, =rightWallTileImg				@
	
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	mov   r2, r10							@ 
	
	bl    DrawTile							@ 
	b     done24

else2:
	cmp   r8, #11							@
	beq   printLeftWall
	bne   else3	
												
printLeftWall:
	ldr   r10, =leftWallTileImg					@
	
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	mov   r2, r10							@ 
	
	bl    DrawTile							@ 
	b     done24


else3:
	cmp   r8, #1							@
	beq   printBrickOne
	bne   else4	
												
printBrickOne:
	ldr   r10, =brick1Img				@
	
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	mov   r2, r10							@ 
	
	bl    DrawTile							@ 
	b     done24
	
else4:	
	cmp   r8, #2							@
	beq   printBrickTwo
	bne   else5	
												
printBrickTwo:
	ldr   r10, =brick2Img				@
	
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	mov   r2, r10							@ 
	
	bl    DrawTile							@ 
	b     done24

else5:
	cmp   r8, #3							@
	beq   printBrickThree
	bne   done24
												
printBrickThree:
	ldr   r10, =brick3Img				@
	
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	mov   r2, r10							@ 
	
	bl    DrawTile							@ 
	b     done24

done24:
	
	pop   {r4-r10, pc}						@
	bx     lr	 							@
	
.global drawCursor
drawCursor:  @ drawMainMenu @ pass length and width of image and load image
	push {r4- r10, lr}						@
	
	@ pass length and width of image and load image
	
	mov   r4, r0							@ X start coordinate
	mov   r5, r1							@ Y start coordinate
	mov   r6, r2							@ Image address
	
	@ not sure what to initialize x and y (for cursor)
	add   r7, r4, #64						@ Initialize the x
	add   r8, r5, #64						@ Initialize the y

	mov   r9, #0							@ Pixel counter
	mov	  r10, r4							@ r10 = r4, so we can reinitialize r4
	
cursorloop:
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	
	ldr   r2, [r6, r9, lsl #2]				@ 
	bl    DrawPixel						@ 
	add   r9, #1							@
	add   r4, #1							@
	

				 
	cmp   r4, r7							@ Hard coded for easier alterations later on
	blt   menuloop								@ 

	mov    r4, r10							@ Hard coded for easier alterations later on
	add    r5, #1							@
			
	cmp   r5, r8							@ Hard coded for easier alterations later on
	blt   menuloop								@ 
	
	pop   {r4-r10, pc}						@
	bx     lr	 							@

drawMainMenu:  @ drawMainMenu @ pass length and width of image and load image
	push {r4- r10, lr}						@
	
	@ pass length and width of image and load image
	
	mov   r4, r0							@ X start coordinate
	mov   r5, r1							@ Y start coordinate
	mov   r6, r2							@ Image address
	
	add   r7, r4, #704						@ Initialize the x
	@ #32 > 904
	add   r8, r5, #736						@ Initialize the y
	@ #32 > 936

	mov   r9, #0							@ Pixel counter
	mov	  r10, r4							@ r10 = r4, so we can reinitialize r4
	
menuloop:
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	
	ldr   r2, [r6, r9, lsl #2]				@ 
	bl    DrawPixel							@ 
	add   r9, #1							@
	add   r4, #1							@
	

				 
	cmp   r4, r7							@ Hard coded for easier alterations later on
	blt   menuloop								@ 

	mov    r4, r10							@ Hard coded for easier alterations later on
	add    r5, #1							@
			
	cmp   r5, r8							@ Hard coded for easier alterations later on
	blt   menuloop								@ 
	
	pop   {r4-r10, pc}						@
	bx     lr	 							@
	
DrawTile:  @ drawMainMenu @ pass length and width of image and load image
	push {r4- r10, lr}						@
	
	@ pass length and width of image and load image
	
	mov   r4, r0							@ X start coordinate
	mov   r5, r1							@ Y start coordinate
	mov   r6, r2							@ Image address
	
	add   r7, r4, #32						@ Initialize the x
	@ #32 > 904
	add   r8, r5, #32						@ Initialize the y
	@ #32 > 936

	mov   r9, #0							@ Pixel counter
	mov	  r10, r4							@ r10 = r4, so we can reinitialize r4
	
loop1:
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	
	ldr   r2, [r6, r9, lsl #2]				@ 
	bl    DrawPixel						@ 
	add   r9, #1							@
	add   r4, #1							@
	

				 
	cmp   r4, r7							@ Hard coded for easier alterations later on
	blt   loop1								@ 

	mov    r4, r10							@ Hard coded for easier alterations later on
	add    r5, #1							@
			
	cmp   r5, r8							@ Hard coded for easier alterations later on
	blt   loop1								@ 
	
	pop   {r4-r10, pc}						@
	bx     lr	 							@
	
.global drawEndGame
drawEndGame:  @ drawMainMenu @ pass length and width of image and load image
	push {r4- r10, lr}						@
	
	@ pass length and width of image and load image
	
	mov   r4, #200							@ X start coordinate
	mov   r5, #100							@ Y start coordinate
	ldr 	r6, =loseGameImg						@ Image address
	
	add   r7, r4, #704						@ Initialize the x
	@ #32 > 904
	add   r8, r5, #736						@ Initialize the y
	@ #32 > 936

	mov   r9, #0							@ Pixel counter
	mov	  r10, r4							@ r10 = r4, so we can reinitialize r4
	
loopEndGame:
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	
	ldr   r2, [r6, r9, lsl #2]				@ 
	bl    DrawPixel						@ 
	add   r9, #1							@
	add   r4, #1							@
	

				 
	cmp   r4, r7							@ Hard coded for easier alterations later on
	blt   loopEndGame								@ 

	mov    r4, r10							@ Hard coded for easier alterations later on
	add    r5, #1							@
			
	cmp   r5, r8							@ Hard coded for easier alterations later on
	blt   loopEndGame						@ 
	
	pop   {r4-r10, pc}						@
	bx     lr	 							@
	


DrawPaddle:
	push {r4- r10, lr}						@
	
	mov   r4, r0							@ X start coordinate
	mov   r5, r1							@ Y start coordinate
	mov   r6, r2							@ Image address
	
	add   r7, r4, #64						@ Initialize the length
	add   r8, r5, #32						@ Initialize the height

	mov   r9, #0							@ Pixel counter
	mov	  r10, r4							@ r10 = r4, so we can reinitialize r4
	
paddleLoop:
	mov	  r0, r4							@ Pass x coordinate into DrawPixel
	mov	  r1, r5							@ Pass y coordinate into DrawPixel
	
	ldr   r2, [r6, r9, lsl #2]				@ 
	bl    DrawPixel						@ 
	add   r9, #1							@
	add   r4, #1							@
	

				 
	cmp   r4, r7							@ Hard coded for easier alterations later on
	blt   paddleLoop								@ 

	mov    r4, r10							@ Hard coded for easier alterations later on
	add    r5, #1							@
			
	cmp   r5, r8							@ Hard coded for easier alterations later on
	blt   paddleLoop								@ 
	
	pop   {r4-r10, pc}						@
	bx     lr	 							@

DrawImage:
	mov	  fp, sp
	push {r4}
	
	mov   r4, #0
	
loop:
	cmp   r4, #20
	bgt   done

	mov   r0, #200
	mov   r1, #200
	mov   r3, #0xFF0
	
	bl	  DrawPixel
	add   r4, #1
	add   r1, #1
	b	  DrawImage

DrawChar:
	push		{r4-r8, lr}

	chAdr		.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8

	ldr		chAdr, =font			@ load the address of the font map
	mov		r0, #'B'				@ load the character into r0
	add		chAdr,	r0, lsl #4		@ char address = font base + (char * 16)

	mov		py, #200				@ init the Y coordinate (pixel coordinate)

charLoop$:
	mov		px, #200				@ init the X coordinate

	mov		mask, #0x01				@ set the bitmask to 1 in the LSB
	
	ldrb	row, [chAdr], #1	@ load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask			@ test row byte against the bitmask
	beq		noPixel$

	mov		r0, px
	mov		r1, py	
	mov		r2, #0x00FF0000			@ red
	bl		DrawPixel				@ draw red pixel at (px, py)
	
noPixel$:
	add		px, #1					@ increment x coordinate by 1
	lsl		mask, #1				@ shift bitmask left by 1

	tst		mask,	#0x100			@ test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py, #1					@ increment y coordinate by 1

	tst		chAdr, #0xF		
	bne		charLoop$				@ loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

	pop		{r4-r8, pc}


//////////////////////////////////////////
//										//
//										//
//										//
//										//
//////////////////////////////////////////
DrawPixel:
	push	{r4, r5}						@
	
	offset	.req	r4						@
	ldr		r5, =frameBufferInfo
	
	@ offset = (y * width) + x
	ldr		r3, [r5, #4]	@ r3 = width	@ 
	mul		r1, r3
	add		offset, r0, r1
	
	@ offset *= 4 (32 bits per pixel/8 = 4 bytes per pixel)
	lsl		offset, #2
	
	@ store the colour (word) at frame buffer pointer + offset
	ldr		r0, [r5]						@r0 = frame buffer pointer
	str		r2, [r0, offset]
	
	pop		{r4, r5}
	bx		lr


.data
.align 4
font:	.incbin "font.bin"


.align
.global	frameBufferInfo
frameBufferInfo:
	.int	0		@ frame buffer pointer
	.int	0		@ screen width
	.int	0		@ screen height

.align 4	
startState:
	.int	 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   0  
	.int	 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   0 
	.int	 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   0 
	.int	 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   0 
	.int	10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  10
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12  
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12 
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12 
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12 
	.int	11,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  12  
	.int	11,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  12
	.int	11,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1  ,1,  1,  1,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
	.int	11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  12
