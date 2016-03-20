; Author: Wang Zhao
; Create Time: 2016-03-20 20:31

TITLE DrawingTool Application

INCLUDE Irvine32.inc
INCLUDE GraphWin.inc

INCLUDELIB Irvine32.lib

;======================== DATA ========================
.data

ErrorTitle BYTE "Error", 0
WindowName BYTE "DrawingTool Application", 0
className BYTE "ASMWin", 0

; ������򴰿���ṹ
MainWin WNDCLASS <NULL, WinProc, NULL, NULL, NULL, NULL, NULL, \
    COLOR_WINDOW, NULL, className>
msg MSGStruct <>
hMainWnd DWORD ?
hInstance DWORD ?

;======================== CODE ========================
.code

WinMain PROC
; ��ȡ��ǰ���̵ľ��
    INVOKE GetModuleHandle, NULL
    mov hInstance, eax
    mov MainWin.hInstance, eax

; ���س���Ĺ���Լ�ͼ��
    INVOKE LoadIcon, NULL, IDI_APPLICATION
    mov MainWin.hIcon, eax
    INVOKE LoadCursor, NULL, IDC_ARROW
    mov MainWin.hCursor, eax

; ע�ᴰ����
    INVOKE RegisterClass, ADDR MainWin
    .IF eax == 0
        call ErrorHandler
        jmp Exit_Program
    .ENDIF

; ����Ӧ�ó����������
    INVOKE CreateWindowEx, 0, ADDR className,
        ADDR WindowName, MAIN_WINDOW_STYLE,
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
        CW_USEDEFAULT, NULL, NULL, hInstance, NULL

; ���CreateWindowExʧ�ܣ���ʾһ����Ϣ���˳�
    .IF eax == 0
        call ErrorHandler
        jmp Exit_Program
    .ENDIF

; ���洰�ھ������ʾ�����ƴ���
    mov hMainWnd, eax
    INVOKE ShowWindow, hMainWnd, SW_SHOW
    INVOKE UpdateWindow, hMainWnd

; ��ʼ����ĳ�����Ϣ����ѭ��
Message_Loop:
    ; �Ӷ����л����һ����Ϣ
    INVOKE GetMessage, ADDR msg, NULL, NULL, NULL

    ; ������Ϣ���˳�
    .IF eax == 0
        jmp Exit_Program
    .ENDIF

    ; ����Ϣת���������WinProc����
    INVOKE DispatchMessage, ADDR msg
    jmp Message_Loop

Exit_Program:
    INVOKE ExitProcess, 0
WinMain ENDP

WinProc PROC,
    hWnd: DWORD, localMsg: DWORD, wParam: DWORD, lParam: DWORD

    mov eax, localMsg

    .IF eax == WM_CREATE        ; ����������Ϣ��
        jmp WinProcExit
    .ELSEIF eax == WM_CLOSE     ; �رմ�����Ϣ��
        INVOKE PostQuitMessage, 0
        jmp WinProcExit
    .ELSE
        INVOKE DefWindowProc, hWnd, localMsg, wParam, lParam
        jmp WinProcExit
    .ENDIF

WinProcExit:
    ret
WinProc ENDP

ErrorHandler PROC

.data
pErrorMsg DWORD ?
messageID DWORD ?

.code
    INVOKE GetLastError
    mov messageID, eax

    ; ��ȡ��Ӧ����Ϣ�ַ���
    INVOKE FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER + \
        FORMAT_MESSAGE_FROM_SYSTEM, NULL, messageID, NULL,
        ADDR pErrorMsg, NULL, NULL

    ; ��ʾ������Ϣ
    INVOKE MessageBox, NULL, pErrorMsg, ADDR ErrorTitle,
        MB_ICONERROR+MB_OK

    ; �ͷ���Ϣ�ַ���
    INVOKE LocalFree, pErrorMsg
    ret
ErrorHandler ENDP
END WinMain
