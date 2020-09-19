.386					; 32-������ �����
.model flat, stdcall			; ���������� � exe-���� � ������������ ������ API
option casemap :none			; ������������ ��������� � �������� ��������

					; �������� �������� ��������
include C:\masm32\include\windows.inc	; STD_INPUT_HANDLE,
					; STD_OUTPUT_HANDLE

include <C:\masm32\include\kernel32.inc>
include <C:\masm32\include\user32.inc>
include <macros.inc>

includelib <C:\masm32\include\kernel32.lib>
includelib <C:\masm32\include\user32.lib>



.data					; ������� ������

    hConsoleInput DWORD ?			; ���������� ��� �������� ������� �����
    hConsoleOutput DWORD ?			; � ������

    Buffer byte 128 dup (?)			; ��� ���� � ���������� 1 �������,

    NumberOfCharsRead DWORD ?		; ���������� ��� ������ ����� ����������
    NumberOfCharsWritten DWORD ?		; ��������� � ���������� ��������
					

    msg1 byte " Hello, World!"		; ��������� ����������

    msg2 byte " ������� Enter, ����� �����...", 0	; ������������� �����,
						    ; ��� ��� ��� ����� ��������
						    ; API-������� CharToOem

    msg1310 byte 13, 10			; ������� ������

    firstMatrix dword ?
    secondMatrix dword ?
    n dword ?


.code					; ������� ����
start:

    mov eax,5
    mov n,eax
    CreateQuadroMatrix n
    mov firstMatrix,eax

    invoke AllocConsole			; ����������� � Windows �������

    invoke GetStdHandle, STD_INPUT_HANDLE	; �������� ����� ������� ��� �����
    mov hConsoleInput, EAX			; ���������� ����� � ����������

    invoke GetStdHandle, STD_OUTPUT_HANDLE	; �������� ����� ������� ��� ������
    mov hConsoleOutput, EAX			; ���������� ����� � ����������


    AskUserToInputData msg1,msg1310,hConsoleOutput,NumberOfCharsWritten

                                                                    ;invoke CharToOem, ADDR msg2, ADDR msg2	; ������������ Win1251 -> DOS



    invoke WriteConsoleA,			; ����� " ������� Enter, ����� �����..."
                          hConsoleOutput,
                               ADDR msg2,
                       (SIZEOF msg2) - 1,	; ��������� ������ ������ msg2 �� 1 (��-�� ����)
               ADDR NumberOfCharsWritten,
                                       0



    invoke ReadConsoleA,			; ������� ����� � �������
                          hConsoleInput,	; ����� �����
                            ADDR Buffer,	; ����� ������
                                      1,	; ������ 1 ������
                 ADDR NumberOfCharsRead,	; ���� ������� ������� ����� ��������
                                      0	; lpReserved ��������, ��� ����



    invoke ExitProcess, 0			; �������� �������, ��� ��������� ��������

end start				; ��������� ������� ����
