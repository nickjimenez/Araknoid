@ Arkanoid

.global main
.global gameStats

main: 
		ldr r0, =frameBufferInfo		@ frame buffer info structure
		bl	initFbInfo
		bl 	initGPIO
		
start: 
		bl mainMenu						@ call mainMenu class
		cmp r0, #0						@ 
		bleq drawEndGame
		
paddlePosition:							@ paddle coordinates
		.int 0, 0 						@ x, y coordinate

ballPosition:							@ ball stats and coordiates primed
		.int 0, 0, 0, 0					@ x, y, degree (45/60), up/down, left/right
 
gameStats:								@ user stats stack (life and score)
		.int 3, 0						@ life, score
		
