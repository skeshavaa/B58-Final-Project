# Bitmap display starter code## Bitmap Display Configuration:
# -Unit width in pixels: 8
# -Unit height in pixels: 8
# -Display width in pixels: 256
# -Display height in pixels: 256
# -Base Address for Display: 0x10008000 ($gp)
#
.eqv BASE_ADDRESS0x10008000
.text
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
	li $t1, 0xff0000 # $t1 stores the red colour 
	li $t2, 0x00ff00 # $t2 stores the green colour codeli 
	$t3, 0x0000ff # $t3 stores the blue colour code
	sw $t1, 0($t0)# paint the first (top-left) unit red. 
	sw $t2, 4($t0) # paint the second unit on the first row green. Why $t0+4?
	sw $t3, 128($t0) # paint the first unit on the second row blue. Why +128?
	li $v0, 10 # terminate the program gracefully
	
main:
	li $t9, 0xffff0000 
	lw $t8, 0($t9)
	beq $t8, 1, keypress_happened
	
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000from before
	beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal
	
	syscall