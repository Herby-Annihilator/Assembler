CreateQuadroMatrix macro memorySize, memorySize4
	local cycle
	invoke GetProcessHeap  ; получаем адрес кучи нашего процесса
	mov edi,eax
	mov eax, memorySize
	mov ebx, 4
	imul ebx
	mov memorySize4,eax
	push ecx
	invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,memorySize4
	pop ecx  ; потому что хрень выше обнуляет мне регистр

	mov ebx,eax   ; в ebx адрес начала массива указателей
	mov ecx,memorySize 
	cycle:
		invoke GetProcessHeap
		mov edi,eax
		push ecx
		invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,memorySize4  ; eax содержит адрес нововго куска памяти
		pop ecx  ; потому что хрень выше обнуляет мне регистр
		mov edi,eax                                   ; edi содержит адрес нововго куска памяти
		mov eax,memorySize
		sub eax,ecx  ; eax содержит смещение, которое нужно умножить на 4
		mov edx,4
		imul edx       ; результат в eax
		mov [ebx + eax],edi
	loop cycle
	mov eax,ebx			
endm

AskUserToInputData macro message
	invoke WriteConsoleA,			; переводим строку в консоли
                      hConsoleOutput,	; хэндл вывода
                        ADDR msg1310,	; адрес строки msg1310
                      SIZEOF msg1310,	; размер строки msg1310
           ADDR NumberOfCharsWritten,	; сюда функция запишет число символов
                                   0	; lpReserved передаем, как ноль

	invoke WriteConsoleA,			; пишем message
                      hConsoleOutput,
                           ADDR message,
                         SIZEOF message,
           ADDR NumberOfCharsWritten,
                                   0

	invoke WriteConsoleA,			; переводим строку
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0
endm


FillMatrix macro matrixAdress, matrixSize, elementSize, message1, message2, whereToReadData
	local firstFor
	local secondFor
	AskUserToInputData message1
	mov ecx, matrixSize
	firstFor:
		mov eax, matrixSize   ; число элементов в строке матрицы
		sub eax, ecx
		mov ebx, elementSize
		imul ebx   ; в eax относительный адрес нужного указателя
		mov edi, eax
		push ecx
		mov ecx, matrixSize
		secondFor:           ; на данном моменте заняты регистры: ecx, edi - относительный адрес нужного указателя
			push ecx    ; потому что код ниже изменяет ecx
			mov eax, matrixSize
			sub eax, ecx
			mov ebx, elementSize
			imul ebx
			mov esi, eax  ; в esi индекс (умноженный на 4) элемента, в который записываем
			
			invoke WriteConsole, hConsoleOutput, ADDR message2, (SIZEOF message2) - 1, ADDR NumberOfCharsWritten, 0 ; предлагаем ввести число
			invoke ReadConsole, hConsoleInput, ADDR whereToReadData, SIZEOF whereToReadData, ADDR NumberOfCharsRead, 0
			
			lea ebx, [whereToReadData]        ;удаление символов
			add ebx, [NumberOfCharsRead]        ;перевода строки
			sub ebx, 2                        ;из буфера ввода
			mov [ebx], word ptr 0
			invoke  atodw, ADDR whereToReadData   ; преобразуем строку в число, результат в eax
			
			mov ebx, edi
			add ebx, matrixAdress  ; в  ebx адрес указателя на другой указатель
			mov ebx, [ebx]  ; в ebx укзатель (адрес массива - куска памяти)
			mov [ebx + esi], eax
			pop ecx   ; потому что код выше изменяет ecx
		loop secondFor
		invoke WriteConsoleA,			; переводим строку
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0
		pop ecx
		dec ecx
	jnz firstFor		; потому что loop не может допрыгнуть
endm


CalculateStrIndexesSum macro matrixAdress, matrixSize, elementSize, futureSum, strAdress  ; strAdress - просто пустая переменная, нужна для работы макроса
	local cycle, next
	mov eax, 0
	mov futureSum, eax
	mov ecx, matrixSize
	cycle:
		mov eax, matrixSize
		sub eax, ecx
		mov ebx, elementSize
		imul ebx
		mov ebx, matrixAdress
		add eax, ebx  ; в eax адрес указателя на одномерный массив
		mov eax, [eax]
		mov strAdress, eax
		push ecx
		push strAdress
		push matrixSize
		push elementSize
		call IsThisStrIncreasingSequence
		pop ecx
		cmp eax, 0   ; значит, что строка не содержит возрастающую последовательность
		jz next
		
		mov eax, matrixSize  ; иначе, добавляем номер текущей строки в общую сумму
		sub eax, ecx
		mov ebx, futureSum
		add ebx, eax
		mov futureSum, ebx

		next: 
	loop cycle
endm

