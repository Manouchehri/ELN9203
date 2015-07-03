INCLUDE P16F877A_1.INC ;Removes the need to manually state the PORT equates's
__config 0x3F72 ;The config for the chip

;Set the GPR label equates (SRR are not required due to the include file)
BCD         EQU     23 ;To hold the BCD
parta       EQU     24 ;Used for time deay
partb       EQU     25
partc       EQU     26
store       EQU     22 ;To hold the state upon interrupt

; Set all the LED bits
INT_LED     EQU     5
INT_LED2    EQU     1

;Set the interrupt input and release
intin       EQU     0
intrel      EQU     4

;Set the interrupt flag
INTF        EQU     1

ORG 0x00 ;Set the beginning of the program

GOTO        Initialize

;Interrupt service routine

ORG 0x09 ;address to go to upon interrupt trigger

            MOVF    PORTB,W ;Move the current value into the register
            MOVWF   store ;Save it to a temporary register to recall later
            ;Removed the CLRF as clearing here doesn't seem to be needed

INTERRUPT   BSF     PORTA,INT_LED
            CALL    CLOCK
            BCF     PORTA,INT_LED
            CALL    CLOCK
            BSF     PORTA,INT_LED2 ;Extra LED for flip back and forth to
            CALL    CLOCK
            BCF     PORTA,INT_LED2
            BTFSC   PORTA,intrel ;Wait for interrupt release to go low
            GOTO    INTERRUPT
            MOVWF   PORTB
            BCF     INTCON,INTF ;Clear interrupt flag
            RETFIE  ;Reutrn from interrupt (seems to be awfully slow on these chips, unsure if physical properity or programming error)

Initialize  MOVLW   00 ;Set data direction
            TRIS    PORTB ;Load
            MOVLW   10
            TRIS    PORTA
            CLRF    PORTA ;Clear
            MOVLW   0D0 ;Set interrupt
            MOVWF   INTCON
            MOVLW   21 ;Set BCD storage
            MOVWF   BCD
            GOTO    MAIN

;Lookup table
SvenSeg     MOVF    BCD,W
            ADDWF   PCL
            NOP
            NOP
            RETLW   0DE
            CALL    CLOCK
            NOP
            RETLW   0DE
            CALL    CLOCK
            NOP
            RETLW   0FE
            CALL    CLOCK
            NOP
            RETLW   00E
            CALL    CLOCK
            NOP
            RETLW   0F8
            CALL    CLOCK
            NOP
            RETLW   0DA
            CALL    CLOCK
            NOP
            RETLW   0CC
            CALL    CLOCK
            NOP
            RETLW   09E
            CALL    CLOCK
            NOP
            RETLW   0B6
            CALL    CLOCK
            NOP
            RETLW   00C
            CALL    CLOCK
            NOP
            RETLW   07E
            CALL    CLOCK
            NOP

;Standard 1 second delay with a 20MHz delay clock
CLOCK       MOVLW   06D
            MOVWF   parta
            MOVLW   05E
            MOVWF   partb
            MOVLW   01A
            MOVWF   partc
DELAY       DECFSZ  parta,1
            GOTO    DELAY
            DECFSZ  partb,1
            GOTO    DELAY
            DECFSZ  partc,1
            GOTO    DELAY
            RETURN

;Main Program
MAIN        CALL    SvenSeg
            MOVWF   PORTB
            DECFSZ  BCD
            GOTO    MAIN
END