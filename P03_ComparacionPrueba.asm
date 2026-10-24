; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 3. Comparación y prueba
; Descripción: Usa CMP para comparar un numero con 10 y TEST para saber si es par o impar.

INCLUDE Irvine32.inc

.data
msgPide     BYTE "Escribe un numero entero: ",0
msgMayor    BYTE "CMP: el numero es mayor que 10",0
msgMenor    BYTE "CMP: el numero es menor que 10",0
msgIgual    BYTE "CMP: el numero es igual a 10",0
msgPar      BYTE "TEST: el numero es par (el bit 0 vale cero)",0
msgImpar    BYTE "TEST: el numero es impar (el bit 0 vale uno)",0
numero      SDWORD ?

.code
main PROC
    mov edx, OFFSET msgPide
    call WriteString
    call ReadInt            ; el numero queda en eax
    mov numero, eax

    ; ---- comparacion con CMP ----
    ; cmp hace una resta pero no guarda el resultdo, solo cambia las banderas
    cmp eax, 10
    jg esMayor
    jl esMenor
    mov edx, OFFSET msgIgual
    jmp mostrar1
esMayor:
    mov edx, OFFSET msgMayor
    jmp mostrar1
esMenor:
    mov edx, OFFSET msgMenor
mostrar1:
    call WriteString
    call Crlf

    ; ---- prueba con TEST ----
    ; test hace un AND sin guardar el resultado, aqui reviso el bit 0
    mov eax, numero
    test eax, 1
    jz esPar                ; si el AND dio cero entonces es par
    mov edx, OFFSET msgImpar
    jmp mostrar2
esPar:
    mov edx, OFFSET msgPar
mostrar2:
    call WriteString
    call Crlf

    exit
main ENDP
END main
