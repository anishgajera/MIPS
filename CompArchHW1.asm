# CS 2340.002 HW 1
# Dr. Mazidi
# Written by Anish Gajera starting 1/26/22


.data
# 3 memory locations to hold input values a, b, and c 
a:	.word 0
b:	.word 0
c:	.word 0


# 3 memory locations to hold output values
out1:	.word 0
out2:	.word 0
out3:	.word 0

# memory location to hold the user's name
name:	.word 0

# 3 memory locations for messages (prompts)
msg1:		.asciiz "Enter name: "
msg2:		.asciiz "\n Enter an integer between 1 - 100: "
results:	.asciiz "\n Results: "

.text
main:

	# prompt the user to imput their name
	li $v0, 4		# this is the syscall value for outputting a string
	la $a0, msg1		# $a0 is where the prompt should be placed
	syscall
	
	# get name
	li $v0, 8 		# this is the syscall value for reading a string
	li $a1, 20		# this is the max length for the name
	la $a0, name
	syscall
	
	# 1st prompt (for a)
	# prompt the user to enter an integer between 1 - 100
	li $v0, 4
	la $a0, msg2
	syscall
	
	# get 1st integer
	li $v0, 5
	syscall
	sw $v0, a
	lw $t1, a
	
	# 2nd prompt (for b)
	# prompt the user to enter an integer between 1 - 100
	li $v0, 4
	la $a0, msg2
	syscall
	
	# get 2nd integer
	li $v0, 5
	syscall
	sw $v0, b
	lw $t2, b
	
	# 3rd prompt (for c)
	# prompt the user to enter an integer between 1 - 100
	li $v0, 4
	la $a0, msg2
	syscall
	
	# get 3rd integer
	li $v0, 5
	syscall
	sw $v0, c
	lw $t3, c
	
	# initial location for the output (answers) **may not need this** 
	# lw $s1, out1
	# lw $s2, out2
	# lw $s3, out3
	
	# calculate ans1 = 2a - c + 4
	add $s1, $t1, $t1 # 2a
	sub $s1, $s1, $t3 # - c
	addi $s1, $s1, 4 # + 4
	sw $s1, out1
	
	# calculate ans2 = b - c + (a - 2)
	subi $t4, $t1, 2 # store parenthesis expr (a - 2) in $t4
	sub $s2, $t2, $t3 # b - c
	add $s2, $s2, $t4 # (b - c) + (a - 2)
	sw $s2, out2
	
	# calculate ans3 = (a + 3) - (b - 1) + (c + 3)
	addi $t5, $t1, 3 # store (a + 3) in $t5
	subi $t6, $t2, 1 # store (b - 1) in $t6
	addi $t7, $t3, 3 # store (c + 3) in $t7
	sub $s3, $t5, $t6
	add $s3, $s3, $t7
	sw $s3, out3
	
	# display user's name
	li $v0, 4
	la $a0, name
	syscall
	
	
	# display user's results
	# ans1
	li $v0, 1
	lw $a0, out1
	syscall
	
	# input space
	li $a0, 32
	li $v0, 11  # syscall number for printing character
	syscall
	

	# ans2
	li $v0, 1
	lw $a0, out2
	syscall
	
	# input space
	li $a0, 32
	li $v0, 11  # syscall number for printing character
	syscall
	
	# ans3
	li $v0, 1
	lw $a0, out3
	syscall
	
exit:	li $v0, 10
	syscall
	
# COMMENTS WITH TEST VALUES AND RESULTS YOU SHOULD EXPECT
# if: a = 3; b = 6; c = 5
# results: 5 2 9 

# if: a = 30; b = 23; c = 14
# results: 50 37 28
