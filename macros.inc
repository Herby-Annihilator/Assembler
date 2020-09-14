CreateQuadroMatrix macro size
	invoke GetProcessHeap
	mov edi,eax
	invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,size*4

	mov ebx,eax   ; в ebx адрес начала массива указателей
	mov ecx,size
	cycl:
		invoke GetProcessHeap
		mov edi,eax
		invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,size*4  ; eax содержит адрес нововго куска памяти
		mov edi,eax                                   ; edi содержит адрес нововго куска памяти
		mov eax,size
		sub eax,ecx  ; eax содержит смещение, которое нужно умножить на 4
		imul 4       ; результат в edx
		mov [ebx + edx],edi
	loop cycl
	mov eax,ebx
endm


IsThisStrIncreasingSequence macro adress, strLenght    ; тут ошибки
	mov ecx,strLenght
	mov ebx,adress
	push [ebx]
	cycl:
		mov eax,[ebx + strLenght*4] ; error
		pop edx
		cmp eax,edx
		jge false   ; если больше или равно
		push eax
	loop cycl
	pop eax
	jmp true
	false:mov eax,0
	true: mov eax,1
endm