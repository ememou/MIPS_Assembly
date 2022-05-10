.data
	str: .space 20
	print0: .asciiz "Return 0"
	print1: .asciiz "Return 1 ----> X="
	msg1: .asciiz "Enter string: "
	m: .asciiz "\n"
.text 
.globl main

main:
	li $v0,4
	la $a0,msg1        #ektupwsh mhnumatos
	syscall
	
	li $v0,8
	la $a0, str         
	li $a1, 20
	syscall		# diavazei to str sto a0
	
	jal symmString
	
	beq $v0, 0, Print_return0  #epistrefei 0
	beq $v0, 1, Print_return1  #an v0=1 jump sto print1
	
Print_return0:	
	li $v0, 4
	la $a0, print0  
	syscall
	j Exit
Print_return1:	
	li $v0, 4
	la $a0, print1
	syscall
############# ektupwsh string 
	move $a0, $a1
	li $v0, 4
	syscall
Exit:
	li $v0, 10
	syscall


symmString:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	li $s0, 0
strlen:
	add $t1, $s0, $a0		
	lb $t2, 0($t1)
	beq $t2, $zero, L		
	addi $s0, $s0, 1		#to s0 periexei to megethos tou str
	j strlen
L:
#to s0 periexei +1 char (logika to \n) ara an s0mod2!=0 tote oi xarakthres toy s0 tha einai artioi

	srl $t3, $s0, 1			#to t3== s0/2 exei thn mesh
	sll $t4, $t3, 1			# t4== t3*2 gia na elejoyme an einai artio to str
	sub $t4, $s0, $t4		#t4=s0-t4
	beqz $t4, exit0			#an t4==0 tote oi xarakthres einai perittoi ara exit0
	
	move $t6, $t3			#to t6 periexei thn mesh tou string (ws arithmo) 
	move $t4, $s0			#to t4 exei to megethos
	li $s0, 0
	li $t1, 0
	li $t2, 0
	
loop: #a1 einai dieuthinsh enos string x , s0 einai to i kai t3 einai to j
	add $t1, $s0, $a0	#t1 dieuthinsi tou x[i]
	lb $t2, 0($t1)		#t2=x[i]
	
	add $s1, $t3, $a0	#t1 dieuthinsi tou x[j]
	lb $s2, 0($s1)		#t2=x[j]
	
	slt $t5,$t2,$s2  	#sugkrish t2,s2 an einai idia t5==0 
	bnez $t5,exit0		#an t5!=0 ------> exit0 dhladh an  t2!=s2 
	
	addi $s0, $s0, 1	#i=i+1
	addi $t3, $t3, 1	#j=j+1
	beq $t3, $t4 exit1	#an t3==t4--> exit1 (t4 einai to megethos tou str)
	j loop
exit1:
	add $s3, $a0, $t6	#to s3 periexei thn diefthinsi ths epomenhs meta thn mesh tou str
	sb $zero, 0($s3)	#write 0 sto s3
	move $a1, $a0	
	li  $v0, 1		#epistrefei 1
	j exit

exit0:
	move $v0, $0		#epistefei 0
exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
