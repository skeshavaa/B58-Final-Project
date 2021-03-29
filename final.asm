# Bitmap display starter code## Bitmap Display Configuration:
# -Unit width in pixels: 8
# -Unit height in pixels: 8
# -Display width in pixels: 256
# -Display height in pixels: 256
# -Base Address for Display: 0x10008000 ($gp)
#
.eqv BASE_ADDRESS0x10008000

.data
	c1:    .word    1, 0, 69
	ship: .word  260
	newline: .asciiz "\n"
	special: .asciiz "hi!"
	offset: .byte 4

.text
	la $t4, c1

	li $t0, 0x10008000 # $t0 stores the base address for display
	li $t1, 0xff0000 # $t1 stores the red colour 
	li $t2, 0x808080 # $t2 stores the green colour code 
	li $t3, 0x0000ff # $t3 stores the blue colour code
	li $v0, 10 # terminate the program gracefully
	

	
main:
	#li $t9, 0xffff0000 
	#lw $t8, 0($t9)
	#beq $t8, 1, keypress_happened
	
	#lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000from before
	#beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal
	li $t0, 0x10008000 # $t0 stores the base address for display
	la $t4, c1
	
	lw $t4, 4($t4)
	beq $t4, $zero, draw_obstacles
	j move_obstacles
	
loop:	
	li $t9, 0xffff0000 
	lw $t9, 0($t9)
	beq $t9, 1, keypress_happened
	
loop2:
	j draw_ship
loop3:
	li $v0, 32
	li $a0, 500 #Sleep for 500 seconds
	syscall
	
	j main
	li $v0, 10
	syscall

draw_obstacles:
	li $a1, 31  #Here you set $a1 to the max bound.
    	li $v0, 42  #generates the random number.
    	la $t4, c1
    	syscall
    	
    	
	
	move $t5, $a0	
	
	mul $t5, $t5, 256
	addi $t5, $t5, 252
	add $t0, $t5, $t0
    	sw $t3, 0($t0)
    	sw $t0, 0($t4)
    	
    	li $v0, 1
    	move $a0, $t0
	syscall
	li $v0 4
	la $a0 newline
	syscall
	
    	addi $t3, $zero, 1
    	sw $t3, 4($t4)
    	
	j loop

move_obstacles:
	la $t4, c1
	lw $t5, 0($t4)

	#li $v0 1
	#move $a0 $t5
	#syscall
	
	
	addi $t5, $t5, -4
	sw $t5, 0($t4)
	sw $t0, ($t5)
	sw $t3, 0($t0)
	
	j loop

keypress_happened:
	li $t9, 0xffff0000 
	lw $t9, 4($t9) # this assumes $t9 is set to 0xfff0000from before
	beq $t9, 0x61, respond_to_a
	beq $t9, 0x77, respond_to_w
	beq $t9, 0x73, respond_to_s
	beq $t9, 0x64, respond_to_d
	j loop2
	
respond_to_a:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t4, $t4, -4
	la $t8, ship
	sw $t4, 0($t8)
	j loop2
	
respond_to_d:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t4, $t4, 4
	la $t8, ship
	sw $t4, 0($t8)
	j loop2
	
respond_to_w:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t4, $t4, -256
	la $t8, ship
	sw $t4, 0($t8)
	j loop2

respond_to_s:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t4, $t4, 256
	la $t8, ship
	sw $t4, 0($t8)
	j loop2
	
draw_ship:
	li $t0, 0x10008000
	la $t4, ship
	lw $t4, 0($t4)
	
	li $v0 1
	move $a0 $t4
	syscall
	li $v0 4
	la $a0 newline
	syscall
	
	add $t0, $t0, $t4
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, -260
	
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
	
	j loop3
	
	