.data 
	val:			.asciiz "Enter the N-th natural number: "
	naive_prompt:		.asciiz "Naive aproach sum is: "
	interesting_prompt:	.asciiz "Interesting approach sum is: "
	new_line_character:	.asciiz "\n"
	

.text

main:
	# Take the input of n-th natural number from the user with syscall 4 
	li $v0, 4
	la $a0, val 
	syscall
	
	# Read integer from the user, using syscal 5 
	li $v0, 5 
	syscall 
	# The integer is returned in $v0, move it to $t0 
	move $t0, $v0
	
	# Jump and link to the naive approach fucntion
	jal naive_approach
	
	# Print a new line character 
	li $v0, 4 
	la $a0, new_line_character 
	syscall
	
	# Jump and link to the interesting approach function
	jal interesting_approach
	
	# End Program once both the program are done 
    	li $v0, 10
    	syscall
	
naive_approach:
	# Load the value into $t1 register 
	move $t1, $t0

	naive_loop:
		# Inside the loop, add the sum, sum((N.....1)^3)

		# If the index value is greater than , exit out of it 
		blt $t1, 1, exit_naive_program

		# Multiplying two signed 32-bit values to form a 64-bit result
		mult $t1, $t1 
		
		# Move from low 
		mflo $t2 
		mult $t2, $t1 
		# Move from low 
		mflo $t3 
		
		# Adding the values to the sum 
		add $s7, $s7, $t3 
		
		# Subtracting 1 from the input value $t1
		sub $t1, $t1, 1 
		
		# Loop again 
		j naive_loop
		
	exit_naive_program:
		# Print the prompt of naive approach
		li $v0, 4 
		la $a0, naive_prompt  
		syscall
		
	    # Print the sum in naive approach	
		li $v0, 1
		la $a0, 0($s7)
		syscall	
		
		# Jump to the address back
		jr $ra
		
interesting_approach:
		# Print the prompt of interesting approach
		
		# Formaula is (N(N+1)/2)^2
		
		# Adding N + 1 
		add $t4, $t0, 1 
		
		# Multiplying N * (N+1) and storing into register $t5
		mul $t5, $t4, $t0 
		
		# Dividing N(N+1) by 2 
		div $t6, $t5, 2 
		
		# Squaring the last term, i.e - square of (N(N+1)/2)
		mul $s5, $t6, $t6 
		
		# Print the prompt in interesting approach
		li $v0, 4 
		la $a0, interesting_prompt  
		syscall
			
		# Print the sum of interesting approach
		li $v0, 1
		la $a0, 0($s5)
		syscall 
			
		# Jump to the address back
		jr $ra