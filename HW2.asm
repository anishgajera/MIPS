# CS 2340.002 HW 2
# Dr. Mazidi
# Written by Anish Gajera starting 2/14/22

.data
# prompt that will go in the dialog box
prompt:		.asciiz "Enter some text: "
# variable that will hold the user's input (have enough space for what the user enters)
string:		.space 50
# goodbye prompt for the end (per assignment instructions)
goodbye:	.asciiz "Goodbye!"
# word and char output "identifiers"
words:		.asciiz " words, "
characters:	.asciiz " characters \n\n"
space:		.asciiz " "

.text
main:
	# dialog syscall prompting the user to enter some text 
	li	$v0, 54
	la	$a0, prompt # essentially "load" the prompt into dialog box
	la	$a1, string # load address of the string that is entered by the user 
	li	$a2, 50
	syscall 
	
	# if no input then exit
	bnez $a1, exit
	
	li	$t5, 0 # $t0 is the word count (i)
	li	$t1, 0 # $t2 is the char count (j)
	# "call" wc_count (this function "calculates" the word and char count)
	jal	wc_count
	la	$t5, ($v0)
	la	$t1, ($v1)
	# store the initial number of words and chars
	#sw 	$t0, numWords
	#sw	$t1, numChars
	# output
	# output the string
	li	$v0, 4
	la	$a0, string
	syscall
	# output the word count
	li	$v0, 1
	la	$a0, ($t5)
	syscall
	#output part of the output 
	li	$v0, 4
	la	$a0, words
	syscall
	# output the char count
	li	$v0, 1
	la	$a0, ($t1)
	syscall
	# output the last part of the output
	li	$v0, 4
	la	$a0, characters
	syscall
	# keep repeating program (per assignment instructions) until "further notice"
	j 	main
exit:	
	li	$v0, 59
	la	$a0, goodbye
	syscall
	li	$v0, 10
	syscall
	
# various loops/functions
# this counts the number of words and characters in the string entered by the user	
wc_count:
	lb	$t4, space
	addi	$sp, $sp, -8 # configure the stack pointer (by 8 bytes considering word and char count)
	sw	$s1, 4($sp) # store what is at the 4th index in the stack pointer (using $s1 here for return (per assignment instructions))
	sw	$ra, 0($sp) # store what is at the 0 index of $sp (i.e. the return address)
	# in $t2, load the address of the string we want to get the word and char count of
	la	$t2, string
# loop
loop:	lb	$t3, ($t2) # into $t3, load one byte of the string from $t2
	beqz	$t3, return # if the loaded byte of the string is a space (i.e. a null character, then return)
	# else if the loaded byte is not a space/null character
	beq	$t3, $t4, continue # then continue
label:
	addi	$t1, $t1, 1 # if we continue, first increment j (the char counter)
	addi	$t2, $t2, 1 # also inrcrement the register that holds the address of the string (bump up the bits)
	j 	loop # jump to loop and continue process until done
continue:
	addi	$t5, $t5, 1 # increment i (word counter)
	j	label
	
return:
	addi	$v0, $t5, 1 # should you return, increment i to add final word count
	addi	$v1, $t1, -1
	# restore from stack (per assignment instructions)
	lw 	$s1, 4($sp)
	lw	$ra, 0($sp)
	#re-configure the stack (again by 8 bytes considering word and char count)
	addi	$sp, $sp, 8
	jr	$ra # return
	