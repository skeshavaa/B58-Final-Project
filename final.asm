# Bitmap display starter code## Bitmap Display Configuration:
# -Unit width in pixels: 8
# -Unit height in pixels: 8
# -Display width in pixels: 256
# -Display height in pixels: 256
# -Base Address for Display: 0x10008000 ($gp)
#
.eqv BASE_ADDRESS0x10008000
.text
	li $t0, 0x10008000 # $t0 stores the base address for display
	li $t1, 0xff0000 # $t1 stores the red colour 
	li $t2, 0x808080 # $t2 stores the green colour code 
	li $t3, 0x0000ff # $t3 stores the blue colour code
	li $v0, 10 # terminate the program gracefully
	
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	
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
	
	sw $t2, 1536($t0)
	sw $t2 1540($t0)
	sw $t2 1544($t0)
	sw $t1, 1548($t0)
	
main:
	li $t9, 0xffff0000 
	lw $t8, 0($t9)
	#beq $t8, 1, keypress_happened
	
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000from before
	#beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal
	jal main
	syscall
