; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 9. PUSH y POP
; Descripción: Usa la pila para invertir el orden de valores y de una cadena, y para guardar y recuperar registros.

INCLUDE Irvine32.inc

.data
msgTitulo1  BYTE "1. Guardar y recuperar registros con PUSH/POP",0
msgEax      BYTE "EAX recuperado = ",0
msgEbx      BYTE "EBX recuperado = ",0
msgTitulo2  BYTE "2. Cadena invertida usando la pila",0
msgOriginal BYTE "Cadena original: ",0
msgInvert   BYTE "Cadena invertida: ",0
cadena      BYTE "LENGUAJES DE INTERFAZ",0

.code
main PROC
    ; ---------- parte 1: guardar registros ----------
    mov edx, OFFSET msgTitulo1
    call WriteString
    call Crlf

    mov eax, 100
    mov ebx, 200
    push eax                ; primero entra eax
    push ebx                ; despues entra ebx (queda hasta arriba)
    mov eax, 0              ; borro los registros
    mov ebx, 0
    pop ebx                 ; sale primero ebx (LIFO: ultimo en entrar, primero en salir)
    pop eax

    mov edx, OFFSET msgEax
    call WriteString
    call WriteDec           ; eax vale 100 otra vez
    call Crlf
    mov edx, OFFSET msgEbx
    call WriteString
    mov eax, ebx
    call WriteDec           ; ebx vale 200 otra vez
    call Crlf
    call Crlf

    ; ---------- parte 2: invertir una cadena ----------
    mov edx, OFFSET msgTitulo2
    call WriteString
    call Crlf
    mov edx, OFFSET msgOriginal
    call WriteString
    mov edx, OFFSET cadena
    call WriteString
    call Crlf

    mov ecx, LENGTHOF cadena - 1    ; cantidad de letras sin contar el nulo
    mov esi, 0
meterLetras:
    movzx eax, cadena[esi]  ; push necesita 16 o 32 bits, por eso uso movzx
    push eax
    inc esi
    loop meterLetras

    mov edx, OFFSET msgInvert
    call WriteString
    mov ecx, LENGTHOF cadena - 1
sacarLetras:
    pop eax                 ; salen en orden contrario
    call WriteChar
    loop sacarLetras
    call Crlf

    exit
main ENDP
END main
