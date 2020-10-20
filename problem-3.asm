.data 
	x_input:		.asciiz "Input X: "
	y_input:		.asciiz "Input Y: "
	a_input:		.asciiz "Input A: "
	b_input:		.asciiz "Input B: "
	new_line_character:	.asciiz "\n"
	register_t8:		.asciiz "Least significant: "
	register_t9:		.asciiz "Most significant: "
	
.text 

main: 
	jal input_x 
	jal input_y 
	jal input_a 
	jal input_b 
	jal convert_32bits_64bits_X_Y
	jal convert_32bits_64bits_A_B
	
	# $t9 holds the least significant 32 bit. Using add unsigned instruction
	addu $t9, $s4, $s6 
	
	# $t8 holds the most significant 32 bit. Using add unsigned instruction
	addu $t8, $s5, $s7 
	
	# Print the prompt for the $t8 register 
	li $v0, 4 
	la $a0, register_t8
	syscall
			
	# Print the t8 regsiter
	li $v0, 1
	la $a0, 0($t8)
	syscall 
	
	# Print a new line character 
	li $v0, 4 
	la $a0, new_line_character 
	syscall
	
	# Print the prompt for the $t9 register 
	li $v0, 4 
	la $a0, register_t9
	syscall
			
	# Print the t8 regsiter
	li $v0, 1
	la $a0, 0($t9)
	syscall
		
	# End Program once both the program are done 
    	li $v0, 10
    	syscall
    	
input_x:
	# Print the prompt to input X
	li $v0, 4 
	la $a0, x_input 
	syscall
		
	# Read integer from the user, using syscall 5 
	li $v0, 5	
	syscall 
	# The integer is returned in $v0, move it to $t0 
	move $s0, $v0
	
	# Jump to the address back
	jr $ra


input_y:
	# Print the prompt to input Y
	li $v0, 4 
	la $a0, y_input  
	syscall
		
	# Read integer from the user, using sysca;l 5 
	li $v0, 5
	syscall 
	# The integer is returned in $v0, move it to $t0 
	move $s1, $v0
	
	# Jump to the address back
	jr $ra 


input_a:
	# Print the prompt to input A
	li $v0, 4 
	la $a0, a_input
	syscall
		
	# Read integer from the user, using syscall 5 
	li $v0, 5 
	syscall  
	# The integer is returned in $v0, move it to $t0 
	move $s2, $v0
	
	# Jump to the address back
	jr $ra 


input_b: 
	# Print the prompt to input B
	li $v0, 4 
	la $a0, b_input  
	syscall
		
	# Read integer from the user, using syscall 5 
	li $v0, 5 
	syscall 
	# The integer is returned in $v0, move it to $t0 
	move $s3, $v0
	
	# Jump to the address back
	jr $ra 
	
	
convert_32bits_64bits_X_Y:
	
	# Using the multu (multiply unsigned) instruction to multiply unsigned X * Y 
	multu $s0, $s1
	
	# Move from hi
	mfhi $s5 
	
	# Move from lo 
	mflo $s4
	
	# Jump to the address back 
	jr $ra 
	
convert_32bits_64bits_A_B:
	# Using the multu (multiply unsigned) instruction to multiply unsigned A * B 
	multu $s2, $s3
	
	# Move from hi
	mfhi $s7 
	
	# Move from lo 
	mflo $s6
	
	# Jump to the address back 
	jr $ra 