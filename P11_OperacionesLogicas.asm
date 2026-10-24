; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 11. Operaciones lógicas
; Descripción: Controla el estado de una computadora con un byte de banderas usando las operaciones AND, OR, XOR y TEST, mostrando los resultados en binario y un mensaje segun el estado de la alarma.

INCLUDE Irvine32.inc

; Estado de computadora (un byte, cada bit es una bandera)
; bit 0 - computadora encendida   0: No  1: Si
; bit 1 - alarma encendida        0: No  1: Si
; bit 2 - computadora conectada   0: No  1: Si

; Condiciones iniciales: 0000 0101
; (computadora encendida, alarma apagada, computadora conectada)

.data
msgAnd        BYTE "1. AND (evaluacion de alarma): ", 0
msgOr         BYTE "2. OR (encender alarma)      : ", 0
msgXor1       BYTE "3. XOR (apagar computadora)  : ", 0
msgXor2       BYTE "   XOR (encender computadora): ", 0
msgTest       BYTE "4. TEST: ", 0
msgEncendida  BYTE "Alarma esta encendida", 0
msgApagada    BYTE "Alarma esta apagada", 0

.code
main PROC
    mov ebx, TYPE BYTE          ; WriteBin necesita el tamaño en ebx (1 byte)

    ; ---------- 1. AND: evaluacion de alarma ----------
    ; AND con la mascara 0000 0010 deja solo el bit de la alarma
    ; si da cero la alarma esta apagada, si da 0000 0010 esta encendida
    mov edx, OFFSET msgAnd
    call WriteString
    mov eax, 0                  ; limpio eax completo
    mov al, 00000101b           ; estado inicial
    and al, 00000010b           ; resultado = 0000 0000 (alarma apagada)
    push eax                    ; guardo eax por si WriteBin lo cambia
    call WriteBin
    pop eax
    call Crlf

    ; ---------- 2. OR: encender la alarma ----------
    ; OR con la mascara pone el bit en 1 sin tocar los demas bits
    mov edx, OFFSET msgOr
    call WriteString
    mov eax, 0
    mov al, 00000101b           ; estado inicial
    or al, 00000010b            ; resultado = 0000 0111 (alarma encendida)
    push eax
    call WriteBin
    pop eax
    call Crlf

    ; ---------- 3. XOR: apagar y encender la computadora ----------
    ; XOR con la mascara cambia el bit (si era 1 pasa a 0, si era 0 pasa a 1)
    ; Estado inicial: 0000 0101
    mov edx, OFFSET msgXor1
    call WriteString
    mov eax, 0
    mov al, 00000101b
    xor al, 00000001b           ; resultado = 0000 0100 (computadora apagada)
    push eax
    call WriteBin
    pop eax
    call Crlf

    mov edx, OFFSET msgXor2
    call WriteString
    xor al, 00000001b           ; otra ves XOR regresa al valor 0000 0101 (encendida)
    push eax
    call WriteBin
    pop eax
    call Crlf

    ; ---------- 4. TEST: evaluar la alarma y mostrar mensaje ----------
    ; TEST hace un AND pero no guarda el resultado, solo cambia las banderas
    ; si el resultado es cero (ZF=1) la alarma esta apagada
    mov edx, OFFSET msgTest
    call WriteString
    mov eax, 0
    mov al, 00000101b           ; estado inicial
    test al, 00000010b          ; reviso el bit 1 (alarma)
    jz apagada                  ; si ZF=1 salta al mensaje de apagada

    mov edx, OFFSET msgEncendida
    call WriteString
    jmp fin                     ; salto para no mostrar tambien el otro mensaje

apagada:
    mov edx, OFFSET msgApagada
    call WriteString

fin:
    call Crlf
    exit
main ENDP
END main
