
include windows.inc
include kernel32.inc
include user32.inc
include	Comctl32.inc
include shell32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

ICO_MAIN			equ 100
IDD_DLG_MAIN		equ	101
IDC_BTN_DOWNLOAD	equ	1001
IDC_BTN_ADD			equ 1002
IDC_BTN_DEL			equ 1003
ID_STATUSBAR		equ 1004

_ProcSetRoutes		typedef	proto	:dword, :dword, :dword, :dword
ProcSetRoutes		typedef ptr	_ProcSetRoutes

.data?
hInstance			dd				?
hWinMain			dd				?
hWinStatus			dd				?

.data
hDllInstance		dd				0
lpSetRoutes			ProcSetRoutes	0

.const
szDownloadSt1		db	'Downloading..', 0
szAddSt1			db	'Adding routes...', 0
szDelSt1			db	'Deleting routes...', 0

szDownloadSt2		db	'Download finished', 0
szAddSt2			db	'Add finished', 0
szDelSt2			db	'Delete finished', 0

szCmRouteDll		db	'cmroute.dll', 0
szSetRoutes			db	'SetRoutes', 0

szDownloadCmd		db	'python.exe chnroutes.py', 0
szAdd				db	'/STATIC_FILE_NAME addchnroutes.txt /DONT_REQUIRE_URL /IPHLPAPI_ACCESS_DENIED_OK', 0
szDel				db	'/STATIC_FILE_NAME delchnroutes.txt /DONT_REQUIRE_URL /IPHLPAPI_ACCESS_DENIED_OK', 0

szExecError			db	'Error occured when executing command: python.exe chnroute.py', 0
szLoadError			db	'Error occured when LoadLibrary cmroute.dll', 0
szNoFunc			db	'No function named SetRoutes in the dll', 0
szError				db	'Error', 0