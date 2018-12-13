# Towers of Hanoi
# Kiernan Roche

# registers:
# $a0: disk number (n)
# $a1: source tower 'A'
# $a2: dest tower 'B'
# $a3: aux tower 'C'

.data

prompt1:	.asciiz "How many disks?\t"
out1:		.asciiz "Moved "
out2:		.asciiz " from "
out3:		.asciiz " to "
nl:		.asciiz "\n"

.text

main:
	li $v0, 4	# prompt the user for the number of disks
	la $a0, prompt1
	syscall
	li $v0, 5
	syscall
	move $a0, $v0	# store number of disks in $a0
   
    	li $a1, 65	# ascii 'A'
    	li $a2, 66	# ascii 'B'
    	li $a3, 67	# ascii 'C'

    	jal hanoi	# start recursion
    	
    	la $v0, 10
    	syscall		# exit program

hanoi:
        addi $sp, $sp, -20	# allocate 5 words on the stack
        sw $a0, 4($sp)		# push arguments and return addr
        sw $a1, 8($sp)		# onto the stack
        sw $a2, 12($sp)		# saving these avoids overwriting by
        sw $a3, 16($sp)		# recursive calls
        sw $ra, 0($sp)		
        
        beq $a0, 1, if_base	# base case. final leaf of recursion tree
	bne $a0, 1, after_if
	if_base:
		jal movedisk	# move disks, then skip the rest of the hanoi function.
		j return	# this is equivalent to an if-else
	after_if:		
        
        subi $a0, $a0, 1	# disk - 1
        move $t0, $a2		# switch $a2 (dest) and $a3 (aux)
        move $a2, $a3
        move $a3, $t0
        jal hanoi
	addi $a0, $a0, 1	# restore disk to original value
	
	lw $a1, 8($sp)      	# restore arguments from the stack
        lw $a2, 12($sp)
        lw $a3, 16($sp)
        jal movedisk		# move disks
        
        subi $a0, $a0, 1	
        move $t0, $a1       	# switch $a1 (source) and $a3 (aux)
        move $a1, $a3
        move $a3, $t0
        jal hanoi
        addi $a0, $a0, 1

	return:
        lw $a0, 4($sp)      	# load args and $ra back
        lw $a1, 8($sp)     	# from the stack
        lw $a2, 12($sp)
        lw $a3, 16($sp)
        lw $ra, 0($sp)
        addi $sp, $sp, 20	# free 5 words on the stack

        jr $ra              # return to caller
    
movedisk:
	move $t0, $a0	# store $a0 in $t0 so it is not overwritten
	li $v0, 4	
	la $a0, out1
	syscall		# print "Moved "
	li $v0, 1
	move $a0, $t0
	syscall		# print disk number
	li $v0, 4
	la $a0, out2
	syscall		# print " from "
	li $v0, 11	
	move $a0, $a1
	syscall		# print source tower
	li $v0, 4
	la $a0, out3
	syscall		# print " to "
	li $v0, 11
	move $a0, $a2
	syscall		# print destination tower
	li $v0, 4
	la $a0, nl
	syscall		# print newline
	
	move $a0, $t0	# restore $a0
	
        jr $ra		# return to caller
