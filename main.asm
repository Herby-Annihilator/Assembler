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

    firstMatrixAdress dword ?
    secondMatrix dword ?
    memorySize4 dword ?
    firstMatrixStrIndexesSum dword ?

    matrixSize dword 3
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

    CreateQuadroMatrix 3, memorySize4
	mov firstMatrixAdress, eax
    
    FillMatrix firstMatrixAdress, 3, 4, message1, message2, whereToReadData

    CalculateStrIndexesSum firstMatrixAdress, 3, 4, firstMatrixStrIndexesSum, strAdress

    mov eax, firstMatrixStrIndexesSum


    invoke ExitProcess, 0			; �������� �������, ��� ��������� ��������

end start				; ��������� ������� ����
