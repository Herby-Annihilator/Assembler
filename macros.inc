CreateQuadroMatrix macro size
	invoke GetProcessHeap
	mov edi,eax
	invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,size*4

	mov ebx,eax   ; � ebx ����� ������ ������� ����������
	mov ecx,size
	cycl:
		invoke GetProcessHeap
		mov edi,eax
		invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,size*4  ; eax �������� ����� ������� ����� ������
		mov edi,eax                                   ; edi �������� ����� ������� ����� ������
		mov eax,size
		sub eax,ecx  ; eax �������� ��������, ������� ����� �������� �� 4
		imul 4       ; ��������� � edx
		mov [ebx + edx],edi
	loop cycl
	mov eax,ebx
endm


IsThisStrIncreasingSequence macro adress, strLenght    ; ��� ������
	mov ecx,strLenght
	mov ebx,adress
	push [ebx]
	cycl:
		mov eax,[ebx + strLenght*4] ; error
		pop edx
		cmp eax,edx
		jge false   ; ���� ������ ��� �����
		push eax
	loop cycl
	pop eax
	jmp true
	false:mov eax,0
	true: mov eax,1
endm