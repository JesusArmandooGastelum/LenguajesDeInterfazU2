; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 15. Manipulación de archivos
; Descripción: Crea el archivo datos.txt, escribe un texto, lo cierra, lo vuelve a abrir, lo lee a un buffer y lo muestra en pantalla, revisando errores en cada paso.

INCLUDE Irvine32.inc

BUFFER_SIZE = 100

.data
nombreArchivo   BYTE "datos.txt",0
texto           BYTE "Hola, este dato se guardo desde ensamblador x86",0
longitudTexto   = ($ - texto) - 1       ; largo del texto sin contar el nulo

msgCreado       BYTE "Archivo datos.txt creado y texto escrito",0
msgLeido        BYTE "Contenido leido del archivo: ",0
msgErrCrear     BYTE "Error: no se pudo crear el archivo",0
msgErrEscribir  BYTE "Error: no se escribieron todos los bytes",0
msgErrAbrir     BYTE "Error: no se pudo abrir el archivo para leer",0
msgErrLeer      BYTE "Error: fallo la lectura del archivo",0

buffer          BYTE BUFFER_SIZE DUP(0) ; aqui se guarda lo que se lee
handle          DWORD ?                 ; identificador del archivo
bytesLeidos     DWORD ?

.code
main PROC
    ; ---------- 1. crear el archivo ----------
    mov edx, OFFSET nombreArchivo
    call CreateOutputFile           ; regresa el handle en eax
    cmp eax, INVALID_HANDLE_VALUE
    je errorCrear
    mov handle, eax

    ; ---------- 2. escribir el texto ----------
    mov eax, handle
    mov edx, OFFSET texto
    mov ecx, longitudTexto          ; cantidad de bytes a escribir
    call WriteToFile                ; eax = bytes escritos
    cmp eax, longitudTexto
    jne errorEscribir

    ; ---------- 3. cerrar el archivo ----------
    mov eax, handle
    call CloseFile

    mov edx, OFFSET msgCreado
    call WriteString
    call Crlf

    ; ---------- 4. abrir para leer ----------
    mov edx, OFFSET nombreArchivo
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je errorAbrir
    mov handle, eax

    ; ---------- 5. leer hacia el buffer ----------
    mov eax, handle
    mov edx, OFFSET buffer
    mov ecx, BUFFER_SIZE - 1        ; dejo un lugar para el nulo
    call ReadFromFile
    jc errorLeer                    ; si CF=1 hubo error
    mov bytesLeidos, eax

    ; ---------- 6. poner el nulo y mostrar ----------
    mov ebx, bytesLeidos
    mov BYTE PTR buffer[ebx], 0     ; ReadFromFile no pone el nulo, lo pongo yo
    mov edx, OFFSET msgLeido
    call WriteString
    mov edx, OFFSET buffer
    call WriteString
    call Crlf

    ; ---------- 7. cerrar otra ves ----------
    mov eax, handle
    call CloseFile
    jmp fin

errorCrear:
    mov edx, OFFSET msgErrCrear
    jmp mostrarError
errorEscribir:
    mov edx, OFFSET msgErrEscribir
    jmp mostrarError
errorAbrir:
    mov edx, OFFSET msgErrAbrir
    jmp mostrarError
errorLeer:
    mov edx, OFFSET msgErrLeer
mostrarError:
    call WriteString
    call Crlf

fin:
    exit
main ENDP
END main
