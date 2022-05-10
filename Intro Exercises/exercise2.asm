.data
	array: .byte 0x70, 0x8C, 0xF3, 0x82, 0x1B, 0x9D, 0x52, 0x3C, 0x46 
	print_p: .asciiz "Enter p: "
	print_offset: .asciiz "Enter Offset: "
	print_nbits: .asciiz "Enter Nbits: "
.text
.globl main
	
main:
	la $s0, array		
	
	li $v0, 4
	la $a0, print_p
	syscall
	
	li $v0, 5		
	syscall
	move $s1, $v0		#---s1== Pointer
	
	add $s0,$s0, $s1	#---s0== deikths p
	
Elegxos_offset:
	li $v0, 4
	la $a0, print_offset
	syscall
	
	li $v0, 5
	syscall
	move $a1, $v0		#---a1== OFFSET
	
	bgt $a1, 7, Elegxos_offset
	bltz $a1, Elegxos_offset

Elegxos_nbits:	
	li $v0, 4
	la $a0, print_nbits
	syscall
	
	li $v0, 5
	syscall
	move $a2, $v0		#---a2==NBITS
	
	bgt $a2, 32, Elegxos_nbits
	bltz $a2, Elegxos_nbits
	
	move $a0, $s0
	
	jal bits_read
	
	move $a0, $s2		#--- ektypwnoyme to s2
    	li $v0, 35
     	syscall
	
	li $v0, 10
	syscall

bits_read:#####(px p=1, offset=5, Nbits=25)   a0== deikths p a1== OFFSET a2==NBITS
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	subi $t1, $a1, 8	#---t1==offset-8
	abs $t1, $t1		#--t1==|t1|                            (px 3)
	
	bgt $a2, $t1, L 	#a2>t1 jL
	
#an a2<t1 tote ta bits poy theloyme na diabasoyme briskontai ola se mia grammh
     	lbu $s2, 0($a0)		# s2= ta periexomena ths grammhs 
     	
	addi $t1, $a1, 24	#t1 = poso prepei na olisthhsoyme aristera to s2 t1= 24+Offset
	sllv $s2, $s2, $t1	
	
	subi $t2, $a2, 32	#t2 = poso prepei na olisthhsoyme deksia to s2 t2= 32-Nbits
	abs $t2, $t2		
	
	srlv $s2, $s2, $t2
	j exit
	
L:
	add $s1, $a0, $t0	# s1= exei th dieuthunsh ths prwths grammhs (t0==0)  
     	lbu $s2, 0($s1)		# s2= ta periexomena ths
     	
     	sub $a2, $a2, $t1	#Nbits=Nbits-t1 dhladh afairoume apo ta nbits ta bits ths prwths grammhs (px 22)
	srl $t2, $a2, 3 	#---t2==Nbits/8  ---poses grammes katw (px 2)
     	
     	subi $t3, $t1, 32	#t3==t1-32 bits einai poso theloume na olisthisoume to s2 gia na erthoune auta ta t1 bits sthn arxh tou kataxwrhth
	abs $t3, $t3		#|t3|                   (px 29)
	
	
     	
     	sllv $s2,$s2, $t3	#olisthenoume to s2 kata t3 bits aristera
     	srlv $s2,$s2, $t3	#olisthenoume to s2 kata t3 bits deksia
     	
     	addi $t0, $t0, 1 	#t0=t0+1 gia na pame sthn epomenh grammh
     	beqz $a2, exit		#an a2==0 exoyme diabasei ola ta bits ston s2
     	bgt $t0, $t2 exit_loop	# an t2==t0 ---> exit_loop opoy pernaei ta ypoloipa bits 
     	sll $s2,$s2, 8		#olisthenoume to s2 kata 8 bits aristera 
     	
loop:#pername sto s2 ta bits twn t2 oloklhrvn seirwn
	add $s1, $a0, $t0	# s1 = dieuthunsh ths t0 grammhs 
	lbu $s3, 0($s1)		# s3 = periexei ola ta bits ths s1
	
	or $s2, $s2, $s3	#prosthetoume to s3 sto s2
	
	addi $a2, $a2, -8	#afairoyme apo ta nbits ta bits poy exoyme perasei ston s2
	beqz $a2, exit		#an a2==0 exoyme diabasei ola ta bits ston s2
	addi $t0, $t0, 1	# t3= t3-1
	bgt $t0, $t2 exit_loop	# an t2==t0 ---> exit 
	sll $s2,$s2, 8		#olisthenoume to s2 kata 8 bits aristera 
	j loop
     	
exit_loop:
	add $s1, $a0, $t0	# s1 = dieuthunsh ths t0 grammhs 
	lbu $s3, 0($s1)		# s3 = periexei ola ta bits ths s1
	
	sllv $s2,$s2, $a2	#olisthenoume to s2 kata ta teleutaia a2 bits aristera
     	
     	subi $a2, $a2, 8	#a2==a2-8 bits	poso prepei na olisthhsoyme to se deksia
	abs $a2, $a2		#|a2|
     	
     	srlv $s3, $s3, $a2	#olisthhsh dexia kata a2 to s3
     	
     	or $s2, $s2, $s3	#prosthetoume kai thn teleutaia grammh  sto s2
exit:  	
     	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
