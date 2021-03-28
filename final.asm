# Bitmap display starter code## Bitmap Display Configuration:
# -Unit width in pixels: 8
# -Unit height in pixels: 8
# -Display width in pixels: 256
# -Display height in pixels: 256
# -Base Address for Display: 0x10008000 ($gp)
#
.eqv BASE_ADDRESS0x10008000

.data
	c1:    .word    1, 10, 20
	newline: .asciiz "\n"

.text
	la $t4, c1

	li $t0, 0x10008000 # $t0 stores the base address for display
	li $t1, 0xff0000 # $t1 stores the red colour 
	li $t2, 0x808080 # $t2 stores the green colour code 
	li $t3, 0x0000ff # $t3 stores the blue colour code
	li $v0, 10 # terminate the program gracefully
	
	
	sw $t2, 260($t0)
	sw $t2, 264($t0)
	
	sw $t2, 520($t0)
	sw $t2, 524($t0)
	
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t2, 784($t0)
	sw $t1, 788($t0)
	
	sw $t2, 1032($t0)
	sw $t2, 1036($t0)
	
	sw $t2, 1284($t0)
	sw $t2, 1288($t0)

	
main:
	li $t9, 0xffff0000 
	lw $t8, 0($t9)
	#beq $t8, 1, keypress_happened
	
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000from before
	#beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal
	jal draw_obstacles
	li $v0, 10
	syscall

draw_obstacles:
	li $a1, 31  #Here you set $a1 to the max bound.
    	li $v0, 42  #generates the random number.
    	syscall
    	li $v0, 1   # 1 is the system call code to show an int number
	syscall     # as I said your generated number is at $a0, so it will be printed
	move $t5, $a0	
	li $v0 4
	la $a0 newline
	syscall
	
	mul $t5, $t5, 256
	addi $t5, $t5, 252
	add $t0, $t5, $t0
    	sw $t3, 0($t0)
	jr $ra