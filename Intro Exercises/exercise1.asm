.data
	String_name1: .asciiz "Enter number N1:"
	String_name2: .asciiz  "Enter number N2:"
	String_name3: .asciiz "The max final union of ranges is ["
	String_name4: .asciiz ","
	String_name5: .asciiz "]."
	String_name6: .asciiz "Iteration "
	enter:.asciiz "\n"

.text
.globl main 

main: 
	li $s0,0
loop: 	
	li $v0, 4
	la $a0, String_name6
	syscall
	move $a0, $s0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, enter
	syscall
	
	li $v0, 4
	la $a0, String_name1
	syscall
	li $v0, 5			# diavazei to N1
	syscall 			
	bltz $v0, exit			#N1<0 ---> EXIT
	move $t1, $v0           	#t1= N1 
	
	li $v0, 4
	la $a0, String_name2
	syscall
	li $v0, 5
	syscall				#DIAVAZEI TO N2
	move $t2, $v0
	beq $s0, $zero, start		# TSEKAREI AN EIMASTE STHN PRWTH EPANALHPSH
	
	bgt $s1, $t2, max4		#den uparxei epikalupsh --> max4 N1'> N2
	bgt $t1, $s2, max4		# "" "" "" N1> N2'
	
	bge $t1, $s1, max1		#AN TO N1>= N1' 
	#GIA N1<N1' 
	bge $t2, $s2, start 		#GIA N2>=N2'------> BAZOYME TIS TIMES TWN N STA N' t-------> s      PERIPTWSH 3.
	
	#GIA N2'>N2
	move $s1, $t1			#TO DIASTHMA EINAI [N1, N2'] ARA KANW MOVE TO N1' STO N1
	
	addi $s0, $s0, 1
	j loop
	
exit:	
	li $v0, 4
	la $a0, enter
	syscall
	
	li $v0, 4
	la $a0, String_name3
	syscall
	move $a0, $s1
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, String_name4
	syscall
	
	move $a0, $s2
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, String_name5
	syscall
	
	li $v0, 10
	syscall
	
start:  			#ARXIKOPOIHSH TWN N' ME TIS TIMES TWN N
	move $s1, $t1
	move $s2, $t2
	addi $s0, $s0, 1
	j loop
max4: 				#KRATAME TO MEGALUTERO DIASTHMA SE PERIPTWSH MH EPIKALUPSHS 
	sub $t3, $t2, $t1
	sub $s3, $s2, $s1
	bge $t3, $s3, label 
	addi $s0, $s0, 1
	j loop
label: 				#KANOYME TA N MOVE SE  N' 
	move $s2, $t2
	move $s1, $t1
	addi $s0, $s0, 1
	j loop
max1:
	bge $t2, $s2, max1A
	addi $s0, $s0, 1
	j loop 
max1A:
	move $s2, $t2
	addi $s0, $s0, 1
	j loop
