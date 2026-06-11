.global _callfunction

_callfunction:
	mov r1, #1 // Set endpoint1 to 1
	mov r2, r0 // Set endpoint2's data the same as register r1's data
	mov r3, #0 // Set output to any value as it is not yet important

_loopcheck:
	cmp r1, r2 // Sets ALU flags from the output of r1 - r2. The result isn't stored, but toggles specific ALU flags for the conditional operation codes
	
	ble main_loop // Jumpes/Branches to main_loop address if the condition: r1 is less than or equal to r2 (r1 <= r2)
	b _loopend // If the statement above is not satisfied, jump directly to the end of the loop

main_loop:
	add r3, r1, r2 // Sum r1's and r2's values, and insert to r3
	lsr r3, r3, #1 // Shifts r3 value in bits to the right, which is divided by 2. In binary form, left shift is multiply, right shift is division, all done by the power of 2

	mov r4, r3 // Replicate r3 value (output), and let r4 be the squared value of r3
	mul r4, r4, r4 // Multiplies the value of r4 twice (power of 2), and insert value to r4

	cmp r4, r0 // Sets ALU flags from the output of r4 - r0. The result isn't stored, but toggles specific ALU flags for the conditional operation codes

	beq equalIn_Out // If output^2 == argument holds true, then jump to the address equalIn_Out
	blt lessthanIn_Out // If output^2 < argument holds true, then jump to the address lessthaIn_Out
	bgt greaterthanIn_Out // If output^2 > argument holds true, then jump to the address greaterthanIn_Out

equalIn_Out:
	b _loopend // Ends the loop if output equals the argument (output^2 = argument)

lessthanIn_Out:
	add r1, r3, #1 // Increment the value of r3 once, and insert the result to r1
	b _loopcheck // jumps back to the address _loopcheck without any condition

greaterthanIn_Out:
	sub r2, r3, #1 // Decrement the value of r3 once, and insert the result to r2
	b _loopcheck // jumps back to the address _loopcheck without any condition


_loopend:
	mov r0, r3 // insert the r3 register data to r0, which is a return value for ARM Microarchitecture
	bx lr // jumps/branches to the address held by link register which is a return address of the function, with automated option to choose for an instruction set such as "classic ARM or Thumb Mode"
