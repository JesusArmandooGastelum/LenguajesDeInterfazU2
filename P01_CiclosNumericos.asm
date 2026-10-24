; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 1. Ciclos numéricos
; Descripción: Muestra los numeros del 1 al 10 y calcula su suma usando la instruccion LOOP con ECX como contador.

INCLUDE Irvine32.inc

.data
msgTitulo   BYTE "Practica 1: Ciclos numericos",0
msgCiclo    BYTE "Numeros del 1 al 10: ",0
msgSuma     BYTE "La suma de los numeros del 1 al 10 es: ",0
espacio     BYTE " ",0

.code
main PROC
    mov edx, OFFSET msgTitulo
    call WriteString
    call Crlf
    call Crlf

    ; --- primer ciclo: mostrar los numeros ---
    mov edx, OFFSET msgCiclo
    call WriteString
    mov ecx, 10             ; ecx es el contador del loop, se repite 10 beses
    mov eax, 1              ; eax empieza en 1
cicloMostrar:
    call WriteDec           ; muestra el numero que esta en eax
    mov edx, OFFSET espacio
    call WriteString
    inc eax                 ; le sumo uno al numero
    loop cicloMostrar       ; loop le resta 1 a ecx y salta si no es zero
    call Crlf

    ; --- segundo ciclo: sumar del 1 al 10 ---
    mov edx, OFFSET msgSuma
    call WriteString
    mov ecx, 10
    mov eax, 0              ; aqui se va acumulando la suma
    mov ebx, 1              ; ebx es el numero que se suma
cicloSuma:
    add eax, ebx
    inc ebx
    loop cicloSuma
    call WriteDec           ; el resultdo debe ser 55
    call Crlf

    exit
main ENDP
END main
