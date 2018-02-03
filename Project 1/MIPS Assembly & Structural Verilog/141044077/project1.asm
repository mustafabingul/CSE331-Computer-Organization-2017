		
		
	.data
comma: .asciiz "."
nl:		.asciiz "\n"
p_zero: .asciiz "0"
str: .asciiz "Wrong Operator..!"
mine: .asciiz "-"


	.globl main
	.text
main:
	
	# Get input 1/1
	li	$v0,5			# read_int syscall code
	syscall	
	move	$s0,$v0		# syscall results returned in $v0
	# Get input 1/2
	li	$v0,5			# read_int syscall code
	syscall	
	move	$s1,$v0		# syscall results returned in $v0	
	
	# Get charachter
	li $v0,12			#character read.
	syscall
	move $a3,$v0 	#characterr
		
	# Get input 2/1
	li $v0,5
	syscall
	move $s2,$v0 		#2/1
	
	# Get input 2/2
	li $v0,5
	syscall
	move $s3,$v0			#2/2
	
	beq $a3,'*',multiplication
	beq $a3,'+',summation
	beq $a3,'-',subtraction
	j the_end_message	
	
multiplication:
	move $t0,$s1				#digit sayilari(1/2)			
	jal find_digit_number1		
	move $s4,$t7	
	
	move $t0,$s3	
	jal find_digit_number1
	move $s5,$t7				#digit sayilari(2/2)	
	
	move $t0,$s4				#(1/2) fractional kisminin 10'n (1/1) ile carpilir ve (1/2) ile toplanir.(say? butunlesir) 
	jal expfind
	mult $t1,$s0
	mflo $t1
	add $t9,$s1,$t1
	move $s0,$t9				#butun sayi s0 alinir.
	
	move $t2,$s5				#(2/2) fractional kisminin 10'n (2/1) ile carpilir ve (2/2) ile toplanir.(say? butunlesir) 
	jal expfind2
	mult $t3,$s2
	mflo $t3
	add $t8,$t3,$s3
	move $s2,$t8				#butun sayi s2 alinir.
	
	mult $s0,$s2				#butun sayilar carpilir.
	mflo $t1					#sonuc alinir.
	move $s7,$t1				#sonuc s7'de.
	
	move $t0,$s4				#sonuc icin fractional kisimlarin digit degerleri toplanir.
	move $t1,$s5
	add $t2,$t0,$t1
	move $s6,$t2				#(1/2)+(2/2)
	
	move $t5,$s6				#fractional kisimlarin digit sayilarinin toplam? (10'n)
	jal expfind3
	move $t9,$t6				#10^n
	
	div $s7,$t9				#sonuc bolunur
	mfhi $t8					#bolumden kalan kisim
	move $t6,$t8
	mflo $t7					#sonucun bolum
	move $t5,$t7
	
	 li $v0,1
	 move $a0,$t5			#sonucun ondalik kismi
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
	move $a0,$t6			#sonucun fractional kismi
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
	slt $a0,$s4,$s5		#digit basamaklarý karsýlastýrýlýr.
	beq $a0,$a1,e1
	move $t9,$s4
	j e2
e1:	move $t9,$s5	
	j goon
e2:
	sub $t9,$s4,$s5		#ilk sayýnýn fractional kýsmý digit sayýsý fazla.
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
	sub $t9,$s5,$s4		#ikinci sayýnýn fractional kýsmýnýnda digit sayýsý fazla.
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
	sub $t9,$s6,$s7		#iki butunlesmis sayýda cýkarýlýr.
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
	move $t5,$s5			#iki sayýnýnda fractionala kýsýmlarýnýn digit sayýlarý esit.
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
	move $s4,$t7				# s4 -- 1/2 digiti
	
	move $t0,$s3	
	jal find_digit_number1
	move $s5,$t7			#s5 -- 2/2 digiti
	
	beq $s1,$zero,zerotopla
	beq $s3,$zero,zerotopla
	beq $s4,$s5,eq
	
	li $a0,0
	li $a1,1
	slt $a0,$s4,$s5	#(1/2) digit sayýsý buyuk
	beq $a0,$a1,b1
	move $t9,$s4
	j b2
b1:	move $t9,$s5	
	j gooon
b2:					
	sub $t9,$s4,$s5		#(2/2)-(1/2) digit sayýlarý farký.
	move $t5,$t9			#digit farký
	jal expfindsub
	mult $s3,$t6			#ikinci sayýnýn fractional kýsmý tamlanýr.
	mflo $t8
	move $s6,$t8			#tamlanmýþ kýsmý s6 da.
	move $t0,$s6
	jal find_digit_number1
	move $t5,$t7			
	jal expfindsub
	mult $t6,$s2			#10^n ile ikinci sayýnýn ilk kýsmý çarpýlýr, toplanmak için.
	mflo $t5
	add $t5,$t5,$s6		#sayý butunleþir.
	move $s6,$t5			#1200
	move $t5,$s4			#ilk sayý için tamlama baþlar.
	jal expfindsub
	mult $t6,$s0			#(1/1)*10^n çarpýlýr.
	mflo $t5
	add $t5,$t5,$s1		#sayý butunlesir.
	move $s7,$t5			#sayý s7 de.(butun)
	add $t9,$s7,$s6		#ilk kýsým fracional kýsmý toplandý.
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
	sub $t9,$s5,$s4 		#(1/2)-(2/2) digit sayýlarý farký
	move $t5,$t9			
	jal expfindsub		#digit sayýlarý farký 10 üzeri bulunur.
	mult $s1,$t6			#10^n*(1/2)
	mflo $t8				#(1/2)
	move $s6,$t8			#(1/2)
	move $t0,$s6
	jal find_digit_number1		#(1/2) tamlanmýs, digit sayýsý
	move $t5,$t7				#(1/2) tamlanmýs, digit sayýsý
	jal expfindsub			#(1/2) tamlanmýs, digit sayýsý 10^n li sekilide
	mult $t6,$s0				#10^n*s0
	mflo $t5					
	add $t5,$t5,$s6			#ilk sayýyý butunlestir.
	move $s6,$t5				#ilk sayý butunlesti.
	move $t0,$s3				#(2/2) digit sayýsýný bul.
	jal find_digit_number1
	move $t5,$t7				
	jal expfindsub
	mult $s2,$t6				#1000*11
	mflo $t7					#11000
	add $s7,$t7,$s3			#ikinci sayý butunlesti.	
	add $t9,$s6,$s7			#sayýlar toplandý.
	div $t9,$t6				#fractionan kýsmýn digit sayýsý buyuk olana göre bölünür.
	mflo $t0					#sonucun ilki
	mfhi $t1					#sonucun ikinci kýsmý
			
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,comma
	syscall
	move $t0,$t1				#istisna 0 durumlarý için sýfýr basma.
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
	move $t5,$s5 		#(1/2)=(2/2) digit sayýlarý esit
	jal expfindsub
	mult $s0,$t6
	mflo $t8
	add $s6,$t8,$s1		#sayý tamlanýr.
	mult $s2,$t6
	mflo $t8
	add $s7,$t8,$s3		#dier sayý tamlanýr
	add $t9,$s6,$s7		#sayý toplanýr.
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
	
	######### subroutinler.

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