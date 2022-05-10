.data
	str: .space 20
	msg: .asciiz "Enter string: "
.text
.globl main

main:
	li $v0,4
	la $a0,msg		#ektupwsh mhnumatos
	syscall
	
	li $v0, 8
	la $a0, str
	li $a1, 20
	syscall			#diavazei to str sto a0
	
	li $a2, 0
strlen:	
	add $t1, $a2, $a0
	lb $t2, 0($t1)
	beq $t2, $zero, continue	
	addi $a2, $a2, 1
	j strlen		#a2=strlen+1 (+1=\n) 
continue:
	addi $a2, $a2, -1	#to str exei megethos a2-1 (\n) kai kaloume thn synarthsh gia a2=N
				#a2=strlen	
	li $a1, 0		#a1=i=0
	jal transposition
	
	li $v0, 10
	syscall
	
transposition:
	beq $t0, 1, continue1	#an einai h prvth fora poy kaloyme th synarthsh $t0=0 alliws $t0=1 
	addi $a2, $a2, -1	#a2=a2-1= n-1
continue1:
	li $t0, 1		##s0=1
	beq $a1, $a2, print	#if l>=r print->jr
	addi $sp, $sp, -16	#kanoume xwro sth stoiba gia 4s kataxvrhtes
	sw $ra, 0($sp)		#apo8hkeuoume to ra
	sw $s0, 4($sp)		#    -//-   to s0
	sw $a1, 8($sp)		#    -//-   to a1
	sw $a0, 12($sp)		#    -//-   to a0
	
	lw $s0, 8($sp)		#$s0=$a1 fortwnoume thn timh ths 8($sp) ths stoibas=$a1  sto $s0
	sw $s0, 4($sp)		#apo8hkeuoume to kainourio $s0 sth thesh tou $s0
	
loop:
	bgt $s0,$a2,exit	#if i>r exit apo to loop 
###-----swap
	add $t1, $s0, $a0	
	lb $t2, ($t1)		#t2=str[i]
	add $s1, $a1, $a0	
	lb $s2, ($s1)		#s2=str[l]
	sb $t2, ($s1)		#str[l]=t2
	sb $s2, ($t1)		#str[i]=s2
#--------
	addi $a1, $a1, 1	#$a1=$a1+1
	
	jal transposition	#(char *str, int i, int r)
	
	lw $a0, 12($sp)		
	lw $a1, 8($sp)		
	lw $s0, 4($sp)		
	
###-----swap	wste na gyrisoyme sthn arxikh katastash	
	add $t1, $s0, $a0	#t1= exei th dieuthunsh tou stoixiou sth thesh s0 tou str
	lb $t2, ($t1)		
	add $s1, $a1, $a0	#s1= exei th dieuthunsh tou stoixiou sth thesh a1 tou str
	lb $s2, ($s1)		
	sb $t2, ($s1)		
	sb $s2, ($t1)		
#--------
	addi $s0, $s0, 1	#i++
	sw $a0, 12($sp)		#apo8hkeuoume th nea timh tou a0 sth stoiba
	sw $s0, 4($sp)		#	-//-	    -//-   tou s0 sth stoiba
	j loop			
print:
	li $v0, 4		
	syscall			#print a0

	jr $ra
exit:
	lw $ra, 0($sp)		#fortwnoume to ra apo th mnhmh
	addi $sp, $sp, 16	#adiazoume ton xwro pou kanamesth stoiba
	jr $ra