# HW 4 (Bitmaps)
# CS 234.002 
# Written by Anish Gajera

# Instructions: 
# Connect bitmap display:
# 	- set pixel dim to 8x8
#	- set display dim to 256x256
#	- use $gp as base address
#	- connect keyboard and run
#	- use w (up), s (down), a (left), d (right), space (exit)
#	- all other keys are ignored

# set up some constants
# width of screen in pixels
# 256 / 8 = 32
.eqv WIDTH 32
# height of screen in pixels
.eqv HEIGHT 32
# colors
.eqv	RED 	0x00FF0000
.eqv	GREEN 	0x0000FF00
.eqv	BLUE 	0x000000FF
.eqv	CYAN 	0x0000FFFF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv	MAGENTA	0x00FF00FF

.data
colors:	.word	MAGENTA, YELLOW, WHITE, CYAN, BLUE, GREEN, RED

.text
main:
	# y1 = x p0siti0n 0f the tail
	li 	$s1, 92
	# y1 = y p0siti0n 0f the tail
	li 	$s2, 25
	# t3 = first Pixel 0f the screen
	li 	$t3, 0x10008000 
	# index 0
	li 	$t0,0 
	
	loop:	
	jal 	loop1
	jal	loop2
	jal 	loop3
	jal	loop4
	
	# check for input
	lw $t0, 0xffff0000  #t1 holds if input available
    	beq $t0, 0, loop   #If no input, keep displaying
	
	# process input
	lw 	$s1, 0xffff0004
	beq	$s1, 32, exit	# input space
	beq	$s1, 119, up 	# input w
	beq	$s1, 115, down 	# input s
	beq	$s1, 97, left  	# input a
	beq	$s1, 100, right	# input d
	# invalid input, ignore
	j	loop
	
	# process valid input
	
up:	li	$a2, 0		# black out the pixel
	jal	loop1
	addi	$a1, $a1, -1
	addi 	$a2, $0, RED
	jal	loop1
	j	loop

down:	li	$a2, 0		# black out the pixel
	jal	loop2
	addi	$a1, $a1, 1
	addi 	$a2, $0, BLUE
	jal	loop2
	j	loop
	
left:	li	$a2, 0		# black out the pixel
	jal	loop3
	addi	$a0, $a0, -1
	addi 	$a2, $0, MAGENTA
	jal	loop3
	j	loop
	
right:	li	$a2, 0		# black out the pixel
	jal	loop4
	addi	$a0, $a0, 1
	addi 	$a2, $0, YELLOW
	jal	loop4
	j	loop
	
# subroutine/test function to draw a pixel
draw_pixel:
	# $s1 = address = $gp + 4 * (x + y * width)
	# mul	$t9, $a1, WIDTH	# y + WIDTH
	# add	$t9, $t9, $a0	# add x
	# mul	$t9, $t9, 4	# multiply by 4 to get word offset
	# add	$t9, $t9, $gp	# add to base address
	# sw	$a2, ($t9)	# store color at memory location
	# jr	$ra		# return
	
loop1:
	mul 	$t2, $s2, 256 #y index
	add 	$t1, $t0, $s1 #center address
	mul 	$t1, $t1, 4
	add 	$t1, $t1, $t2
	addu 	$t1, $t3, $t1 # adds xy to first pixel ( $t3 )
	mul 	$a2, $t0, 4 #get addresss of color
	lw 	$a2, colors($a2)
	sw 	$a2, ($t1) # put the color red ($a2) in $t0
	# loop control variable
	add 	$t0, $t0, 1 
	# branch if less than to loop 1 again
	blt 	$t0,7,loop1
	# index 0
	li 	$t0,0 

loop2:
	add 	$t2, $s2, 7 #get next line
	mul 	$t2, $t2, 256 #get y index
	add 	$t1, $t0, $s1 #l0ad center address
	mul 	$t1, $t1, 4
	add 	$t1, $t1, $t2
	addu 	$t1, $t3, $t1 # adds xy t0 the first pixel ( t3 )
	mul 	$a2, $t0, 4 #get addresss of color
	lw 	$a2, colors($a2)
	sw 	$a2, ($t1) # put the c0l0r red ($a2) in $t0
	add 	$t0, $t0, 1 #i++
	#branch if less than to loop 2 again
	blt 	$t0, 7, loop2
	# index 0
	li 	$t0,0 

loop3:
	add 	$t2, $s2, $t0 #get next line
	mul 	$t2, $t2, 256 #get y index
	mul 	$t1, $s1, 4
	add 	$t1, $t1, $t2 #l0ad x y
	addu 	$t1, $t3, $t1 # adds xy t0 the first pixel ( t3 )
	mul 	$a2, $t0, 4 #get addresss of color
	lw 	$a2, colors($a2)
	sw 	$a2, ($t1) # put the c0l0r red ($a2) in $t0
	add 	$t0, $t0, 1 #i++
	# branch if less than to loop 3 again
	blt 	$t0, 7, loop3
	# index 0
	li 	$t0,0 

loop4:
	add 	$t2, $s2, $t0 #get next line
	mul 	$t2, $t2, 256 #get y index
	add 	$t1, $s1, 7 #get next line
	mul 	$t1, $t1, 4
	add 	$t1, $t1, $t2 #l0ad x y
	addu 	$t1, $t3, $t1 # adds xy t0 the first pixel ( t3 )
	mul 	$a2, $t0, 4 #get addresss of color
	lw 	$a2, colors($a2)
	sw 	$a2, ($t1) # put the c0l0r red ($a2) in $t0
	add 	$t0, $t0, 1 #i++
	# branch if less than to loop 4 again
	blt 	$t0, 8, loop4
	jal exit
	

exit:	li	$v0, 10
	syscall



	