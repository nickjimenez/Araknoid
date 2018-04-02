.global main
main:
			ldr 		r0, =frameBufferInfo 		@ frame buffer information structure
			bl			initFbInfo
			bl			initialize_GPIO

start:
			bl		mainMenu									@ calls mainMenu class
			cmp		r0, #0										@ checks if user wants to quit, it r0 = 0: quit
			bleq		endGame

initVals:															@ Initial positions
			ldr		r4, =paddlePosition
			mov		r0, #848									@ start x coordinate of paddle (imm = immediate)
			str		r0, [r4]									@ update paddle x coordinates
			mov		r1, #780									@ start y coordinate of paddle
			str		r1, [r4, #4]							@ update paddle y coordinates

			ldr		r5, =ballPosition
			mov		r0, #904									@ start x coordinate for ball
			str		r0, [r5]									@ update ball x coordinates
			mov		r1, #764									@ start y coordinates for ball
			str		r1, [r5, #4]							@ update ball y coordinates
			@ ball trajectory
			mov		r2, #0										@ direction: straight up, 45 deg
			str		r2, [r5, #8]							@ stored 45 deg angle
			str		r2, [r5, #12]							@ increment y direction (up or down)
			mov		r2, #1										@ assign left right direction
			str		r2, [r5, #16]							@ store left or right direction

initBricks:
			mov		r3, #3										@ brick 3
			mov		r2, #2										@ brick 2
			mov		r1, #1										@ brick 1

			ldr		r0, =brickArray						@ load array of bricks
			mov		r4, #-1										@ move -1 to r4
			bl		checkBrickArray						@ branch link to check bricks

assignBrickArray:
			cmp		r4, #10										@ checks if to assign brick 1/2/3
			strlt	r3, [r0, r4, lsl #2]			@ assigns brick 3
			blt		checkBrickArray
			cmp		r4, #20										@ checks if to assign brick 1/2/3
			strlt	r2, [r0, r4, lsl #2]
			blt		checkBrickArray
			cmp		r4, #30										@ checks if to assign brick 1/2/3
			strlt	r1, [r0, r4, lsl #2]
			blt		checkBrickArray

checkBrickArray:
			add		r4, #1										@ increments r4 by one to drive brick assignment
			cmp		r4, #30										@ checks if we have reached the lowest bricks
			blt		assignBrickArray

			mov		r0, #3										@ assign 3 lives
			mov		r1, #0										@ assign 0 score
			ldr		r2, =gameStats						@ load life and score array to r2 for assigning
			str		r0, [r2]									@ store life
			str		r1, [r2, #4]							@ store score
			b			initStateBricks						@ branch to initStateBricks

valPostDeath:													@ after a game death
			ldr		r0, =gameStats						@ loads life and score to r0 for checking
			ldr		r1, [r0]									@ loads life for checking
			cmp		r1, #0										@ check if life = 0, gameOver if yes
			blt		gameOver									@ branches to game over message if no lives left

			@bl		initEnterGame							@ branch link to initEnterGame to restore paddle and ball positions
@-------------
			ldr		r4, =paddlePosition				@ load paddle position
			mov		r0, #848									@ assign starting x coordinates for paddle
			str		r0, [r4]									@ store x coordinate
			mov		r1, #780									@ assign starting y coordinates for paddle
			str		r1, [r4, #4]							@ store y value

			ldr		r5, =ballPosition					@ load ball position
			mov		r0, #904									@ assign starting x coordinates for ball
			str		r0, [r5]									@ store x coordinate
			mov		r1, #764									@ assign starting y coordinates for ball
			str		r1, [r5, #4]							@ store y value
			mov		r2, #0										@ assign ball trajectory angle = 45, y dir = up
			str		r2, [r5, #8]							@ store the initial angle
			str		r2, [r5, #12]							@ store the y-dir
			mov		r2, #1										@ assigns x dir = right
			str		r2, [r5, #16]							@ store the x-dir

initStateBricks:											@ resting state of game. Ball still on paddle
			bl		drawBackground						@ branches to global draw Background

			ldr		r0, =brickArray						@ loads brick array to pass to draw them
			bl		drawBricks								@ calls global draw bricks

			bl		drawGameStats							@ draws life and score on the screen

			ldr		r4, =paddlePosition				@ loads initial paddle position
			ldr		r0, [r4]									@ loads x coordinate of paddle
			ldr		r1, [r4, #4]							@ loads y coordinate of paddle
			bl		drawPaddle								@ passes r0 and r1 to draw paddle for x and y coordinates

			ldr		r5, =ballPosition					@ loads initial ball coordinates
			ldr		r0, [r5]									@ loads x coordinates for passing
			ldr		r1, [r5, #4]							@ loads y coordinates for passing
			bl		drawBall									@ passes r0 and r1 to draw ball for x and y coordinates

takeUserInput:
			bl		SNESRead									@ branch links to SNESread and reads user input to SNESread controller
			mov		r7, r0										@ moves user input to r7
			mov		r5, #0xffff								@ zeros out r5 for comparison
			cmp		r0, r5										@ compares user input to empty
			beq		takeUserInput							@ will keep looping until user input

			mov		r6, #0										@ assign button index

findButton:														@ checks what user pressed
			lsrs		r0, #1								 	@ lsr until we find a 0
			blo		initContinue
			add		r6, #1										@ increment index by 1 then loop back
			b		findButton

initContinue:													@ waits for user to release button
			mov		r0, #3000
			bl		delayMicroseconds
			mov		r0, r6

moveLeft:															@ check if user input = Left
			cmp		r0, #6
			bne		moveRight									@ if not left, then check if user input = right
			ldr		r1, =paddlePosition				@ load paddle position to use for state update
			ldr		r2, =ballPosition					@ load ball position for state update
			lsrs		r7, #9									@ shift speed of ball and paddle by 9
			movlo		r3, #6									@ assign appropriate immediate for paddle and ball speed
			movhi		r3, #3
			bl		updateInitialState

moveRight:														@ check if user input = right
			cmp		r0, #7
			bne		notLorRButton							@ checks other buttons if not left or right
			ldr		r1, =paddlePosition				@ analogous functionality as inputLeft
			ldr		r2, =ballPosition
			lsrs		r7, #9
			movlo		r3, #6
			movhi		r3, #3
			bl		updateInitialState

notLorRButton:
			cmp		r0, #0										@ user input = B release ball from initial position
			bleq		inGame

			cmp		r0, #3										@ user input = Start
			bleq		mainMenuStart						@ return  to restart, or quit

			cmp		r1, #10										@ user input = Quit
			bleq		start										@ return to main menu

			cmp		r1, #1										@ user input = Restart
			bleq		initVals								@ return to initial state

			cmp		r1, #2										@ user input = Start closes menu
			bleq		initStateBricks					@ return to main menu

			bl		takeUserInput

stateSaved:
			bl		drawBackground						@ branch link to draw background

			ldr		r0, =brickArray						@ load brick array for drawing
			bl		drawBricks								@ pass r0 to draw bricks

			ldr		r4, =paddlePosition				@ loads paddle position stack
			ldr		r0, [r4]									@ loads x coordinate for paddle position
			ldr		r1, [r4, #4]							@ loads y coordinate for paddle position
			bl		drawPaddle								@ pass x and y coordinates to draw paddle

			ldr		r5, =ballPosition					@ loads ball position stack
			ldr		r0, [r5]									@ loads ball x coordinates
			ldr		r1, [r5, #4]							@ loads ball y coordinates
			bl		drawBall									@ pass x and y coordinates to draw ball

inGame:																@ ball leaves paddle
readUserInput:						// read SNES input until button pressed
			ldr		r0, =ballPosition					@ load ball position
			ldr		r1, =paddlePosition				@ load paddle position
			bl		updateBall								@ update ball position

			ldr		r0, =gameStats						@ load game stat array
			ldr		r0, [r0, #4]
			cmp		r0, #60										@ check if user reached max score
			beq		win												@ branches to win to draw winner image

			cmp		r3, #1										@ checks if paddle missed ball
			ldreq	r1, =gameStats						@ updates game stats is you missed ball
			ldreq	r2, [r1]									@ loads life to r2
			subeq	r2, #1										@ subtracts 1 life
			streq	r2, [r1]									@ stores new life val
			beq		valPostDeath							@ updates stats after

			bl		SNESRead											@ branch to SNESread
			mov		r7, r0										@ loads user input to r7
			mov		r5, #0xffff								@ zeros r5 to check if user input present
			cmp		r0, r5										@ compares user input to zeroed r5
			beq		readUserInput							@ if r0 = r5, loop up
			mov		r6, #0										@ assigns an index of the button pressed

findUserInput:												@ determin the pressed button
			lsrs 		r0, #1									@ lsr until 0 found
			blo		continue
			add		r6, #1										@ increment index by 1 and loop up
			b		findUserInput

continue:						// wait for user to release button
			//Checks if left or rights being pressed
			mov		r0, r6
			ldr		r1, =paddlePosition
			lsrs	r7, #9
			movlo	r2, #6
			movhi	r2, #3
			bl		updatePlayingStatePaddle

			mov		r0, r6
			cmp		r0, #3				//Start
			bleq		mainMenuStart			//Should return restart, or quit
			cmp		r1, #10				//quit
			bleq		start				//go to main menu
			cmp		r1, #1				//Restart
			bleq		initVals		//go to initial game state
			cmp		r1, #2				//Start closes menu
			bleq		stateSaved			//go to the saved state before pressing start
			bl		inGame
			bl		endGame

win:
			bl			drawWin											@ branch to draw winner image
			bl			findButton									@ wait for user input
			bl			start												@ loop back to start

gameOver:
			bl			drawGameOver								@ branch to draw game over image
			bl			findButton									@ wait for user input
			bl			start												@ loop back to start

endGame:
			bl			endGame										@ branch to draw black screen at end game

haltLoop$:
			b	haltLoop$

@ Data section
.section .data

paddlePosition:
			.int	0, 0													@ primed paddle coordinates

ballPosition:															@ ball stats stack: x, y, 45/60, up/down, left/right
			.int	0, 0, 0, 0, 0									@ primed ball stats

@ Maybe
.global brickArray
brickArray:
	.int	3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

.global gameStats
gameStats:																@ user stats stack (life and score)
			.int	3, 0													@ user has 3 lives initially and 0 score
