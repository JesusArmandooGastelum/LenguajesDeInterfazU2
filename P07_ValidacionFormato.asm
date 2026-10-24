; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 7. Validación de formato
; Descripción: Captura un codigo con formato LLL-DDDD (3 letras mayusculas, guion y 4 digitos) y revisa caracter por caracter si es valido.

INCLUDE Irvine32.inc

.data
msgPide     BYTE "Escribe un codigo con formato LLL-DDDD (ejemplo ABC-1234): ",0
msgValido   BYTE "Codigo VALIDO, el formato es correcto",0
msgInvalido BYTE "Codigo INVALIDO, intenta de nuevo",0
codigo      BYTE 21 DUP(0)      ; buffer de 20 caracteres + nulo

.code
main PROC
pedir:
    mov edx, OFFSET msgPide
    call WriteString
    mov edx, OFFSET codigo
    mov ecx, 20
    call ReadString         ; eax = longitud de lo que escribio

    ; ---- regla 1: debe medir exactamente 8 caracteres ----
    cmp eax, 8
    jne invalido

    ; ---- regla 2: las primeras 3 posiciones son letras mayusculas ----
    mov esi, 0              ; esi es el indice de la cadena
validarLetras:
    mov al, codigo[esi]     ; saco el caracter de la posicion esi
    cmp al, 'A'
    jb invalido             ; menor que 'A' no es letra
    cmp al, 'Z'
    ja invalido             ; mayor que 'Z' tampoco
    inc esi
    cmp esi, 3
    jb validarLetras        ; repite hasta llegar a la posicion 3

    ; ---- regla 3: en la posicion 3 debe ir un guion ----
    mov al, codigo[esi]
    cmp al, '-'
    jne invalido
    inc esi

    ; ---- regla 4: las ultimas 4 posiciones son digitos ----
validarDigitos:
    mov al, codigo[esi]
    cmp al, '0'
    jb invalido
    cmp al, '9'
    ja invalido
    inc esi
    cmp esi, 8
    jb validarDigitos

    ; si llego hasta aqui paso todas las reglas
    mov edx, OFFSET msgValido
    call WriteString
    call Crlf
    jmp fin

invalido:
    mov edx, OFFSET msgInvalido
    call WriteString
    call Crlf
    jmp pedir               ; vuelve a pedir el codigo

fin:
    exit
main ENDP
END main
