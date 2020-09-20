.386					; 32-битный режим
.model flat, stdcall			; компил€ци€ в exe-файл с возможностью вызова API
option casemap :none			; неразличение прописных и строчных символов

					; содержит значени€ констант
include C:\masm32\include\windows.inc	; STD_INPUT_HANDLE,
					; STD_OUTPUT_HANDLE

include <C:\masm32\include\kernel32.inc>
include <C:\masm32\include\user32.inc>
include <C:\masm32\include\masm32.inc>
include <macros.inc>

includelib <C:\masm32\lib\kernel32.lib>
includelib <C:\masm32\lib\user32.lib>
includelib <C:\masm32\lib\masm32.lib>
;include <C:\masm32\macros\macros.asm>



.data					; сегмент данных

    hConsoleInput DWORD ?			; переменные дл€ хранени€ хэндлов ввода
    hConsoleOutput DWORD ?			; и вавода

    whereToReadData byte 128 dup (?)			; дл€ вода с клавиатуры

    NumberOfCharsRead DWORD ?		; переменные дл€ записи числа фактически
    NumberOfCharsWritten DWORD ?		; введенных и выведенных символов
					

    msg1310 byte 13, 10			; перевод строки
    message1 byte "Lets fill first matrix", 0
    message2 byte "Input number ", 0

    firstMatrixAdress dword ?
    secondMatrix dword ?
    memorySize4 dword ?
    firstMatrixStrIndexesSum dword ?

    matrixSize dword 3
    elementSize dword 4

    strAdress dword ?


.code					; сегмент кода


IsThisStrIncreasingSequence proc
	push ebp
	mov ebp, esp

	mov eax, [ebp + 0ch]   ; загрузить в регистр число элементов в строке
	cmp eax, 1    ; elementsCount
	jz false

	mov ebx, [ebp + 10h]   ; достать адрес начала строки
	mov edi, [ebx]  ; в edi первый элемент строки

	mov ecx, [ebp + 0ch]  ; положить в регистр число элементов в строке
	dec ecx  ; уменьшить это число на 1, т.к. сравнивать будем, начина€ со второго числа
	cycle:
		mov eax, [ebp + 0ch]   ; вычисл€ем индекс элемента
		sub eax, ecx           ; в строке
		mov ebx, [ebp + 8]     ; в ebx размер нашего элемента в байтах
		imul ebx
		mov ebx, [ebp + 10h]   ; в ebx адрес начала строки
		add eax, ebx ; в eax адрес слова
		cmp [eax], edi
		jle false    ; если число по адресу в eax меньше или равно числу в edi
		mov edi, [eax]
	loop cycle
	mov eax, 1
	jmp exit
	false: mov eax, 0
	exit:
	pop ebp
	ret 0ch
IsThisStrIncreasingSequence endp



start:

    invoke AllocConsole			; запрашиваем у Windows консоль

    invoke GetStdHandle, STD_INPUT_HANDLE	; получаем хэндл консоли дл€ ввода
    mov hConsoleInput, eax			; записываем хэндл в переменную

    invoke GetStdHandle, STD_OUTPUT_HANDLE	; получаем хэндл консоли дл€ вывода
    mov hConsoleOutput, eax			; записываем хэндл в переменную

    CreateQuadroMatrix 3, memorySize4
	mov firstMatrixAdress, eax
    
    FillMatrix firstMatrixAdress, 3, 4, message1, message2, whereToReadData

    CalculateStrIndexesSum firstMatrixAdress, 3, 4, firstMatrixStrIndexesSum, strAdress

    mov eax, firstMatrixStrIndexesSum


    invoke ExitProcess, 0			; сообщаем системе, что программа окончена

end start				; завершает сегмент кода
