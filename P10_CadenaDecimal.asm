; Materia: Lenguajes de Interfaz
; Alumno: Jesús Armando Gastelum Medina
; Horario: 8:00 - 9:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 10. Obtención de una cadena decimal
; Descripción: Calcula el avance de descarga de un archivo (bytes descargados, pendientes, porcentaje, grupos de 1024 y residuo) y muestra cada resultado convirtiendolo a cadena decimal con el procedimiento convertirDecimal (DIV, PUSH y POP), sin usar WriteDec.

INCLUDE Irvine32.inc

.data
    ; ---- datos del problema ----
    totalBytes       DWORD 100000       ; tamaño total del archivo en bytes
    bloquesRecibidos DWORD 125          ; bloques que ya se recibieron
    tamBloque        DWORD 512          ; cada bloque mide 512 bytes

    ; ---- resultados (se calculan en main) ----
    bytesDescargados DWORD ?
    bytesPendientes  DWORD ?
    porcentaje       DWORD ?
    grupos1024       DWORD ?
    residuo1024      DWORD ?

    ; ---- mensajes que se muestran ----
    msgTitulo        BYTE "Avance de descarga de un archivo", 0
    msgDescargados   BYTE "Bytes descargados        : ", 0
    msgPendientes    BYTE "Bytes pendientes         : ", 0
    msgPorcentaje    BYTE "Porcentaje de avance     : ", 0
    msgGrupos        BYTE "Grupos de 1024 bytes     : ", 0
    msgResiduo       BYTE "Residuo del agrupamiento : ", 0

    buffer           BYTE 11 DUP(0)     ; aqui queda la cadena (10 digitos + el nulo)

.code
main PROC
    mov edx, OFFSET msgTitulo
    call WriteString
    call Crlf
    call Crlf

    ; 1. Calcular bytes descargados = 125 * 512
    mov eax, bloquesRecibidos
    mov ebx, tamBloque
    mul ebx                 ; EDX:EAX = 125 * 512 = 64000
    mov bytesDescargados, eax

    ; 2. Calcular bytes pendientes = 100000 - bytesDescargados
    mov eax, totalBytes
    sub eax, bytesDescargados
    mov bytesPendientes, eax        ; resulta 36000

    ; 3. Calcular porcentaje entero de avance = (bytesDescargados * 100) / totalBytes
    mov eax, bytesDescargados
    mov ebx, 100
    mul ebx                 ; EDX:EAX = bytesDescargados * 100
    mov ebx, totalBytes
    div ebx                 ; EAX = cociente (porcentaje), EDX = residuo
    mov porcentaje, eax             ; resulta 64

    ; 4. Calcular grupos completos de 1024 bytes y residuo sobre los bytes descargados
    mov eax, bytesDescargados
    mov ebx, 1024
    xor edx, edx            ; hay que poner edx en cero antes del div
    div ebx                 ; EAX = grupos completos de 1024, EDX = residuo
    mov grupos1024, eax             ; resulta 62
    mov residuo1024, edx            ; resulta 512

    ; 5. Mostrar los resultados (cada uno se convierte a cadena)
    mov edx, OFFSET msgDescargados
    mov eax, bytesDescargados
    call mostrarNumero

    mov edx, OFFSET msgPendientes
    mov eax, bytesPendientes
    call mostrarNumero

    mov edx, OFFSET msgPorcentaje
    mov eax, porcentaje
    call mostrarNumero

    mov edx, OFFSET msgGrupos
    mov eax, grupos1024
    call mostrarNumero

    mov edx, OFFSET msgResiduo
    mov eax, residuo1024
    call mostrarNumero

    exit
main ENDP

;---------------------------------------------------------
; mostrarNumero
; Recibe: EDX = direccion del mensaje, EAX = numero a mostrar
; Muestra el mensaje y despues el numero ya convertido a texto
;---------------------------------------------------------
mostrarNumero PROC
    push eax                ; guardo el numero por si WriteString lo modifica
    call WriteString        ; muestra el mesaje que viene en edx
    pop eax                 ; recupero el numero
    mov esi, OFFSET buffer  ; esi apunta al buffer donde se guarda la cadena
    call convertirDecimal   ; convierte eax a texto
    mov edx, OFFSET buffer
    call WriteString        ; muestra la cadena del numero
    call Crlf
    ret
mostrarNumero ENDP

;---------------------------------------------------------
; convertirDecimal
; Recibe: EAX = numero a convertir, ESI = direccion del buffer (11 bytes)
; Devuelve: la cadena decimal en el buffer terminada en 00h
; Idea: se divide entre 10 y el residuo es un digito. Los digitos
; salen al reves (de derecha a izquierda), por eso se guardan con
; PUSH y despues se sacan con POP para quedar en el orden correcto.
;---------------------------------------------------------
convertirDecimal PROC
    push eax                ; guardo los registros que voy a usar
    push ebx
    push ecx
    push edx
    push esi

    mov ebx, 10             ; divisor
    mov ecx, 0              ; ecx cuenta cuantos digitos salieron

sacarDigitos:
    xor edx, edx            ; limpio edx para el div
    div ebx                 ; eax = cociente, edx = residuo (un digito)
    push edx                ; guardo el digito en la pila
    inc ecx                 ; un digito mas
    cmp eax, 0
    jne sacarDigitos        ; repite mientras el cociente no sea cero

guardarDigitos:
    pop edx                 ; saco el digito de mayor valor primero
    add dl, '0'             ; lo paso a caracter ASCII (0 = 30h)
    mov [esi], dl           ; lo guardo en el buffer
    inc esi                 ; siguiente posicion
    loop guardarDigitos     ; repite tantas beses como digitos

    mov BYTE PTR [esi], 0   ; pongo el 00h al final de la cadena

    pop esi                 ; regreso los registros como estaban
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
convertirDecimal ENDP

END main
