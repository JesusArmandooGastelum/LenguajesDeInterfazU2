; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 4.1. Mayor, menor o igual con entrada del usuario
; Descripción: Captura dos numeros enteros y dice si el primero es mayor, menor o igual al segundo usando CMP y saltos condicionales.

INCLUDE Irvine32.inc

.data
msgNum1     BYTE "Escribe el primer numero: ",0
msgNum2     BYTE "Escribe el segundo numero: ",0
msgMayor    BYTE "El primer numero es MAYOR que el segundo",0
msgMenor    BYTE "El primer numero es MENOR que el segundo",0
msgIgual    BYTE "Los dos numeros son IGUALES",0
num1        SDWORD ?
num2        SDWORD ?

.code
main PROC
    ; pedimos los dos numeros
    mov edx, OFFSET msgNum1
    call WriteString
    call ReadInt
    mov num1, eax

    mov edx, OFFSET msgNum2
    call WriteString
    call ReadInt
    mov num2, eax

    ; comparamos num1 con num2 (numeros con signo)
    mov eax, num1
    cmp eax, num2
    jg primeroMayor         ; salta si num1 > num2
    jl primeroMenor         ; salta si num1 < num2
    ; si no salto es porque son iguales
    mov edx, OFFSET msgIgual
    jmp mostrar

primeroMayor:
    mov edx, OFFSET msgMayor
    jmp mostrar

primeroMenor:
    mov edx, OFFSET msgMenor

mostrar:
    call WriteString
    call Crlf

    exit
main ENDP
END main
