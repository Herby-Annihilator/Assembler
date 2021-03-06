CreateQuadroMatrix macro memorySize, memorySize4
	local cycle
	invoke GetProcessHeap  ; �������� ����� ���� ������ ��������
	mov edi,eax
	mov eax, memorySize
	mov ebx, 4
	imul ebx
	mov memorySize4,eax
	push ecx
	invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,memorySize4
	pop ecx  ; ������ ��� ����� ���� �������� ��� �������

	mov ebx,eax   ; � ebx ����� ������ ������� ����������
	mov ecx,memorySize 
	cycle:
		invoke GetProcessHeap
		mov edi,eax
		push ecx
		invoke HeapAlloc,edi,HEAP_ZERO_MEMORY,memorySize4  ; eax �������� ����� ������� ����� ������
		pop ecx  ; ������ ��� ����� ���� �������� ��� �������
		mov edi,eax                                   ; edi �������� ����� ������� ����� ������
		mov eax,memorySize
		sub eax,ecx  ; eax �������� ��������, ������� ����� �������� �� 4
		mov edx,4
		imul edx       ; ��������� � eax
		mov [ebx + eax],edi
	loop cycle
	mov eax,ebx			
endm

SendMessageToUser macro message
	invoke WriteConsoleA,			; ��������� ������ � �������
                      hConsoleOutput,	; ����� ������
                        ADDR msg1310,	; ����� ������ msg1310
                      SIZEOF msg1310,	; ������ ������ msg1310
           ADDR NumberOfCharsWritten,	; ���� ������� ������� ����� ��������
                                   0	; lpReserved ��������, ��� ����

	invoke WriteConsoleA,			; ����� message
                      hConsoleOutput,
                           ADDR message,
                         SIZEOF message,
           ADDR NumberOfCharsWritten,
                                   0

	invoke WriteConsoleA,			; ��������� ������
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0
endm


FillMatrix macro matrixAdress, matrixSize, elementSize, message1, message2, whereToReadData
	local firstFor
	local secondFor
	SendMessageToUser message1
	mov ecx, matrixSize
	firstFor:
		mov eax, matrixSize   ; ����� ��������� � ������ �������
		sub eax, ecx
		mov ebx, elementSize
		imul ebx   ; � eax ������������� ����� ������� ���������
		mov edi, eax
		push ecx
		mov ecx, matrixSize
		secondFor:           ; �� ������ ������� ������ ��������: ecx, edi - ������������� ����� ������� ���������
			push ecx    ; ������ ��� ��� ���� �������� ecx
			mov eax, matrixSize
			sub eax, ecx
			mov ebx, elementSize
			imul ebx
			mov esi, eax  ; � esi ������ (���������� �� 4) ��������, � ������� ����������
			
			invoke WriteConsole, hConsoleOutput, ADDR message2, (SIZEOF message2) - 1, ADDR NumberOfCharsWritten, 0 ; ���������� ������ �����
			invoke ReadConsole, hConsoleInput, ADDR whereToReadData, SIZEOF whereToReadData, ADDR NumberOfCharsRead, 0
			
			lea ebx, [whereToReadData]        ;�������� ��������
			add ebx, [NumberOfCharsRead]        ;�������� ������
			sub ebx, 2                        ;�� ������ �����
			mov [ebx], word ptr 0
			invoke  atodw, ADDR whereToReadData   ; ����������� ������ � �����, ��������� � eax
			
			mov ebx, edi
			add ebx, matrixAdress  ; �  ebx ����� ��������� �� ������ ���������
			mov ebx, [ebx]  ; � ebx �������� (����� ������� - ����� ������)
			mov [ebx + esi], eax
			pop ecx   ; ������ ��� ��� ���� �������� ecx
		loop secondFor
		invoke WriteConsoleA,			; ��������� ������
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0
		pop ecx
		dec ecx
	jnz firstFor		; ������ ��� loop �� ����� ����������
endm


CalculateStrIndexesSum macro matrixAdress, matrixSize, elementSize, futureSum, strAdress  ; strAdress - ������ ������ ����������, ����� ��� ������ �������
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
		add eax, ebx  ; � eax ����� ��������� �� ���������� ������
		mov eax, [eax]
		mov strAdress, eax
		push ecx
		push strAdress
		push matrixSize
		push elementSize
		call IsThisStrIncreasingSequence
		pop ecx
		cmp eax, 0   ; ������, ��� ������ �� �������� ������������ ������������������
		jz next
		
		mov eax, matrixSize  ; �����, ��������� ����� ������� ������ � ����� �����
		sub eax, ecx
		mov ebx, futureSum
		add ebx, eax
		mov futureSum, ebx

		next: 
	loop cycle
endm

DefineMatrixSize macro futureSize
	invoke ReadConsole, hConsoleInput, ADDR whereToReadData, SIZEOF whereToReadData, ADDR NumberOfCharsRead, 0
	lea ebx, [whereToReadData]        ;�������� ��������
	add ebx, [NumberOfCharsRead]        ;�������� ������
	sub ebx, 2                        ;�� ������ �����
	mov [ebx], word ptr 0
	invoke  atodw, ADDR whereToReadData   ; ����������� ������ � �����, ��������� � eax
	mov futureSize, eax
endm