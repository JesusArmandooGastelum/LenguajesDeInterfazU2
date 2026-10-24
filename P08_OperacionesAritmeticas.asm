; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 8. Operaciones aritméticas
; Descripción: Pide dos numeros enteros y calcula suma, resta, multiplicacion, division y residuo con ADD, SUB, IMUL e IDIV.

INCLUDE Irvine32.inc

.data
msgNum1     BYTE "Escribe el primer numero: ",0
msgNum2     BYTE "Escribe el segundo numero: ",0
msgSuma     BYTE "Suma (ADD): ",0
msgResta    BYTE "Resta (SUB): ",0
msgMult     BYTE "Multiplicacion (IMUL): ",0
msgCoc      BYTE "Cociente (IDIV): ",0
msgRes      BYTE "Residuo (IDIV): ",0
msgCero     BYTE "No se puede dividir entre cero",0
msgDesb     BYTE "Cuidado, hubo desbordamiento en la suma (OF=1)",0
num1        SDWORD ?
num2        SDWORD ?

.code
main PROC
    mov edx, OFFSET msgNum1
    call WriteString
    call ReadInt
    mov num1, eax

    mov edx, OFFSET msgNum2
    call WriteString
    call ReadInt
    mov num2, eax
    call Crlf

    ; ---- suma ----
    mov edx, OFFSET msgSuma
    call WriteString
    mov eax, num1
    add eax, num2           ; eax = num1 + num2
    jno sumaBien            ; si OF=0 no hubo problema
    mov edx, OFFSET msgDesb
    call WriteString
    call Crlf
    jmp resta
sumaBien:
    call WriteInt
    call Crlf

resta:
    ; ---- resta ----
    mov edx, OFFSET msgResta
    call WriteString
    mov eax, num1
    sub eax, num2           ; eax = num1 - num2
    call WriteInt
    call Crlf

    ; ---- multiplicacion con signo ----
    mov edx, OFFSET msgMult
    call WriteString
    mov eax, num1
    imul eax, num2          ; eax = num1 * num2
    call WriteInt
    call Crlf

    ; ---- division con signo ----
    cmp num2, 0
    je divisionCero
    mov edx, OFFSET msgCoc
    call WriteString
    mov eax, num1
    cdq                     ; extiende el signo de eax hacia edx (edx:eax)
    idiv num2               ; cociente en eax, residuo en edx
    push edx                ; guardo el residuo por que WriteString usa edx
    call WriteInt
    call Crlf
    mov edx, OFFSET msgRes
    call WriteString
    pop eax                 ; recupero el residuo
    call WriteInt
    call Crlf
    jmp fin

divisionCero:
    mov edx, OFFSET msgCero
    call WriteString
    call Crlf
fin:
    exit
main ENDP
END main
