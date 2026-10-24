; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 14. Captura y almacenamiento de datos numéricos
; Descripción: Registro de existencia en almacen: captura una cantidad de 1 a 99 con ReadString, la valida y convierte a numero a mano, la suma a 25 unidades y muestra el total con convertirDecimal (sin ReadDec, ReadInt, ParseDecimal32 ni WriteDec).

INCLUDE Irvine32.inc

.data
msgTitulo       BYTE "Registro de existencia de tarjetas ESP32",0
msgPide         BYTE "Cuantas unidades llegaron (1 a 99)?: ",0
msgError        BYTE "Entrada invalida. Solo 1 o 2 digitos entre 1 y 99, intenta otra ves.",0
msgExistencia   BYTE "Existencia actual: ",0
msgUnidades     BYTE " unidades",0

entrada             BYTE 11 DUP(0)  ; buffer donde se guarda lo que escribe el usuario
cantidadRecibida    DWORD ?
existenciaInicial   DWORD 25
existenciaActual    DWORD ?
bufferNumero        BYTE 11 DUP(0)  ; buffer para mostrar el resultado

.code
main PROC
    mov edx, OFFSET msgTitulo
    call WriteString
    call Crlf

pedirCantidad:
    mov edx, OFFSET msgPide
    call WriteString

    mov edx, OFFSET entrada
    mov ecx, 10
    call ReadString                 ; eax = cantidad de caracteres escritos

    ; ---- validar longitud: de 1 a 2 caracteres ----
    cmp eax, 1
    jb entradaInvalida              ; vacia
    cmp eax, 2
    ja entradaInvalida              ; mas de 2 caracteres

    ; ---- validar que sean digitos y convertir ----
    mov ecx, eax                    ; ecx = cantidad de caracteres a revisar
    mov esi, 0                      ; indice de la cadena
    mov ebx, 0                      ; ebx va acumulando el numero
revisarDigito:
    movzx eax, entrada[esi]         ; saco un caracter
    cmp al, '0'
    jb entradaInvalida              ; letras, signos y espacios caen aqui
    cmp al, '9'
    ja entradaInvalida
    sub al, '0'                     ; paso de caracter ASCII a valor 0-9
    imul ebx, ebx, 10               ; acumulado * 10 para abrir un lugar decimal
    add ebx, eax                    ; le sumo el digito nuevo
    inc esi
    loop revisarDigito

    ; ---- validar el rango 1 a 99 ----
    cmp ebx, 1
    jb entradaInvalida              ; por ejemplo "0" o "00"
    cmp ebx, 99
    ja entradaInvalida

    mov cantidadRecibida, ebx       ; guardo el numero en la variable DWORD

    ; ---- existenciaActual = existenciaInicial + cantidadRecibida ----
    mov eax, existenciaInicial
    add eax, cantidadRecibida
    mov existenciaActual, eax

    ; ---- mostrar el resultado ----
    mov edx, OFFSET msgExistencia
    call WriteString
    mov eax, existenciaActual
    mov esi, OFFSET bufferNumero
    call convertirDecimal
    mov edx, OFFSET bufferNumero
    call WriteString
    mov edx, OFFSET msgUnidades
    call WriteString
    call Crlf
    jmp fin

entradaInvalida:
    mov edx, OFFSET msgError
    call WriteString
    call Crlf
    jmp pedirCantidad               ; vuelve a pedir la cantidad

fin:
    exit
main ENDP

;---------------------------------------------------------
; convertirDecimal (el mismo procedimiento de la practica 10)
; Recibe: EAX = numero, ESI = direccion del buffer (11 bytes)
; Devuelve: la cadena decimal terminada en 00h
;---------------------------------------------------------
convertirDecimal PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov ebx, 10
    mov ecx, 0
sacarDigitos:
    mov edx, 0
    div ebx                         ; residuo en edx = un digito
    push edx
    inc ecx
    cmp eax, 0
    jne sacarDigitos

guardarDigitos:
    pop edx
    add dl, '0'
    mov [esi], dl
    inc esi
    loop guardarDigitos

    mov BYTE PTR [esi], 0           ; final de la cadena

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
convertirDecimal ENDP

END main
