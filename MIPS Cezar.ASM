.data
 plaintext: .asciiz "Wpisz tekst do zmiany: "
 data: .space 9
 Key: .asciiz "Podaj klucz:"
.text
main:
start:

text:
	# Read Plain text value
	la $a0,plaintext
	li $v0,4
	syscall
	la $a0,data
	la $a1,8  		# Czytamy maksymalnie 8 znakow
	li $v0,8
	syscall
	la $t0,($a0) 		# Wczytany string przechowuje w t0
	li $t1,0 		# dlugosc tekstu
	# Wczytanie klucza
	la $a0,Key
	li $v0,4
	syscall
	li $v0,5
	syscall
	move $t3,$v0 		# przechowuje klucz
 
Zakoduj:
	lb $t4, 0($t0)  	 	# Wczytuje pierwszy znak
	beq $t4,10,end 	 	# konczy program kiedy konczy sie tekst
	beqz $t4,end  			
	jal czymniejsze # sprawdzamy czy znak jest lowercase
Zakoduj2:
	beq $v0,1,ZakodujMale   	
	beq $v0,0,ZakodujDuze   	
	li $t4,32
 	move $a0, $t4   		# jesli znak nie jest ani duza litera ani mala wstawiam spacje

Wypisz:
 	li $v0,11 			# wypisz zakodowany znak
	syscall
	add $t0,$t0,1 			# nastepny znak
	add $t1,$t1,1 			# zwiekszam dlugosc
	bgt $t1,7,end 	
	j Zakoduj
  
end:
	li $v0,10
	syscall
 
czymniejsze:
	bgt $t4,122,NiemniejszeNiewieksze	 	# jesli znak nie jest maly ani duzy 
	blt $t4,97,Czywiekszeczycosinneg 		# jesli znak nie jest duzy
	li $v0,1   				# przechowuje 1 w V0 jesli litera mala
	jr $ra    	
 			# wracamy tam skad skoczylismy 
NiemniejszeNiewieksze:
	li $v0,2   				# przechowuje 2 w V0 kiedy znak nie jest duza litera ani mala
	j Zakoduj2  
  				# jump back
Czywiekszeczycosinneg:
	blt $t4,65,NiemniejszeNiewieksze	# jesli znak nie jest maly ani duzy 
	bgt $t4,91,NiemniejszeNiewieksze 		# jesli znak nie jest maly ani duzy 
	li $v0,0   				# przechowuje 0 w V0 kiedy litera jest duza
	j Zakoduj2
 
ZakodujMale:
	li $t5,26   				# Kodujemy male litery 
	sub $t4,$t4,97
	add $t4, $t4, $t3
	div $t4,$t5
	mfhi $a0
	addi $a0,$a0,97
	j Wypisz
 
ZakodujDuze:
	li $t5,26   				# Kodujemy duze litery
	sub $t4,$t4,65
	add $t4, $t4, $t3
	div $t4,$t5
	mfhi $a0
	addi $a0,$a0,97
	j Wypisz
 