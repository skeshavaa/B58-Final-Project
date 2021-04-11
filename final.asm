#####################################################################
#
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Keshavaa Shaiskandan, 1006243940, shaiskan
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestones 1 and 2, partially 3
#
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - Yes
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.eqv BASE_ADDRESS0x10008000
.data
	c1:    .word    1, 0, 69
	c2:    .word    1, 0, 69
	c3:    .word    1, 0, 69
	ship: .word  260, 0, 0, 100
	newline: .asciiz "\n"
	special: .asciiz "hi!"
	
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
	addi $t6, $zero, 0
obstacle_loop:
	add $t6, $t6, 1
	beq $t6, 1, obstacle1
	beq $t6, 2, obstacle2
	beq $t6, 3, obstacle3
	beq $t6, 4, check_key
obstacle1:
	la $t4, c1
	jal check_location
	j obstacle_check
obstacle2:
	la $t4, c2
	jal check_location
	j obstacle_check
obstacle3:
	la $t4, c3
	jal check_location
	j obstacle_check
	
obstacle_check:
	lw $t5, 4($t4)
	beq $t5, $zero, draw_obstacles
	jal move_obstacles
	j obstacle_loop
	
check_key:	
	li $t9, 0xffff0000 
	lw $t9, 0($t9)
	beq $t9, 1, keypress_happened
drawing:
	jal draw_ship
	jal collision_detection
	jal draw_health
	li $v0, 32
	li $a0, 125
	syscall
	jal refresh
	j main
game_over:
	jal refresh
play_again:
	li $t9, 0xffff0000 
	lw $t9, 0($t9)
	beq $t9, 1, keypress_happened
	li $v0, 32
	li $a0, 125
	syscall
	j play_again
	li $v0, 10
	syscall
	

	

	

check_location:
	lw $t5, 0($t4)
	li $t0, 0x10008000
check_loop:
	beq $t5, $t0, exit_location_check
	bgt $t0, 268476416, obstacle_check
	addi $t0, $t0, 256
	j check_loop
exit_location_check:
	addi $t6, $zero, 0
	sw $zero, 4($t4)
	jr $ra

draw_obstacles:
	li $t0, 0x10008000 # $t0 stores the base address for display
	li $a1, 28  #Here you set $a1 to the max bound.
    	li $v0, 42  #generates the random number.
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
    	
	j check_key

move_obstacles:
	li $t3, 0x0000ff # $t3 stores the blue colour code
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
	
	jr $ra

keypress_happened:
	li $t9, 0xffff0000 
	lw $t9, 4($t9) # this assumes $t9 is set to 0xfff0000from before
	beq $t9, 0x61, respond_to_a
	beq $t9, 0x77, respond_to_w
	beq $t9, 0x73, respond_to_s
	beq $t9, 0x64, respond_to_d
	beq $t9, 0x70, respond_to_p
	j drawing

#Checking a valid movement
respond_to_a:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t5, $zero, 0
	
loop_a: 
	beq $t5, $t4, drawing
	bgt $t5, 8192, end_a_check
	add $t5, $t5, 256
	j loop_a
end_a_check:
	addi $t4, $t4, -4
	la $t8, ship
	sw $t4, 0($t8)
	j drawing
	
respond_to_d:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t5, $zero, 252
	addi $t4, $t4, 16
loop_d: 
	beq $t5, $t4, drawing
	bgt $t5, 8444, end_d_check
	add $t5, $t5, 256
	j loop_d
end_d_check:
	addi $t4, $t4, -16
	addi $t4, $t4, 4
	la $t8, ship
	sw $t4, 0($t8)
	j drawing
	
respond_to_w:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t5, $zero, 0
loop_w: 
	beq $t5, $t4, drawing
	bgt $t5, 248, end_w_check
	add $t5, $t5, 4
	j loop_w
end_w_check:
	addi $t4, $t4, -256
	la $t8, ship
	sw $t4, 0($t8)
	j drawing
	
#Checking S movement is valid
respond_to_s:
	la $t4, ship
	lw $t4, 0($t4)
	addi $t5, $zero, 8192
	addi $t4, $t4, 1280
loop_s: 
	beq $t5, $t4, drawing
	bgt $t5, 8448, end_s_check
	add $t5, $t5, 4
	j loop_s
end_s_check:
	addi $t4, $t4, -1280
	addi $t4, $t4, 256
	la $t8, ship
	sw $t4, 0($t8)
	j drawing

respond_to_p:
	la $t4, ship
	addi $t5, $zero, 260
	sw $t5, 0($t4)
	addi $t5, $zero, 0
	sw $t5, 4($t4)
	sw $t5, 8($t4)
	addi $t5, $zero, 100
	sw $t5, 12($t4)
	
	la $t4, c1
	jal clean_obstacles
	la $t4, c2
	jal clean_obstacles
	la $t4, c3
	jal clean_obstacles
	
	j main
	
clean_obstacles:
	addi $t5, $zero, 1
	sw $t5, 0($t4)
	sw $zero, 4($t4)
	jr $ra
	
draw_ship:
	li $t0, 0x10008000
	la $t4, ship
	lw $t5, 4($t4)
	lw $t4, 0($t4)
	beq $t5, 1, damaged
	
healthy:
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
	j finish_drawing
damaged:
	add $t0, $t0, $t4
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, -260
	
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	
	sw $t1, 1284($t0)
	sw $t1, 1288($t0)
	
	la $t4, ship
	addi $t5, $zero, 0
	sw $t5, 4($t4)
finish_drawing:
	jr $ra

refresh:
	li $t5, 0x000000
	li $t0, 0x10008000
	addi $t8, $zero, 0
loop_refresh:
	sw $t5, 0($t0)
	addi $t0, $t0, 4
	addi $t8, $t8, 1
	beq $t8, 2048, end_refresh
	j loop_refresh
end_refresh:
	jr $ra
	
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
	la $t4, ship
	addi $t5, $zero, 1
	sw $t5, 4($t4)
	
	lw $t5, 8($t4)
	addi $t5, $t5, 1
	sw $t5, 8($t4)
	
	lw $t5, 12($t4)
	addi $t5, $t5, -5
	sw $t5, 12($t4)
	beq $t5, 0, game_over
	
	jr $ra

draw_health:
	li $t0, 0x10008000
	addi $t0, $t0, 7508
	la $t4, ship
	lw $t4, 12($t4)
	li $t5, 0x00FF00
health_loop:
	sw $t5, 0($t0)
	addi $t4, $t4, -5
	addi $t0, $t0, 4
	beq $t4, 0, health_complete
	j health_loop
health_complete:
	jr $ra
