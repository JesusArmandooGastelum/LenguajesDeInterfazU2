; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 4. Saltos
; Descripción: Demuestra JMP, JE, JNE y los saltos con signo (JL) y sin signo (JA).

INCLUDE Irvine32.inc

; macro para no repetir tantas veces el codigo de imprimir un mesaje
imprimir MACRO texto
    mov edx, OFFSET texto
    call WriteString
    call Crlf
ENDM

.data
msgInicio   BYTE "Practica 4: Saltos",0
msgSaltado  BYTE "ESTE MENSAJE NO SE DEBE VER (se salta con JMP)",0
msgDespues  BYTE "JMP: se salto el mensaje de arriba",0
msgIguales  BYTE "JE: a y b son iguales",0
msgDifer    BYTE "JNE: a y b son diferentes",0
msgSigno    BYTE "Con signo: -5 es menor que 3 (salto JL)",0
msgNoSigno  BYTE "Sin signo: -5 es 0FFFFFFFBh y es mayor que 3 (salto JA)",0
msgFin      BYTE "Fin del programa",0

.code
main PROC
    imprimir msgInicio
    call Crlf

    ; ---- 1. salto incondicional ----
    jmp saltarMensaje       ; JMP siempre salta
    imprimir msgSaltado     ; esta linea nunca se ejecuta
saltarMensaje:
    imprimir msgDespues

    ; ---- 2. JE y JNE (usan la bandera ZF) ----
    mov eax, 7
    mov ebx, 7
    cmp eax, ebx
    je sonIguales           ; salta si ZF=1
    imprimir msgDifer
    jmp seguir1
sonIguales:
    imprimir msgIguales
seguir1:
    mov ebx, 9
    cmp eax, ebx
    jne sonDiferentes       ; salta si ZF=0
    imprimir msgIguales
    jmp seguir2
sonDiferentes:
    imprimir msgDifer
seguir2:

    ; ---- 3. comparacion con signo (JL) ----
    mov eax, -5
    cmp eax, 3
    jl esMenorConSigno
    jmp seguir3
esMenorConSigno:
    imprimir msgSigno
seguir3:

    ; ---- 4. comparacion sin signo (JA) ----
    ; el mismo -5 sin signo es un numero muy grande
    mov eax, -5
    cmp eax, 3
    ja esMayorSinSigno
    jmp seguir4
esMayorSinSigno:
    imprimir msgNoSigno
seguir4:

    imprimir msgFin
    exit
main ENDP
END main
