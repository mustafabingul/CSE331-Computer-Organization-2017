		
		
	.data
comma: .asciiz "."
nl:		.asciiz "\n"
p_zero: .asciiz "0"
str: .asciiz "Wrong Operator..!"
mine: .asciiz "-"


	.globl main
	.text
main:
	
	
	li	$v0,5
	syscall	
	move	$s0,$v0
	
	li	$v0,5
	syscall	
	move	$s1,$v0
	
	
	li $v0,12
	syscall
	move $a3,$v0
		
	
	li $v0,5
	syscall
	move $s2,$v0
	
	
	li $v0,5
	syscall
	move $s3,$v0
	
	beq $a3,'*',multiplication
	beq $a3,'+',summation
	beq $a3,'-',subtraction
	j the_end_message	
	
multiplication:
	move $t0,$s1			
	jal find_digit_number1		
	move $s4,$t7	
	
	move $t0,$s3	
	jal find_digit_number1
	move $s5,$t7
	
	move $t0,$s4
	jal expfind
	mult $t1,$s0
	mflo $t1
	add $t9,$s1,$t1
	move $s0,$t9
	
	move $t2,$s5
	jal expfind2
	mult $t3,$s2
	mflo $t3
	add $t8,$t3,$s3
	move $s2,$t8
	
	mult $s0,$s2
	mflo $t1	
	move $s7,$t1
	
	move $t0,$s4
	move $t1,$s5
	add $t2,$t0,$t1
	move $s6,$t2
	
	move $t5,$s6
	jal expfind3
	move $t9,$t6
	
	div $s7,$t9	
	mfhi $t8	
	move $t6,$t8
	mflo $t7
	move $t5,$t7
	
	 li $v0,1
	 move $a0,$t5
	 syscall 	
	
	li $v0,4
	la $a0,comma
	syscall
	
	move $t0,$t6
	jal find_digit_number1
	bne $s6,$t7,printmultzero
	j dontzeromult
printmultzero:
	sub $t3,$s6,$t7	
	jal print_zeromult
dontzeromult:
	li $v0,1
	move $a0,$t6
	syscall
	
	j the_end
subtraction:
	
	move $t0,$s1				
	jal find_digit_number1		
	move $s4,$t7
	
	move $t0,$s3	
	jal find_digit_number1
	move $s5,$t7
	
	beq $s4,$s5,eqq
	
	li $a0,0
	li $a1,1
	slt $a0,$s4,$s5
	beq $a0,$a1,e1
	move $t9,$s4
	j e2
e1:	move $t9,$s5	
	j goon
e2:
	sub $t9,$s4,$s5
	move $t5,$t9
	jal expfindsub
	mult $s3,$t6
	mflo $t8
	move $s6,$t8
	move $t0,$s6
	jal find_digit_number1
	move $t5,$t7
	jal expfindsub
	mult $t6,$s2
	mflo $t5
	add $t5,$t5,$s6
	move $s6,$t5	
	move $t5,$s4
	jal expfindsub
	mult $t6,$s0
	mflo $t5
	add $t5,$t5,$s1
	move $s7,$t5
	sub $t9,$s7,$s6
	div $t9,$t6
	mflo $t0
	mfhi $t1
	li $a0,0
	li $a1,1
	li $a2,-1
	slt $a0,$t1,$zero
	beq $a0,$a1,do_positive4
	j already_positive4
do_positive4:
	mult $t1,$a2
	mflo $t1	
already_positive4:	
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,comma
	syscall
	move $t0,$t1
	jal find_digit_number1
	move $t3,$t7
	bne $t3,$s4,g3
	j devam3
g3:
	sub $t3,$s4,$t3
	jal print_zero
devam3:		
	li $v0,1
	move $a0,$t1
	syscall
	j endd
goon:
	sub $t9,$s5,$s4
	move $t5,$t9		
	jal expfindsub	
	mult $s1,$t6
	mflo $t8	
	move $s6,$t8
	move $t0,$s6
	jal find_digit_number1	
	move $t5,$t7
	jal expfindsub
	mult $t6,$s0
	mflo $t5
	add $t5,$t5,$s6
	move $s6,$t5
	move $t0,$s3
	jal find_digit_number1
	move $t5,$t7
	jal expfindsub
	mult $s2,$t6
	mflo $t7
	add $s7,$t7,$s3
	sub $t9,$s6,$s7
	div $t9,$t6
	mflo $t0
	mfhi $t1
	li $a0,0
	li $a1,1
	li $a2,-1
	slt $a0,$t1,$zero
	beq $a0,$a1,do_positive5
	j already_positive5
do_positive5:
	mult $t1,$a2
	mflo $t1	
already_positive5:
	li $a0,0
	beq $t0,$a0,print_mine
	j dont_mine
print_mine:
	li $v0,4
	la $a0,mine
	syscall		
dont_mine:
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,comma
	syscall
	move $t0,$t1
	jal find_digit_number1
	move $t3,$t7
	bne $t3,$s5,g2
	j devam1
g2:
	sub $t3,$s5,$t3
	jal print_zero
devam1:		
	li $v0,1
	move $a0,$t1
	syscall
	j endd
eqq:
	move $t5,$s5
	jal expfindsub
	mult $s0,$t6
	mflo $t8
	add $s6,$t8,$s1
	mult $s2,$t6
	mflo $t8
	add $s7,$t8,$s3
	sub $t9,$s6,$s7
	div $t9,$t6
	mfhi $t1
	mflo $t0
	li $a0,0
	li $a1,1
	li $a2,-1
	slt $a0,$t1,$zero
	beq $a0,$a1,do_positive
	j already_positive
do_positive:
	mult $t1,$a2
	mflo $t1
already_positive:
		
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,comma
	syscall
	move $t0,$t1
	jal find_digit_number1
	move $t3,$t7
	bne $s5,$t3,g1
	j devam
g1:	
	sub $t3,$s5,$t3
	jal print_zero
devam:
	li $v0,1
	move $a0,$t1
	syscall	
	
endd:	
	
	li	$v0,10
	syscall
	
	
	j the_end
summation:
	
	move $t0,$s1				
	jal find_digit_number1		
	move $s4,$t7
	
	move $t0,$s3	
	jal find_digit_number1
	move $s5,$t7
	
	beq $s1,$zero,zerotopla
	beq $s3,$zero,zerotopla
	beq $s4,$s5,eq
	
	li $a0,0
	li $a1,1
	slt $a0,$s4,$s5
	beq $a0,$a1,b1
	move $t9,$s4
	j b2
b1:	move $t9,$s5	
	j gooon
b2:					
	sub $t9,$s4,$s5
	move $t5,$t9	
	jal expfindsub
	mult $s3,$t6	
	mflo $t8
	move $s6,$t8
	move $t0,$s6
	jal find_digit_number1
	move $t5,$t7			
	jal expfindsub
	mult $t6,$s2
	mflo $t5
	add $t5,$t5,$s6
	move $s6,$t5	
	move $t5,$s4	
	jal expfindsub
	mult $t6,$s0	
	mflo $t5
	add $t5,$t5,$s1	
	move $s7,$t5	
	add $t9,$s7,$s6	
	div $t9,$t6 			
	mflo $t0
	mfhi $t1
	
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,comma
	syscall
	move $t0,$t1
	jal find_digit_number1
	move $t3,$t7
	bne $t3,$s4,h3
	j cont3
h3:
	sub $t3,$s4,$t3
	jal print_zero
cont3:		
	li $v0,1
	move $a0,$t1
	syscall
	j endd2
gooon:
	sub $t9,$s5,$s4
	move $t5,$t9			
	jal expfindsub
	mult $s1,$t6
	mflo $t8	
	move $s6,$t8
	move $t0,$s6
	jal find_digit_number1
	move $t5,$t7		
	jal expfindsub		
	mult $t6,$s0		
	mflo $t5					
	add $t5,$t5,$s6		
	move $s6,$t5		
	move $t0,$s3		
	jal find_digit_number1
	move $t5,$t7				
	jal expfindsub
	mult $s2,$t6	
	mflo $t7		
	add $s7,$t7,$s3	
	add $t9,$s6,$s7	
	div $t9,$t6		
	mflo $t0		
	mfhi $t1		
			
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,comma
	syscall
	move $t0,$t1	
	jal find_digit_number1
	move $t3,$t7
	bne $t3,$s5,h2
	j cont1
h2:
	sub $t3,$s5,$t3
	jal print_zero
cont1:		
	li $v0,1
	move $a0,$t1
	syscall
	j endd2
eq:
	move $t5,$s5 
	jal expfindsub
	mult $s0,$t6
	mflo $t8
	add $s6,$t8,$s1
	mult $s2,$t6
	mflo $t8
	add $s7,$t8,$s3
	add $t9,$s6,$s7
	div $t9,$t6
	mfhi $t1
	mflo $t0
			
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,comma
	syscall
	move $t0,$t1
	jal find_digit_number1
	move $t3,$t7
	bne $s5,$t3,h1
	j cont
h1:	
	sub $t3,$s5,$t3
	jal print_zero
cont:
	li $v0,1
	move $a0,$t1
	syscall
	j endd2
	
zerotopla:
	add $t9,$s0,$s2
	add $t8,$s1,$s3
	li $v0,1
	move $a0,$t9
	syscall
	li $v0,4
	la $a0,comma
	syscall
	li $v0,1
	move $a0,$t8
	syscall	
	
endd2:
	
	
	j the_end
the_end_message:	
	li $v0,4
	la $a0,str
	syscall
the_end:
	li $v0,10
	syscall
	
	

	.text
	.globl 	expfind3
expfind3:
	li $a0,0
	li $a1,1
	li $a2,10
	li $a3,10	
	add $t6,$t6,$a2
lp3:
	beq $t5,$a1,lp03
	mult $t6,$a3
	mflo $t6
	sub $t5,$t5,1	
	beq $t5,$a0,lp03
	bne $t5,$a1 lp3
lp03:		
	jr $ra
	
	.text
	.globl 	expfind
expfind:
	li $a0,0
	li $a1,1
	li $a2,10
	li $a3,10
	add $t1,$t1,$a2
lp:
	beq $t0,$a1,lp0	
	mult $t1,$a3
	mflo $t1
	sub $t0,$t0,1	
	beq $t0,$a0,lp0
	bne $t0,$a1 lp
lp0:		
	jr $ra
	
	.globl 	expfind2
expfind2:
	li $a0,0
	li $a1,1
	li $a2,10
	li $a3,10
	add $t3,$t3,$a2
lp01:
	beq $t2,$a1,lp1	
	mult $t3,$a3
	mflo $t3
	sub $t2,$t2,1	
	beq $t2,$a0,lp1
	bne $t2,$a1 lp01
lp1:		
	jr $ra
	
	.text
	.globl find_digit_number1
find_digit_number1:
	li $t8,10
	li $t7,0	
loop: 
	div $t0,$t8
	mflo $t0
	addi $t7,$t7,1	
	bne $t0, $zero loop
	jr $ra
	.text
	.globl print_zeromult
print_zeromult:

prntmult:	
	li $t8,0
	li $v0,4
	la $a0,p_zero
	syscall
	sub $t3,$t3,1
	bne $t8,$t3,prntmult
	jr $ra	
	
	.text
	.globl 	expfindsub
expfindsub:
	li $a0,0
	li $a1,1
	li $a2,10
	li $a3,10
	move $t6,$zero	
	add $t6,$t6,$a2	
lpsub:
	beq $t5,$a1,lopsub	
	mult $t6,$a3
	mflo $t6
	sub $t5,$t5,1	
	beq $t5,$a0,lopsub
	bne $t5,$a1 lpsub
lopsub:		
	jr $ra
		
	.text
	.globl print_zero
print_zero:

prnt:	
	li $t8,0
	li $v0,4
	la $a0,p_zero
	syscall
	sub $t3,$t3,1
	bne $t8,$t3,prnt
	jr $ra