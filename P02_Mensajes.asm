; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 2. Captura y desplegado de mensajes
; Descripción: Pide el nombre al usuario con ReadString, lo guarda en un buffer y lo muestra junto con un saludo.

INCLUDE Irvine32.inc

.data
msgPide     BYTE "Escribe tu nombre: ",0
msgHola     BYTE "Hola, bienvenido a lenguajes de interfaz, ",0
msgLong     BYTE "Tu nombre tiene esta cantidad de letras: ",0
nombre      BYTE 31 DUP(0)      ; buffer para el nombre (30 letras + el nulo)

.code
main PROC
    ; mostramos el mesaje para pedir el nombre
    mov edx, OFFSET msgPide
    call WriteString

    ; ReadString: edx = direccion del buffer, ecx = maximo de caracteres
    mov edx, OFFSET nombre
    mov ecx, 30
    call ReadString         ; en eax regresa cuantos caracteres escribio
    push eax                ; guardo la longitud en la pila para despues

    ; desplegamos el saludo y el nombre
    mov edx, OFFSET msgHola
    call WriteString
    mov edx, OFFSET nombre
    call WriteString
    call Crlf

    ; desplegamos la longitud
    mov edx, OFFSET msgLong
    call WriteString
    pop eax                 ; recupero la longitud
    call WriteDec
    call Crlf

    exit
main ENDP
END main
