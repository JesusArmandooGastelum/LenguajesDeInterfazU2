; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 5.1. Repetir hasta que el usuario ingrese cero
; Descripción: Pide numeros al usuario una y otra vez hasta que escriba cero, y al final muestra cuantos escribio y la suma.

INCLUDE Irvine32.inc

.data
msgPide     BYTE "Escribe un numero (0 para terminar): ",0
msgCant     BYTE "Cantidad de numeros capturados (sin contar el cero): ",0
msgTotal    BYTE "Suma total de los numeros: ",0
suma        SDWORD 0
cantidad    DWORD 0

.code
main PROC
inicio:
    mov edx, OFFSET msgPide
    call WriteString
    call ReadInt            ; numero en eax
    cmp eax, 0
    je terminar             ; si escribio cero se acaba el ciclo
    add suma, eax           ; acumulo la suma
    inc cantidad            ; cuento un numero mas
    jmp inicio              ; vuelve a pedir otro

terminar:
    call Crlf
    mov edx, OFFSET msgCant
    call WriteString
    mov eax, cantidad
    call WriteDec
    call Crlf

    mov edx, OFFSET msgTotal
    call WriteString
    mov eax, suma
    call WriteInt           ; WriteInt por que la suma puede ser negativa
    call Crlf

    exit
main ENDP
END main
