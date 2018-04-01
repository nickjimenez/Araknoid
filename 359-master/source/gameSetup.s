@ Code section
.section .text

.global gameSetup




haltLoop$:
	b 	  haltLoop$




done:
	pop {r4}
	bx  lr




