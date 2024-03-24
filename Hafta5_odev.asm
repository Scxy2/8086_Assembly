.MODEL SMALL 
.STACK 100H 
.DATA
DURUM1 DB "Lutfen string ifade girin:",'$' ; Kullanıcıdan giriş isteği
DURUM2 DB "Cumleyi ters cevirmeye gerek yok",'$' ; Ters çevirmeye gerek yok mesajı
STR1 DB 50 DUP ('$') ; Giriş cümlesi için bellek alanı
STR2 DB 50 DUP ('$') ; Ters çevrilmiş cümle için bellek alanı
.CODE 
MAIN PROC FAR 
MOV AX, @data
MOV DS, AX 

MOV AH, 09H 
MOV DX, OFFSET DURUM1
INT 21H ; "Lutfen string ifade girin:" mesajını yazdırma 

MOV DX, OFFSET STR1 
MOV AH, 0AH 
INT 21H ; string ifade alma 

MOV BL, 00H ; string uzunluğunu tutması için sıfırlama 
MOV SI, OFFSET STR1 
MOV SP, OFFSET STR2 

L1:  
MOV DL, [SI]      
CMP DL, '$'        
JE L6 ; string sonuna gelindiğinde işlemi sonlandırma
INC SI             
INC BL ; stringin uzunluğunu hesapla
JMP L1    

L6:
MOV SI, OFFSET STR1 ; SI e str1' in addresini atama 
MOV CH, [SI] ; CH'yi cümlenin uzunluğu ile ayarlama 
ADD CH, BL-1 ; stringin son indesksine gitme 

MOV BH, BL 
SUB BH, 1 ; BH'ı BL-1 değerini atama 

L2:
MOV CL, BH
MOV DL, [SI] 
CMP DL, 'N'        
JE L3 ; Eğer 'N' harfi varsa ters çevirme işlemine geç

CMP DL, '$'        
JE L4 ; Cümlenin sonuna gelindiğinde işlemi sonlandır

MOV AL, [SI]
MOV [SP], AL ; Cümleyi ters sırayla STR2'ye kopyala
DEC CH 
INC SP 
DEC SI 
LOOP L2 ; Tüm cümleyi kopyalayana kadar döngüyü tekrarla

L3: 
MOV AH, 09H 
MOV DX, OFFSET DURUM2
INT 21H ; "Ters çevirmeye gerek yok" mesajını yazdır

JMP L5 ; Programı sonlandır

L4: 
MOV AX, 4C00H
INT 21H ; Programı sonlandır

L5:
MOV AH, 09H 
MOV DX, OFFSET STR2
INT 21H ; Ters çevrilmiş cümleyi yazdır

MAIN ENDP 
END MAIN