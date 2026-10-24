; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 6.1. Control de ocupación de un estacionamiento
; Descripción: Menu para controlar un estacionamiento de 30 lugares: registrar entrada (INC), salida (DEC) y ver ocupacion.

INCLUDE Irvine32.inc

CAPACIDAD = 30              ; el estacionamiento tiene 30 lugares

imprimir MACRO texto
    mov edx, OFFSET texto
    call WriteString
    call Crlf
ENDM

.data
msgTitulo   BYTE "===== CONTROL DE ESTACIONAMIENTO (30 lugares) =====",0
msgOp1      BYTE "1. Entra un carro",0
msgOp2      BYTE "2. Sale un carro",0
msgOp3      BYTE "3. Ver ocupacion",0
msgOp4      BYTE "4. Salir del programa",0
msgOpcion   BYTE "Elige una opcion: ",0
msgEntro    BYTE "Carro registrado, bienvenido",0
msgSalio    BYTE "Salida registrada, buen viaje",0
msgLleno    BYTE "El estacionamiento esta LLENO, no puede entrar",0
msgVacio    BYTE "El estacionamiento esta VACIO, no hay carros que salgan",0
msgOcupa    BYTE "Lugares ocupados: ",0
msgLibres   BYTE "Lugares libres: ",0
msgInvalida BYTE "Opcion invalida, intenta otra ves",0
msgAdios    BYTE "Programa terminado",0
ocupados    DWORD 0         ; cantidad de lugares ocupados ahorita

.code
main PROC
menu:
    call Crlf
    imprimir msgTitulo
    imprimir msgOp1
    imprimir msgOp2
    imprimir msgOp3
    imprimir msgOp4
    mov edx, OFFSET msgOpcion
    call WriteString
    call ReadInt            ; opcion en eax

    cmp eax, 1
    je entrada
    cmp eax, 2
    je salida
    cmp eax, 3
    je ver
    cmp eax, 4
    je terminar
    imprimir msgInvalida
    jmp menu

entrada:
    cmp ocupados, CAPACIDAD
    jae estaLleno           ; si ya hay 30 no deja entrar
    inc ocupados            ; entra un carro mas
    imprimir msgEntro
    jmp menu
estaLleno:
    imprimir msgLleno
    jmp menu

salida:
    cmp ocupados, 0
    je estaVacio            ; si hay cero no puede salir nadie
    dec ocupados            ; sale un carro
    imprimir msgSalio
    jmp menu
estaVacio:
    imprimir msgVacio
    jmp menu

ver:
    mov edx, OFFSET msgOcupa
    call WriteString
    mov eax, ocupados
    call WriteDec
    call Crlf
    mov edx, OFFSET msgLibres
    call WriteString
    mov eax, CAPACIDAD
    sub eax, ocupados       ; libres = capacidad - ocupados
    call WriteDec
    call Crlf
    jmp menu

terminar:
    imprimir msgAdios
    exit
main ENDP
END main
