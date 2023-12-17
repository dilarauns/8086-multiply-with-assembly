ORG 100
#start=led_display.exe#


#make_bin#

name "led"  



#start=simple.exe#

#make_bin#

name "simple"

start:
        
MOV WORD PTR [0100h], 0005h  ; carpanin alt 16 biti
MOV WORD PTR [0102h], 0000h  ; carpanin ust 16 biti
MOV WORD PTR [0104h], 0008h  ; carpilanin alt 16 biti
MOV WORD PTR [0106h], 0000h  ; carpilanin ust 16 biti

MOV WORD PTR [0110h], 0000h  ; carpim icin ayrilan 16 bitlik 64 bit bellek adresleri
MOV WORD PTR [0112h], 0000h 
MOV WORD PTR [0114h], 0000h  
MOV WORD PTR [0116h], 0000h 

SUB AX, AX
SUB BX, BX
SUB CX, CX
SUB DX, DX
SUB SI, SI
SUB DI, DI

MOV SI, 20h       ; 32 kez dongu donecek      

tekrar:

MOV BX, [0100h]  ; carpanin ilk 16 biti bx degerinde
AND BX, 01h       ; LSB biti haricindaki bitler sifirlanacak
XOR BX, 01h       ; carpanin en anlamsiz biti 1 mi sorgusu saglanacak
JZ topla_kaydir   ; 1 ise carpim sonucu carpilan ile toplanacak ve bir bit saga kaydir
CLC             

devam:
      ; carpim sonucu 1 bit saga kaydirma islemleri 64 bitlik sonuc icin 4 tane 16 bitlik ifade uzerinde kaydirma islemini yapacagiz
MOV AX, [0116h]
RCR AX, 1        ; ust 16 bit saga kaydirilir
MOV [0116h], AX
MOV BX, [0114h]      
RCR BX, 1        
MOV [0114h], BX
MOV CX, [0112h]
RCR CX, 1        
MOV [0112h], CX	
MOV DX, [0110h]
RCR DX, 1        ; alt 16 bit saga kaydirilir
MOV [0110h], DX	  
MOV AX, [0102h]
SHR AX, 1        ; carpan bir bit saga kaydirilir
MOV [0102h], AX 
MOV BX, [0100h]
RCR BX, 1       ; burada carry kullanilarak alt 16 bitlik carpan ifadesi saga dondurulmustur
MOV [0100h], BX  ; carry kullanilmasinin sebebi ax ile baglantili 32 bitlik bir sayi olmasi

DEC SI           ; dongu degiskeni azaltilir
CMP SI, 0       ;	
JNZ tekrar      ; dongu degiskeni degeri 0 degilse tekrar bolumune donulur
JMP ekranaNeYazilsin          ; 0 ise son bolumune gelinir 

topla_kaydir: 

MOV AX, [0104h]  ; AX(ust 16 bit) = carpilanin alt 16 biti
ADD [0114h], AX  ; carpilanin 48-32 biti ile toplanir
ADC [0116h], 0   ; carry ile toplama islemi yapilir
MOV AX, [0106h]  ; AX = carpilanin ust 16 biti
ADC [0116h], AX  ; carpimin ust 16 biti ile toplanir burada elde durumunu kacirmamak icin carry ile islem yapilir
JMP devam





ekranaNeYazilsin:  
    
      XOR AX, AX  ;ax registerini sifirliyoruz 
      IN AL, 110  ; kullanicidan gelen degeri AL ye kaydediyoruz
      CMP AL,1h   ; eger girilen deger 1 ise alt 16 bitin yazilmasi icin
      JZ AltBit   ;bu fonksiyona gidiyoruz
      CMP AL, 4h  ; Eger giris 4'e esitse
      JZ ustBit   ; ustBit etiketine atla
      CMP AL, 2h
      JZ orta1  
      CMP AL, 3h
      JZ orta2



AltBit:    
    MOV AX, [0110h]  ; AL'e alt 16 bitin bulundugu adresdeki degeri kopyala
    OUT 199, AX      ; led displaye yazdir    
    hlt  ;bu bolume girmis ise bitir
    
ustBit:
    MOV AX, [0116h]  ; AL'e ust 16 bitin bulundugu adresdeki degeri kopyala
    OUT 199, AX      ; LED displaye yazdir
    hlt ;bu bolume girmis ise bitir    
    
orta1:
         MOV AX, [0112h]  ; AL'e  16-32 bitin bulundugu adresdeki degeri kopyala
    OUT 199, AX      ; led displaye yazdir    
    hlt  ;bu bolume girmis ise bitir  
    
orta2:
    MOV AX, [0114h]  ; AL'e  48-32 bitin bulundugu adresdeki degeri kopyala
    OUT 199, AX      ; led displaye yazdir    
    hlt  ;bu bolume girmis ise bitir