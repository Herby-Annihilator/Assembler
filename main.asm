.386					; 32-������ �����
.model flat, stdcall			; ���������� � exe-���� � ������������ ������ API
option casemap :none			; ������������ ��������� � �������� ��������

					; �������� �������� ��������
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



.data					; ������� ������

    hConsoleInput DWORD ?			; ���������� ��� �������� ������� �����
    hConsoleOutput DWORD ?			; � ������

    whereToReadData byte 128 dup (?)			; ��� ���� � ����������

    NumberOfCharsRead DWORD ?		; ���������� ��� ������ ����� ����������
    NumberOfCharsWritten DWORD ?		; ��������� � ���������� ��������
					

    msg1310 byte 13, 10			; ������� ������
    message1 byte "Lets fill first matrix", 0
    message2 byte "Input number ", 0
	message3 byte "Lets fill second matrix", 0
	message4 byte "Lets fill third matrix", 0

	messageToInputFirstMatrixSize byte "Input first matrix size ",0
	messageToInputSecondMatrixSize byte "Input second matrix size ",0
	messageToInputThirdMatrixSize byte "Input third matrix size ",0

    firstMatrixAdress dword ?
	firstMatrixSize dword ?
	firstMatrixStrIndexesSum dword ?
    
	
	secondMatrixAdress dword ?
	secondMatrixSize dword ?
	secondMatrixStrIndexesSum dword ?


	thirdMatrixAdress dword ?
	thirdMatrixSize dword ?
	thirdMatrixStrIndexesSum dword ?

	formattedStr byte "Sum for first matrix = %d, sum for second matrix = %d, sum for third matrix = %d",0
	bufferForWsprintf byte 256 dup(0)


    memorySize4 dword ?
    elementSize dword 4

    strAdress dword ?


.code					; ������� ����


IsThisStrIncreasingSequence proc
	push ebp
	mov ebp, esp

	mov eax, [ebp + 0ch]   ; ��������� � ������� ����� ��������� � ������
	cmp eax, 1    ; elementsCount
	jz false

	mov ebx, [ebp + 10h]   ; ������� ����� ������ ������
	mov edi, [ebx]  ; � edi ������ ������� ������

	mov ecx, [ebp + 0ch]  ; �������� � ������� ����� ��������� � ������
	dec ecx  ; ��������� ��� ����� �� 1, �.�. ���������� �����, ������� �� ������� �����
	cycle:
		mov eax, [ebp + 0ch]   ; ��������� ������ ��������
		sub eax, ecx           ; � ������
		mov ebx, [ebp + 8]     ; � ebx ������ ������ �������� � ������
		imul ebx
		mov ebx, [ebp + 10h]   ; � ebx ����� ������ ������
		add eax, ebx ; � eax ����� �����
		cmp [eax], edi
		jle false    ; ���� ����� �� ������ � eax ������ ��� ����� ����� � edi
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

    invoke AllocConsole			; ����������� � Windows �������

    invoke GetStdHandle, STD_INPUT_HANDLE	; �������� ����� ������� ��� �����
    mov hConsoleInput, eax			; ���������� ����� � ����������

    invoke GetStdHandle, STD_OUTPUT_HANDLE	; �������� ����� ������� ��� ������
    mov hConsoleOutput, eax			; ���������� ����� � ����������

	invoke WriteConsoleA,			
                      hConsoleOutput,	
                        ADDR messageToInputFirstMatrixSize,	
                      SIZEOF messageToInputFirstMatrixSize,	
           ADDR NumberOfCharsWritten,	
                                   0	
	DefineMatrixSize firstMatrixSize
    CreateQuadroMatrix firstMatrixSize, memorySize4
	mov firstMatrixAdress, eax   
    FillMatrix firstMatrixAdress, firstMatrixSize, 4, message1, message2, whereToReadData
    CalculateStrIndexesSum firstMatrixAdress, firstMatrixSize, 4, firstMatrixStrIndexesSum, strAdress
    
	invoke WriteConsoleA,			
                      hConsoleOutput,	; ����� ������
                        ADDR messageToInputSecondMatrixSize,	
                      SIZEOF messageToInputSecondMatrixSize,	
           ADDR NumberOfCharsWritten,	
                                   0	
	DefineMatrixSize secondMatrixSize
	CreateQuadroMatrix secondMatrixSize, memorySize4
	mov secondMatrixAdress, eax
	FillMatrix secondMatrixAdress, secondMatrixSize, 4, message3, message2, whereToReadData
	CalculateStrIndexesSum secondMatrixAdress, secondMatrixSize, 4, secondMatrixStrIndexesSum, strAdress

	invoke WriteConsoleA,			
                      hConsoleOutput,	
                        ADDR messageToInputThirdMatrixSize,	
                      SIZEOF messageToInputThirdMatrixSize,	
           ADDR NumberOfCharsWritten,
                                   0
	DefineMatrixSize thirdMatrixSize
	CreateQuadroMatrix thirdMatrixSize, memorySize4
	mov thirdMatrixAdress, eax
	FillMatrix thirdMatrixAdress, thirdMatrixSize, 4, message4, message2, whereToReadData
	CalculateStrIndexesSum thirdMatrixAdress, thirdMatrixSize, 4, thirdMatrixStrIndexesSum, strAdress

	invoke wsprintf, addr bufferForWsprintf, addr formattedStr, firstMatrixStrIndexesSum, secondMatrixStrIndexesSum, thirdMatrixStrIndexesSum
	SendMessageToUser bufferForWsprintf

    invoke ExitProcess, 0			; �������� �������, ��� ��������� ��������

end start				; ��������� ������� ����
