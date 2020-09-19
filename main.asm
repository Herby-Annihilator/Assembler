.386					; 32-битный режим
.model flat, stdcall			; компиляция в exe-файл с возможностью вызова API
option casemap :none			; неразличение прописных и строчных символов

					; содержит значения констант
include C:\masm32\include\windows.inc	; STD_INPUT_HANDLE,
					; STD_OUTPUT_HANDLE

include <C:\masm32\include\kernel32.inc>
include <C:\masm32\include\user32.inc>
include <macros.inc>

includelib <C:\masm32\include\kernel32.lib>
includelib <C:\masm32\include\user32.lib>



.data					; сегмент данных

    hConsoleInput DWORD ?			; переменные для хранения хэндлов ввода
    hConsoleOutput DWORD ?			; и вавода

    Buffer byte 128 dup (?)			; для вода с клавиатуры 1 символа,

    NumberOfCharsRead DWORD ?		; переменные для записи числа фактически
    NumberOfCharsWritten DWORD ?		; введенных и выведенных символов
					

    msg1 byte " Hello, World!"		; строковая переменная

    msg2 byte " Нажмите Enter, чтобы выйти...", 0	; заканчивается нулем,
						    ; так как она будет передана
						    ; API-функции CharToOem

    msg1310 byte 13, 10			; перевод строки

    firstMatrix dword ?
    secondMatrix dword ?
    n dword ?


.code					; сегмент кода
start:

    mov eax,5
    mov n,eax
    CreateQuadroMatrix n
    mov firstMatrix,eax

    invoke AllocConsole			; запрашиваем у Windows консоль

    invoke GetStdHandle, STD_INPUT_HANDLE	; получаем хэндл консоли для ввода
    mov hConsoleInput, EAX			; записываем хэндл в переменную

    invoke GetStdHandle, STD_OUTPUT_HANDLE	; получаем хэндл консоли для вывода
    mov hConsoleOutput, EAX			; записываем хэндл в переменную


    AskUserToInputData msg1,msg1310,hConsoleOutput,NumberOfCharsWritten

                                                                    ;invoke CharToOem, ADDR msg2, ADDR msg2	; перекодируем Win1251 -> DOS



    invoke WriteConsoleA,			; пишем " Нажмите Enter, чтобы выйти..."
                          hConsoleOutput,
                               ADDR msg2,
                       (SIZEOF msg2) - 1,	; уменьшаем размер строки msg2 на 1 (из-за нуля)
               ADDR NumberOfCharsWritten,
                                       0



    invoke ReadConsoleA,			; ожидаем ввода в консоль
                          hConsoleInput,	; хэндл ввода
                            ADDR Buffer,	; адрес буфера
                                      1,	; вводим 1 символ
                 ADDR NumberOfCharsRead,	; сюда функция запишет число символов
                                      0	; lpReserved передаем, как ноль



    invoke ExitProcess, 0			; сообщаем системе, что программа окончена

end start				; завершает сегмент кода
