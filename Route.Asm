.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include Route.inc

.code


_ProcThread	proc
	LOCAL @si:STARTUPINFO, @pi:PROCESS_INFORMATION
	
	invoke RtlZeroMemory, addr @si, sizeof @si
	mov @si.cb, sizeof @si
	mov @si.wShowWindow, SW_HIDE
	mov @si.dwFlags, STARTF_USESHOWWINDOW
	invoke RtlZeroMemory, addr @pi, sizeof @pi
	
	invoke SendMessage, hWinStatus, SB_SETTEXT, 0, addr szDownloadSt1
	
	invoke CreateProcess, NULL, addr szDownloadCmd, NULL, NULL, FALSE, \
			0, NULL, NULL, addr @si, addr @pi
	.if !eax
		invoke MessageBox, hWinMain, addr szExecError, addr szError, MB_OK
	.else
		invoke WaitForSingleObject, @pi.hProcess, INFINITE
		invoke CloseHandle, @pi.hProcess
		invoke CloseHandle, @pi.hThread
		
		invoke SendMessage, hWinStatus, SB_SETTEXT, 0, addr szDownloadSt2
	.endif
	ret

_ProcThread endp

_LoadDll	proc
	.if !hDllInstance
		invoke LoadLibrary, addr szCmRouteDll
		.if eax
			mov hDllInstance, eax
			invoke GetProcAddress, hDllInstance, addr szSetRoutes
			.if eax
				mov lpSetRoutes, eax
			.else
				invoke MessageBox, hWinMain, addr szNoFunc, addr szError, MB_OK
			.endif
		.else
			invoke MessageBox, hWinMain, addr szLoadError, addr szError, MB_OK
		.endif
	.endif
	
	ret

_LoadDll endp

_DownloadData	proc
	invoke CreateThread, NULL, 0, addr _ProcThread, NULL, 0, NULL
	invoke CloseHandle, eax
	ret

_DownloadData endp

_AddRoutes	proc
	invoke _LoadDll
	.if lpSetRoutes
		invoke SendMessage, hWinStatus, SB_SETTEXT, 0, addr szAddSt1
		invoke lpSetRoutes, 0, 0, addr szAdd, 0
		invoke SendMessage, hWinStatus, SB_SETTEXT, 0, addr szAddSt2
	.endif
	ret

_AddRoutes endp

_DelRoutes	proc
	invoke _LoadDll
	.if lpSetRoutes
		invoke SendMessage, hWinStatus, SB_SETTEXT, 0, addr szDelSt1
		invoke lpSetRoutes, 0, 0, addr szDel, 0
		invoke SendMessage, hWinStatus, SB_SETTEXT, 0, addr szDelSt2
	.endif
	
	ret

_DelRoutes endp

_ProcDlgMain proc hWnd, wMsg, wParam, lParam

	mov	eax, wMsg
	.if eax==WM_INITDIALOG
		push hWnd
		pop hWinMain
		invoke LoadIcon, hInstance, ICO_MAIN
		invoke SendMessage, hWnd, WM_SETICON, ICON_BIG, eax
		invoke CreateStatusWindow, WS_CHILD OR WS_VISIBLE OR \
				SBS_SIZEGRIP, NULL, hWinMain, ID_STATUSBAR
		mov	hWinStatus,eax
	.elseif eax==WM_COMMAND
		mov eax, wParam
		.if ax==IDC_BTN_DOWNLOAD
			invoke _DownloadData
		.elseif ax==IDC_BTN_ADD
			invoke _AddRoutes
		.elseif ax==IDC_BTN_DEL
			invoke _DelRoutes
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog, hWnd, 0
	.else
		mov	eax, FALSE
		ret
	.endif
	mov		eax, TRUE
	ret

_ProcDlgMain endp

start:

	invoke GetModuleHandle,NULL
	mov hInstance,eax

	invoke DialogBoxParam, hInstance, IDD_DLG_MAIN, NULL, addr _ProcDlgMain, NULL
	invoke ExitProcess, 0
end start