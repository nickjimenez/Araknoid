@ Araknoid
.global main

main:
      ldr 	r0, =frameBufferInfo 			 @ frame buffer inquiry
			bl 		initFbInfo

start:
      bl		drawMainMenu					     @ calls drawMainMenu class
      @ not written yet
			cmp		r0, #0						    	   @ checks if user wants to quit, it r0 = 0: quit
			bleq	endGame

enterGame:
			@ initial positions
			ldr 	r4, =paddlePosition				 @ initial paddle ordinates
			mov 	r0, 							         @ start x coordinate of paddle
			str		r0, [r4]						       @ update paddel x coordinates
			mov 	r1, 						           @ start y coordinate of paddle
			str		r1, [r4, #4]					     @ update paddle y coordinates

			ldr 	r5, =ballPosition
			mov 	r0, 							         @ start x coordinate for ball
			str 	r0, [r5]						       @ update ball x coordinates
			mov 	r1,								         @ start y coordinates for ball
			str 	r1, [r5, #4]					     @ update ball y coordinates

			ldr		r6, =brickArray
			@ load and store bricks

startGame:
			@ draw game
			@ bl 	draw 2D components

startGameState:
			bl 		buttonState						     @ checks button state (what button was pushed)

			@ any button - return to main menu
			cmp 	r0, #0							       @ check if user pressed quit
			bleq	start							         @ quits game goes back to start menu

			cmp		r0, #1							       @ check if user pressed start
			bleq	gameMenu						       @ branches to game menu to start game

			cmp 	r0, #2							       @ checks if user pressed restart
			bleq	enterGame						       @ restarts the game

			cmp 	r0, #3							       @ checks if user pressed up
			@ update paddle					   	     @ update paddle coordinates
			@ update ball							       @ update ball coordinates
			@ set states 							       @ set updates
			@ bleq

			cmp 	r0, #4							       @ checks if user pressed down
			@ update paddle						       @ update paddle coordinates
			@ update ball							       @ update ball coordinates
			@ set states 							       @ set updates
			@ bleq





endGame: 	@draw black screen to indicate quit game

@ quit program
haltLoop$: 	b haltLoop$

.section .data
paddlePosition:
			.int 	0, 0

ballPosition:
			.int	0,0
