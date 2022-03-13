# CS 2340.002 HW 3
# Dr. Mazidi
# Written by Anish Gajera starting 3/07/22

.data
# variables which hold the necessary prompts, etc. and their corresponding storage variables
prompt1:	.asciiz	"What is your name? "
name:		.space	20
prompt2:	.asciiz	"Please enter your height in inches: "
height:		.word	0
prompt3:	.asciiz	"Please enter your weight in pounds: "
weight:		.word	0
constant:	.float	703.0
v1:		.float	18.5
v2:		.float	25.0
v3:		.float	30.0
# prompts for after bmi is calculated
output:	.asciiz	"Your BMI is: "
under:	.asciiz	"\nThis is considered underweight \n"
normal:	.asciiz	"\nThis is a normal weight \n"
over:	.asciiz	"\nThis is considered overweight \n"
obese:	.asciiz	"\nThis is considered obese \n"
# variable to hold the BMI after it is calculated
bmi:	.float	0.0

.text
main:
	# prompt user to enter name
	li	$v0, 4
	la	$a0, prompt1
	syscall
	
	# get the name
	li	$v0, 8
	li	$a1, 20
	la	$a0, name
	syscall
	
	# prompt user to enter height in inches
	li	$v0, 4
	la	$a0, prompt2
	syscall
	
	# get the height 
	li	$v0, 5
#	la	$a0, height
	syscall
	sw	$v0, height
	
	# prompt the user to enter weight in pounds
	li	$v0, 4
	la	$a0, prompt3
	syscall
	
	# get the weight
	li	$v0, 5
#	la	$a0, weight
	syscall
	sw	$v0, weight
	
	# print the users name (per assignment)
	li	$v0, 4
	la	$a0, name
	syscall
	
	# print
	li	$v0, 4
	la	$a0, output
	syscall
	
	# calculate the BMI (BMI = 703 x weight (lbs) / [height (in)]^2)
	# first load values into coprocessor
	lwc1	$f0, constant
	lwc1	$f2, height
	lwc1	$f10, weight
	# these 3 are the different BMI results we will compare the resulting BMI with to output the final message accordingly
	lwc1	$f14, v1
	lwc1	$f16, v2
	lwc1	$f20, v3
	
	#convert values to doubles with single precision (hence the .s)
	cvt.s.w	$f4, $f0
	cvt.s.w	$f6, $f2
	cvt.s.w	$f8, $f10
	
	mul.s	$f8, $f0, $f8 # 703 x weight (lbs)
	mul.s	$f6, $f6, $f6 # [height (in)]^2
	div.s 	$f12, $f8, $f6 # BMI = (703 x weight) / ([height]^2)
	# print BMI
	li	$v0, 2
	syscall
	
	
	# use loops to test BMI value and output message accordingly
	# compare if BMI < 18.5
	c.lt.s $f12, $f14
	# branch if true
	bc1t out1
	
	# compare if BMI < 25.0
	c.lt.s $f12, $f16
	# branch if true
	bc1t out2

	# compare if BMI < 30.0
	c.lt.s $f12, $f20
	# branch if true
	bc1t out3
	
	# else, person is obese
	li $v0, 4
	la $a0, obese
	syscall

	# else just exit
	b exit

# underweight output
out1:
	li $v0, 4
	la $a0, under
	syscall
	b exit

# normal weight output
out2:
	li $v0, 4
	la $a0, normal
	syscall
	b exit

#overweight output
out3:
	li $v0, 4
	la $a0, over
	syscall
	
	
exit:	li	$v0, 10
	syscall
	
