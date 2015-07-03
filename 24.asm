; David Manouchehri - 2013-10-12
; #include "p16F877A.inc"

; CONFIG
;__config 0xFF77
__config 0x3F72

;Settings

ORG 0x00
;INCLUDE P16F877A_1.INC

STATUS  EQU 03
PORTB   EQU 06
TRISB   EQU 86

parta   EQU 21
partb   EQU 22
partc   EQU 23

BANK1   EQU 5 ;Former values
Line1   EQU 1 ;Line1
Line2   EQU 5 ;Line3
Line3   EQU 7 ;Line4
Line4   EQU 3 ;Line2

GOTO START

;Init

START   MOVLW   1F
        ANDWF   STATUS
        BSF     STATUS,BANK1
        MOVLW   B'00000000'
        MOVWF   TRISB
        MOVWF   1F
        MOVLW   07
        BCF     STATUS,BANK1
        MOVWF   1F
        GOTO    MAIN

; 20 MHz delay clock, 1 second delay
CLOCK   MOVLW   06A
        MOVWF   parta
        MOVLW   05A
        MOVWF   partb
        MOVLW   01A
        MOVWF   partc
DELAY   DECFSZ  parta,1
        GOTO    DELAY
        DECFSZ  partb,1
        GOTO    DELAY
        DECFSZ  partc,1
        GOTO    DELAY
        RETURN

;MAIN

;MAIN    BCF     PORTB,Line3 -> Step one
;        BSF     PORTB,Line1 -> Set
;        CALL    CLOCK
;        BCF     PORTB,Line1 -> Step two
;        BSF     PORTB,Line4 -> Set
;        CALL    CLOCK
;        BCF     PORTB,Line4 -> Step three
;        BSF     PORTB,Line2 -> Set
;        CALL    CLOCK
;        BCF     PORTB,Line2 -> Step four
;        BSF     PORTB,Line3 -> Set
;        CALL    CLOCK
;        GOTO MAIN

; Line1 = REALLine1
; Line4 = REALLine2
; Line2 = REALline3
; Line3 = REALline4

MAIN		BCF	PORTB,Line1
		BSF	PORTB,Line2
		CALL	CLOCK
		BCF	PORTB,Line3
		BSF	PORTB,Line4
		CALL	CLOCK
		BCF	PORTB,Line2
		BSF	PORTB,Line1
		CALL	CLOCK
		BCF	PORTB,Line4
		BSF	PORTB,Line3
		CALL	CLOCK
		GOTO	MAIN

END