; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 13. Obtención de una cadena hexadecimal
; Descripción: Convierte un numero de 32 bits (12AB34CDh) a una cadena de 8 digitos hexadecimales tomando cada nibble con SHR y AND, convirtiendolo a caracter ASCII y guardandolo en un buffer para mostrarlo con WriteString.

INCLUDE Irvine32.inc

.data
    numero  DWORD 12AB34CDh         ; numero que se va a convertir
    msgHex  BYTE "El numero en hexadecimal es: ", 0
    buffer  BYTE 9 DUP(0)           ; 8 digitos hexadecimales + el nulo (00h)

.code
main PROC

    mov eax, numero                 ; eax tiene el numero a convertir
    mov esi, 0                      ; esi es la posicion del buffer, empieza en 0
    mov ecx, 8                      ; son 8 digitos (32 bits / 4 bits por digito)

L1:
    ; Desplazar para obtener el digito
    ; el digito de mayor valor son los 4 bits de arriba (bits 28 a 31)
    mov ebx, eax
    shr ebx, 28                     ; muevo los 4 bits de arriba hacia abajo
    and ebx, 0Fh                    ; mascara para dejar solo un nibble (0 a 15)

    ; Convertir a caracter hexadecimal
    cmp ebx, 9
    jbe decimal                     ; si es de 0 a 9 solo falta sumar '0'
    add ebx, 7                      ; de 10 a 15 se suma 7 para saltar a las letras A-F

decimal:
    add ebx, '0'                    ; paso el valor a su caracter ASCII

    ; Guardar el caracter
    mov buffer[esi], bl             ; guardo el caracter en el buffer

    ; Desplazar el siguiente digito
    shl eax, 4                      ; muevo el siguiente nibble hasta arriba

    inc esi                         ; siguiente posicion del buffer (de izquierda a derecha)
    loop L1                         ; repite 8 beses

    ; el ultimo byte del buffer ya es 00h por el DUP(0), asi que es una cadena valida
    mov edx, OFFSET msgHex
    call WriteString
    mov edx, OFFSET buffer
    call WriteString                ; muestra la cadena hexadecimal
    call Crlf

    exit
main ENDP
END main
