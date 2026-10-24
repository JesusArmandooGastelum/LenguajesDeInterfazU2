; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 6. Decremento e incremento
; Descripción: Muestra el uso de INC y DEC en ciclos y la diferencia con ADD/SUB respecto a la bandera CF.

INCLUDE Irvine32.inc

imprimir MACRO texto
    mov edx, OFFSET texto
    call WriteString
    call Crlf
ENDM

.data
msgInc      BYTE "Incremento con INC: ",0
msgDec      BYTE "Decremento con DEC: ",0
msgIncCF    BYTE "INC sobre 255 en AL: CF cambio a 1 (esto no deberia pasar)",0
msgIncCF0   BYTE "INC sobre 255 en AL: AL da 0 pero CF NO cambia (sigue en 0)",0
msgAddCF    BYTE "ADD 1 sobre 255 en AL: AL da 0 y CF = 1 (hubo acarreo)",0
msgAddCF0   BYTE "ADD 1 sobre 255 en AL: CF = 0 (no deberia pasar)",0
espacio     BYTE " ",0

.code
main PROC
    ; ---- incremento ----
    mov edx, OFFSET msgInc
    call WriteString
    mov ecx, 5
    mov eax, 0
cicloInc:
    inc eax                 ; eax = eax + 1
    call WriteDec
    mov edx, OFFSET espacio
    call WriteString
    loop cicloInc
    call Crlf

    ; ---- decremento ----
    mov edx, OFFSET msgDec
    call WriteString
    mov ecx, 5
    mov eax, 5
cicloDec:
    call WriteDec
    mov edx, OFFSET espacio
    call WriteString
    dec eax                 ; eax = eax - 1
    loop cicloDec
    call Crlf
    call Crlf

    ; ---- INC no modifica CF ----
    clc                     ; pongo CF en cero
    mov al, 255
    inc al                  ; al pasa a 0 pero CF se queda igual
    jc incCambioCF
    imprimir msgIncCF0
    jmp probarAdd
incCambioCF:
    imprimir msgIncCF

probarAdd:
    ; ---- ADD si modifica CF ----
    clc
    mov al, 255
    add al, 1               ; aqui si hay acarreo y CF se pone en 1
    jc addCambioCF
    imprimir msgAddCF0
    jmp fin
addCambioCF:
    imprimir msgAddCF
fin:
    exit
main ENDP
END main
