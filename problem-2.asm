.data

	prompt_string:	.asciiz "Enter the input string: "
	input_string:	.space 255
	final_string:	.asciiz "Final string: "
	
.text 

main: 
	# Print input string prompt 
	li $v0, 4
	# Load and print string, prompt_string
	la $a0, prompt_string  
	syscall
	
	# Read the string value from the user 
	li $v0, 8
	# Maximum number of characters to read 
	li $a1, 255
	# Address of input buffer
	la $a0, input_string 
	# Saving the string into $t0 register 
	move $t0, $a0 
	syscall
	
	
	# Print the input string
	li $v0, 4 
	# Load the bytes to the address 
	la $a0, input_string 
	# Making the primary address equal to the load pointer 
	move $t0, $a0 

	# 1. Transform lowercase to uppercase and vice-versa 
	# Jump and link to the string_transform method 
	jal string_transform 
	
	# 2. Delete duplicates from the transformed string 
	# Jump and link to the remove_duplicates_method 
	
	la $t2, input_string
	la $t4, input_string   
	li $t5, -1
	
	jal remove_duplicates 
	
	# 3. Reverse the string received after removing consecutive duplicates (case-sensistive)
	# Jump and link to the reverse string method 
	la $t6, input_string 
	move $s0, $t6
	
	# Print input string prompt 
	li $v0, 4
	# Load and print string, prompt_string
	la $a0, final_string  
	syscall
	
	jal reverse_string 
	
	# Final output string 
	#li $v0, 4
   	#la $a0, input_string
    	#syscall
	
	# End Program once both the program are done 
    	li $v0, 10
    	syscall
    
remove_duplicates:
	# Load the bytes into $t3 register
	lb      $t3, ($t2)    
	# Incrementing the counter by 1      
        addi    $t2, $t2, 1
        # If $t3 equals to $t2, recursively call the function to find the next character
        beq     $t3, $t5, remove_duplicates   
        #  Saving the string into $t5 register 
        move    $t5, $t3     
        # Saving the bytes into $t3 register (the input_string)     
        sb      $t3, ($t4)
        # Incrementing the counter 
        addi    $t4, $t4, 1     
        bnez    $t3, remove_duplicates 
        syscall 
	# Jump to the address back 
	jr $ra 

string_transform:
# The ASCII codes for a-z are 97-122.
# The ASCII codes for A-Z are 65-90.
# If ascii value between (97-122) then convert into uppercase by subtracting by 32, else jump to check if it's a uppercase character
# If the ascii is between (65-90), then convert into lowercase by adding 32, else consider it as a special character and skip the conversion

	# Convert lowercase to uppercase with -32 
	lower_to_upper:
		# Load the bytes into a register from the specified address
		lb $t1, ($t0)
		# Branch if $t1 register is equal to 0 
		beq $t1, 0, exit_program
		# If value of the $t1 register is smaller than ascii of lowercase 'a' (97), call the upper_to_lower
  		blt $t1, 'a', upper_to_lower
  		# If value if $t1 register is greater than ascii of lowercase 'z' (122), call the upper_to_lower 
    		bgt $t1, 'z', upper_to_lower
    		# Subtract 32 from the $t1 register, to get uppercase character and save it
   		sub $t1, $t1, 32
   		# Storing the least significant byte of $t0
   		sb $t1, ($t0)
   		
   		# After each iteration, increment the counter 
   		addi $t0, $t0, 1
   		# Jump back into the lower_to_upper
      		j lower_to_upper
		
	# Convert uppercase to lowercase with +32 
	upper_to_lower:
		# If value of $t1 is smaller than ascii of 'A' (65), then skip converting the character
		blt $t1, 'A', skip_character  
		# If the value of $t1 is greater than ascii of 'Z' (90), then skip converting the character   
     		bgt $t1, 'Z', skip_character 
     		# Else, add 32 to the ascii value to make it lowercase 
      		add $t1, $t1, 32  
      		# Store the least significant bytes of $t0
      		sb $t1, ($t0)
	
	skip_character: 
		# Increment the $t0 register value on each iteration
    		addi $t0, $t0, 1
    		# Jump back to the lowercase to uppercase character method
    		j lower_to_upper
    	# Jump to the address back
	jr $ra

reverse_string:
	# Loop through to the end of the string, once the next value is "\n", call the helper method to print the elements one by one
	
	# Load the first value of the input_string 
	lb $s1, 0($t6)
	# Once it's the end of the string, presence of null byte, call the helper method
	beqz $s1, reverse_string_helper
	# Advance the counter 
	addi $t6, $t6, 1
	# recursively call the function again
	j reverse_string
	
	# helper method to print the elements from last index to first
	reverse_string_helper:
		# Decrement the counter from length of the string by 1 and saving it
		 subi $t6, $t6, 1
		 blt $t6, $s0, exit_program 
		 # Print the character one by one
		 li $v0, 11
		 lb $a0, 0($t6) 
		 syscall 
		 # Recursively call the helper method 
		 j reverse_string_helper
exit_program:
	# Jump to the address back
	jr $ra


# Reference: https://stackoverflow.com/questions/60914096/mips-delete-consecutive-duplicates-from-input
# Reference: https://stackoverflow.com/questions/8198205/reversing-a-string-in-mips-assembly