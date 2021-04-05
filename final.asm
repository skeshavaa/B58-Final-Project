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
	li $t5, 0x000000
	li $v0, 10 # terminate the program gracefully
	

	
main:
	li $t0, 0x10008000 # $t0 stores the base address for display
	
	
	
	j check_location
drawing:
	li $t0, 0x10008000
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
	jal collision_detection
	li $v0, 32
	li $a0, 125 #Sleep for 500 seconds
	syscall
	j refresh
	j main
	li $v0, 10
	syscall

check_location:
	la $t4, c1
	lw $t4, 0($t4)
	li $t0, 0x10008000
check_loop:
	beq $t4, $t0, exit_location_check
	bgt $t0, 268476416, drawing
	addi $t0, $t0, 256
	j check_loop
	
exit_location_check:
	la $t4, c1
	addi $t6, $zero, 0
	sw $zero, 4($t4)
	j drawing

draw_obstacles:
	li $a1, 28  #Here you set $a1 to the max bound.
    	li $v0, 42  #generates the random number.
    	la $t4, c1
    	syscall
  
    	
    	addi $a0, $a0, 2
	
	move $t5, $a0	
	
	mul $t5, $t5, 256
	addi $t5, $t5, 252
	add $t0, $t5, $t0
    	sw $t3, 0($t0)
    	sw $t0, 0($t4)
    	
	
    	addi $t3, $zero, 1
    	sw $t3, 4($t4)
    	
	j loop

move_obstacles:
	li $t3, 0x0000ff # $t3 stores the blue colour code
	la $t4, c1
	lw $t5, 0($t4)

#	li $v0 1
#	move $a0 $t5
#	syscall
#	li $v0 4
#	la $a0 newline
#	syscall
	
	addi $t5, $t5, -4
	sw $t5, 0($t4)
	
	la $t4, 0($t4)
	add $t0, $zero, $t5
	
	sw $t3, -4($t0)
	sw $t3, 0($t0)
	sw $t3, 256($t0)
	sw $t3, -256($t0)
	
	j loop

keypress_happened:
	li $t9, 0xffff0000 
	lw $t9, 4($t9) # this assumes $t9 is set to 0xfff0000from before
	beq $t9, 0x61, respond_to_a
	beq $t9, 0x77, respond_to_w
	beq $t9, 0x73, respond_to_s
	beq $t9, 0x64, respond_to_d
	j loop2

#Checking a valid movement
respond_to_a:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t5, $zero, 0
	
loop_a: 
	beq $t5, $t4, loop2
	bgt $t5, 8192, end_a_check
	add $t5, $t5, 256
	j loop_a
end_a_check:
	addi $t4, $t4, -4
	la $t8, ship
	sw $t4, 0($t8)
	j loop2
	
respond_to_d:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t5, $zero, 252
	addi $t4, $t4, 16
loop_d: 
	beq $t5, $t4, loop2
	bgt $t5, 8444, end_d_check
	add $t5, $t5, 256
	j loop_d
end_d_check:
	addi $t4, $t4, -16
	addi $t4, $t4, 4
	la $t8, ship
	sw $t4, 0($t8)
	j loop2
	
respond_to_w:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t5, $zero, 0
loop_w: 
	beq $t5, $t4, loop2
	bgt $t5, 248, end_w_check
	add $t5, $t5, 4
	j loop_w
end_w_check:
	li $v0 1
	move $a0 $t4
	syscall
	li $v0 4
	la $a0 newline
	syscall
	addi $t4, $t4, -256
	la $t8, ship
	sw $t4, 0($t8)
	j loop2
	
#Checking S movement is valid
respond_to_s:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t5, $zero, 8192
	addi $t4, $t4, 1280
loop_s: 
	beq $t5, $t4, loop2
	bgt $t5, 8448, end_s_check
	add $t5, $t5, 4
	j loop_s
end_s_check:
	addi $t4, $t4, -1280
	addi $t4, $t4, 256
	la $t8, ship
	sw $t4, 0($t8)
	j loop2
	
draw_ship:
	li $t0, 0x10008000
	la $t4, ship
	lw $t4, 0($t4)
	
	
	
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

refresh:
	li $t5, 0x000000
	li $t0, 0x10008000
	addi $t8, $zero, 0
loop_refresh:
	sw $t5, 0($t0)
	addi $t0, $t0, 4
	addi $t8, $t8, 1
	beq $t8, 2048, main
	j loop_refresh
	
collision_detection:
	li $t0, 0x10008000
	la $t4, ship
	lw $t4, 0($t4)
	
	add $t0, $t0, $t4
	
	
	la $t4, 8($t0)
	lw $t4, 0($t4)

	beq $t4, 255, detected
	
	la $t4, 268($t0)
	lw $t4, 0($t4)
	
	beq $t4, 255, detected
	
	la $t4, 532($t0)
	lw $t4, 0($t4)
	
	beq $t4, 255, detected
	
	la $t4, 780($t0)
	lw $t4, 0($t4)
	
	beq $t4, 255, detected
	
	la $t4, 1032($t0)
	lw $t4, 0($t4)
	
	beq $t4, 255, detected
	
	addi $t0, $t0, -260
	
	jr $ra

detected:
	li $v0 4
	la $a0 special
	syscall
	li $v0 4
	la $a0 newline
	syscall
	
	jr $ra
