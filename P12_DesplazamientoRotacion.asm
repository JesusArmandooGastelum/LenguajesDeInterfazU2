; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 12. Desplazamiento y rotación
; Descripción: Prueba las instrucciones de desplazamiento (SHL, SHR, SAR) y de rotacion (ROL, ROR, RCL, RCR) sobre el registro AL, mostrando el resultado en binario con WriteBin y los registros con DumpRegs.

INCLUDE Irvine32.inc

.data
msg1    BYTE "1. SHL: desplazar un bit a la izquierda", 0
msg2    BYTE "2. SHR: desplazar un bit a la derecha", 0
msg3    BYTE "3. SAR: desplazamiento con signo (-8)", 0
msg4    BYTE "4. SAR: desplazamiento con signo impar (-9)", 0
msg5    BYTE "5. SHL con conteo constante (2 posiciones)", 0
msg6a   BYTE "6. SHL con conteo en CL (CL = 2)", 0
msg6b   BYTE "6. SHR con conteo en CL (CL = 2)", 0
msg7a   BYTE "7. ROL: rotar a la izquierda", 0
msg7b   BYTE "7. ROR: rotar a la derecha", 0
msg7c   BYTE "7. RCL: rotar a la izquierda con acarreo (CF = 0)", 0
msg7d   BYTE "7. RCR: rotar a la derecha con acarreo (CF = 0)", 0

.code
main PROC
    mov eax, 0                  ; limpio eax completo para que WriteBin muestre solo al
    mov ebx, TYPE BYTE          ; WriteBin necesita el tamaño en ebx (1 byte)

    ; ---------- 1. SHL: desplazar un bit a la izquierda ----------
    mov edx, OFFSET msg1
    call WriteString
    call Crlf
    mov al, 10000110b
    shl al, 1                   ; entra un cero por la derecha, el bit 7 se va a CF
                                ; resultado = 0000 1100
    call DumpRegs               ; muestra todos los registros y las banderas
    call WriteBin               ; muestra al en binario
    call Crlf
    call Crlf

    ; ---------- 2. SHR: desplazar un bit a la derecha ----------
    mov edx, OFFSET msg2
    call WriteString
    call Crlf
    mov al, 00001101b
    shr al, 1                   ; entra un cero por la izquierda, el bit 0 se va a CF
                                ; resultado = 0000 0110
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    ; ---------- 3. SAR: desplazamiento con signo ----------
    mov edx, OFFSET msg3
    call WriteString
    call Crlf
    mov eax, 0
    mov al, -8                  ; -8 = 1111 1000
    sar al, 1                   ; SAR copia el bit de signo, resultado = 1111 1100 (-4)
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    ; ---------- 4. SAR: desplazamiento con signo impar ----------
    mov edx, OFFSET msg4
    call WriteString
    call Crlf
    mov eax, 0
    mov al, -9                  ; -9 = 1111 0111
    sar al, 1                   ; resultado = 1111 1011 (-5), redondea hacia abajo
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    ; ---------- 5. Conteo constante: desplazar 2 posiciones ----------
    mov edx, OFFSET msg5
    call WriteString
    call Crlf
    mov eax, 0
    mov al, 00001100b
    shl al, 2                   ; es lo mismo que multiplicar por 4
                                ; resultado = 0011 0000
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    ; ---------- 6. Conteo con CL: usando registro ----------
    mov edx, OFFSET msg6a
    call WriteString
    call Crlf
    mov eax, 0
    mov al, 00001100b
    mov cl, 2                   ; en cl va la cantidad de posiciones a desplazar
    shl al, cl                  ; resultado = 0011 0000
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    mov edx, OFFSET msg6b
    call WriteString
    call Crlf
    shr al, cl                  ; regresa a 0000 1100 (divide entre 4)
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    ; ---------- 7. ROL, ROR, RCL, RCR ----------
    ; ROL
    mov edx, OFFSET msg7a
    call WriteString
    call Crlf
    mov eax, 0
    mov al, 10000001b
    rol al, 1                   ; el bit que sale por la izquierda entra por la derecha
                                ; resultado = 0000 0011
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    ; ROR
    mov edx, OFFSET msg7b
    call WriteString
    call Crlf
    mov eax, 0
    mov al, 10000001b
    ror al, 1                   ; el bit que sale por la derecha entra por la izquierda
                                ; resultado = 1100 0000
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    ; RCL
    mov edx, OFFSET msg7c
    call WriteString
    call Crlf
    mov eax, 0
    clc                         ; pongo CF en cero antes de rotar
    mov al, 10000001b
    rcl al, 1                   ; el bit 7 se va a CF y el CF anterior (0) entra por la derecha
                                ; resultado = 0000 0010 y CF = 1
    call DumpRegs
    call WriteBin
    call Crlf
    call Crlf

    ; RCR
    mov edx, OFFSET msg7d
    call WriteString
    call Crlf
    mov eax, 0
    clc                         ; otra ves CF en cero
    mov al, 10000001b
    rcr al, 1                   ; el bit 0 se va a CF y el CF anterior (0) entra por la izquierda
                                ; resultado = 0100 0000 y CF = 1
    call DumpRegs
    call WriteBin
    call Crlf

    exit
main ENDP
END main
