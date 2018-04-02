
.global makeBackground
.global makeCeiling
.global makeLeftWall
.global makeRightWall
.global makeTypeOneBrick
.global makeTypeTwoBrick
.global makeTypeThreeBrick


makeBackground:
	push  {r4, r5, r6,lr}
	
	mov   r4, #200
	mov   r5, #200
	ldr   r6, =backgroundTileImg
	
topBackground:
	
	mov   r0, r4						@ Pass X into drawTile subroutine
	mov   r1, r5						@ Pass Y into drawTile subRoutine
	
	mov   r2, r6						@ Load image adress to pass into drawTile
	
	bl	 DrawTile					    @ Branch and link to drawTile		
	
	add  r4, #32						@ Increment by 32 pixels in the X direction, this spaces our ouxels by the size of each cell

	cmp  r4, #872						@ Check to see if our X ahs reached a desired position
	ble  topBackground					@ If so, we fall through, if not, we retiterate
	
	mov  r4, #200
	add  r5, #32
	cmp  r5, #872
	ble  topBackground

	pop {r4, r5, r6,pc}					@
	bx	 lr								@
	
	
makeCeiling:
	push  {r4, r5, r6,lr}
	
	mov   r4, #200
	mov   r5, #200
	ldr   r6, =ceilingTileImg
	
topCeiling:
	
	mov   r0, r4						@ Pass X into drawTile subroutine
	mov   r1, r5						@ Pass Y into drawTile subRoutine
	
	mov   r2, r6						@ Load image adress to pass into drawTile
	
	bl	 DrawTile					    @ Branch and link to drawTile		
	
	add  r4, #32						@ Increment by 32 pixels in the X direction, this spaces our ouxels by the size of each cell

	cmp  r4, #872						@ Check to see if our X ahs reached a desired position
	ble  topCeiling						@ If so, we fall through, if not, we retiterate

	pop {r4, r5, r6,pc}					@
	bx	 lr								@


makeLeftWall:
	push  {r4, r5, r6,lr}
	
	mov   r4, #200
	mov   r5, #232
	ldr   r6, =leftWallTileImg
	
topLeftWall:
	
	mov   r0, r4						@ Pass X into drawTile subroutine
	mov   r1, r5						@ Pass Y into drawTile subRoutine
	
	mov   r2, r6						@ Load image adress to pass into drawTile
	
	bl	 DrawTile					    @ Branch and link to drawTile		
	
	add  r5, #32						@ Increment by 32 pixels in the X direction, this spaces our ouxels by the size of each cell

	cmp  r5, #872						@ Check to see if our X ahs reached a desired position
	ble  topLeftWall					@ If so, we fall through, if not, we retiterate



	pop {r4, r5, r6,pc}					@
	bx	 lr								@

	
makeRightWall:
	push  {r4, r5, r6,lr}
	
	mov   r4, #872
	mov   r5, #232
	ldr   r6, =rightWallTileImg
	
topRightWall:
	
	mov   r0, r4						@ Pass X into drawTile subroutine
	mov   r1, r5						@ Pass Y into drawTile subRoutine
	
	mov   r2, r6						@ Load image adress to pass into drawTile
	
	bl	 DrawTile					    @ Branch and link to drawTile		
	
	add  r5, #32						@ Increment by 32 pixels in the X direction, this spaces our ouxels by the size of each cell

	cmp  r5, #872						@ Check to see if our X ahs reached a desired position
	ble  topRightWall					@ If so, we fall through, if not, we retiterate



	pop {r4, r5, r6,pc}					@
	bx	 lr								@

makeBall:
	push  {r4, r5, r6,lr}
	
	mov   r4, #232
	mov   r5, #456
	ldr   r6, =brick3Img
	
topBall:
	cmp   r5, r7
	
	
	mov   r0, r4						@ Pass X into drawTile subroutine
	mov   r1, r5						@ Pass Y into drawTile subRoutine
	
	mov   r2, r6						@ Load image adress to pass into drawTile
	
	//bl	 DrawBall					    @ Branch and link to drawTile		
	
	add  r4, #64						@ Increment by 32 pixels in the X direction, this spaces our ouxels by the size of each cell

	cmp  r4, #840						@ Check to see if our X ahs reached a desired position
	ble  topTThB		
										
										@ If so, we fall through, if not, we retiterate

	pop {r4, r5, r6, pc}				@
	bx	 lr								@



makeTypeOneBrick:
	push  {r4, r5, r6,lr}
	
	mov   r4, #232
	mov   r5, #392
	ldr   r6, =brick1Img
	
topTOB:
	cmp   r5, r7
	
	
	mov   r0, r4						@ Pass X into drawTile subroutine
	mov   r1, r5						@ Pass Y into drawTile subRoutine
	
	mov   r2, r6						@ Load image adress to pass into drawTile
	
	bl	 DrawTile					    @ Branch and link to drawTile		
	
	add  r4, #64						@ Increment by 32 pixels in the X direction, this spaces our ouxels by the size of each cell

	cmp  r4, #840						@ Check to see if our X ahs reached a desired position
	ble  topTOB		
										
										@ If so, we fall through, if not, we retiterate

	pop  {r4, r5, r6, pc}				@
	bx	 lr								@

makeTypeTwoBrick:
	push {r4, r5, r6,lr}
	
	mov  r4, #232
	mov  r5, #424
	ldr  r6, =brick2Img
	
topTTwB:
	cmp  r5, r7
	
	
	mov  r0, r4						@ Pass X into drawTile subroutine
	mov  r1, r5						@ Pass Y into drawTile subRoutine
	
	mov  r2, r6						@ Load image adress to pass into drawTile
	
	//bl	 DrawBrick					    @ Branch and link to drawTile		
	
	add  r4, #64						@ Increment by 32 pixels in the X direction, this spaces our ouxels by the size of each cell

	cmp  r4, #840						@ Check to see if our X ahs reached a desired position
	ble  topTTwB		
										
										@ If so, we fall through, if not, we retiterate

	pop  {r4, r5, r6, pc}				@
	bx	 lr								@

makeTypeThreeBrick:
	push  {r4, r5, r6,lr}
	
	mov   r4, #232
	mov   r5, #456
	ldr   r6, =brick3Img
	
topTThB:
	cmp   r5, r7
	
	
	mov   r0, r4						@ Pass X into drawTile subroutine
	mov   r1, r5						@ Pass Y into drawTile subRoutine
	
	mov   r2, r6						@ Load image adress to pass into drawTile
	
	//bl	  DrawBrick					    @ Branch and link to drawTile		
	
	add   r4, #64						@ Increment by 32 pixels in the X direction, this spaces our ouxels by the size of each cell

	cmp   r4, #840						@ Check to see if our X ahs reached a desired position
	ble   topTThB		
										
										@ If so, we fall through, if not, we retiterate

	pop {r4, r5, r6, pc}				@
	bx	 lr								@
