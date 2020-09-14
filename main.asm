.386					; 32-������ �����
.model flat, stdcall			; ���������� � exe-���� � ������������ ������ API
option casemap :none			; ������������ ��������� � �������� ��������

					; �������� �������� ��������
include C:\masm32\include\windows.inc	; STD_INPUT_HANDLE,
					; STD_OUTPUT_HANDLE

include <C:\masm32\include\kernel32.inc>
include <C:\masm32\include\user32.inc>
include <macros.inc>

includelib <C:\ProgramFiles(x86)\WindowsKits\10\Lib\10.0.18362.0\um\x86\kernel32.lib>
includelib <C:\ProgramFiles(x86)\WindowsKits\10\Lib\10.0.18362.0\um\x86\user32.lib>



.data					; ������� ������



hConsoleInput DWORD ?			; ���������� ��� �������� ������� �����
hConsoleOutput DWORD ?			; � ������

Buffer byte 1 dup (0)			; ��� ���� � ���������� 1 �������,

NumberOfCharsRead DWORD ?		; ���������� ��� ������ ����� ����������
NumberOfCharsWritten DWORD ?		; ��������� � ���������� ��������
					

msg1 byte " Hello, World!"		; ��������� ����������

msg2 byte " ������� Enter, ����� �����...", 0	; ������������� �����,
						; ��� ��� ��� ����� ��������
						; API-������� CharToOem

msg1310 byte 13, 10			; ������� ������

firstMatrix dword ?
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



invoke WriteConsoleA,			; ��������� ������ � �������
                      hConsoleOutput,	; ����� ������
                        ADDR msg1310,	; ����� ������ msg1310
                      SIZEOF msg1310,	; ������ ������ msg1310
           ADDR NumberOfCharsWritten,	; ���� ������� ������� ����� ��������
                                   0	; lpReserved ��������, ��� ����



invoke WriteConsoleA,			; ����� " Hello, World!"
                      hConsoleOutput,
                           ADDR msg1,
                         SIZEOF msg1,
           ADDR NumberOfCharsWritten,
                                   0



invoke WriteConsoleA,			; ��������� ������
                      hConsoleOutput,
                        ADDR msg1310,
                      SIZEOF msg1310,
           ADDR NumberOfCharsWritten,
                                   0



invoke CharToOem, ADDR msg2, ADDR msg2	; ������������ Win1251 -> DOS



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
