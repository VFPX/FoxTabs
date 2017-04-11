
* Common Stuff
#define BROADCAST_QUERY_DENY        0x424D5144  &&// Return this value to deny a query.("BMQD")
#define GWL_WNDPROC         (-4)
#define WM_USER                   	0x0400

*-- GA Flags
#DEFINE GA_PARENT     			0x0001 
#DEFINE GA_ROOT       			0x0002 
#DEFINE GA_ROOTOWNER  			0x0003 

*-- Windows messages
#define WM_NULL				0x0000
#define WM_CREATE				0x0001
#define WM_DESTROY			0x0002
#define WM_MOVE				0x0003
#define WM_SIZE				0x0005
#define WM_ACTIVATE			0x0006
#define WM_SETFOCUS			0x0007
#define WM_KILLFOCUS			0x0008
#define WM_ENABLE				0x000A
#define WM_SETREDRAW			0x000B
#define WM_SETTEXT			0x000C
#define WM_GETTEXT			0x000D
#define WM_GETTEXTLENGTH		0x000E
#define WM_PAINT				0x000F
#define WM_CLOSE				0x0010
#define WM_QUERYENDSESSION		0x0011
#define WM_QUIT				0x0012
#define WM_QUERYOPEN			0x0013
#define WM_ERASEBKGND			0x0014
#define WM_SYSCOLORCHANGE		0x0015
#define WM_ENDSESSION			0x0016
#define WM_SHOWWINDOW			0x0018
#define WM_WININICHANGE			0x001A
#define WM_DEVMODECHANGE		0x001B
#define WM_ACTIVATEAPP			0x001C
#define WM_FONTCHANGE			0x001D
#define WM_TIMECHANGE			0x001E
#define WM_CANCELMODE			0x001F
#define WM_SETCURSOR			0x0020
#define WM_MOUSEACTIVATE		0x0021
#define WM_CHILDACTIVATE		0x0022
#define WM_QUEUESYNC			0x0023
#define WM_GETMINMAXINFO		0x0024
#define WM_PAINTICON			0x0026
#define WM_ICONERASEBKGND		0x0027
#define WM_NEXTDLGCTL			0x0028
#define WM_SPOOLERSTATUS		0x002A
#define WM_DRAWITEM			0x002B
#define WM_MEASUREITEM			0x002C
#define WM_DELETEITEM			0x002D
#define WM_VKEYTOITEM			0x002E
#define WM_CHARTOITEM			0x002F
#define WM_SETFONT			0x0030
#define WM_GETFONT			0x0031
#define WM_SETHOTKEY			0x0032
#define WM_GETHOTKEY			0x0033
#define WM_QUERYDRAGICON		0x0037
#define WM_COMPAREITEM			0x0039
#define WM_COMPACTING			0x0041
#define WM_WINDOWPOSCHANGING		0x0046
#define WM_WINDOWPOSCHANGED		0x0047
#define WM_POWER				0x0048
#define WM_COPYDATA			0x004A
#define WM_CANCELJOURNAL		0x004B
#define WM_NCCREATE			0x0081
#define WM_NCDESTROY			0x0082
#define WM_NCCALCSIZE			0x0083
#define WM_NCHITTEST			0x0084
#define WM_NCPAINT			0x0085
#define WM_NCACTIVATE			0x0086
#define WM_GETDLGCODE			0x0087
#define WM_NCMOUSEMOVE			0x00A0
#define WM_NCLBUTTONDOWN		0x00A1
#define WM_NCLBUTTONUP			0x00A2
#define WM_NCLBUTTONDBLCLK		0x00A3
#define WM_NCRBUTTONDOWN		0x00A4
#define WM_NCRBUTTONUP			0x00A5
#define WM_NCRBUTTONDBLCLK		0x00A6
#define WM_NCMBUTTONDOWN		0x00A7
#define WM_NCMBUTTONUP			0x00A8
#define WM_NCMBUTTONDBLCLK		0x00A9
#define WM_KEYFIRST			0x0100
#define WM_KEYDOWN			0x0100
#define WM_KEYUP				0x0101
#define WM_CHAR				0x0102
#define WM_DEADCHAR			0x0103
#define WM_SYSKEYDOWN			0x0104
#define WM_SYSKEYUP			0x0105
#define WM_SYSCHAR			0x0106
#define WM_SYSDEADCHAR			0x0107
#define WM_KEYLAST			0x0108
#define WM_INITDIALOG			0x0110
#define WM_COMMAND			0x0111
#define WM_SYSCOMMAND			0x0112
#define WM_TIMER				0x0113
#define WM_HSCROLL			0x0114
#define WM_VSCROLL			0x0115
#define WM_INITMENU			0x0116
#define WM_INITMENUPOPUP		0x0117
#define WM_MENUSELECT			0x011F
#define WM_MENUCHAR			0x0120
#define WM_ENTERIDLE			0x0121
#define WM_CTLCOLORMSGBOX		0x0132
#define WM_CTLCOLOREDIT			0x0133
#define WM_CTLCOLORLISTBOX		0x0134
#define WM_CTLCOLORBTN			0x0135
#define WM_CTLCOLORDLG			0x0136
#define WM_CTLCOLORSCROLLBAR		0x0137
#define WM_CTLCOLORSTATIC		0x0138
#define WM_MOUSEFIRST			0x0200
#define WM_MOUSEMOVE			0x0200
#define WM_LBUTTONDOWN			0x0201
#define WM_LBUTTONUP			0x0202
#define WM_LBUTTONDBLCLK		0x0203
#define WM_RBUTTONDOWN			0x0204
#define WM_RBUTTONUP			0x0205
#define WM_RBUTTONDBLCLK		0x0206
#define WM_MBUTTONDOWN			0x0207
#define WM_MBUTTONUP			0x0208
#define WM_MBUTTONDBLCLK		0x0209
#define WM_MOUSELAST			0x0209
#define WM_PARENTNOTIFY			0x0210
#define WM_ENTERMENULOOP		0x0211
#define WM_EXITMENULOOP			0x0212
#define WM_POWERBROADCAST		0x0218
#define WM_DEVICECHANGE			0x0219
#define WM_MDICREATE			0x0220
#define WM_MDIDESTROY			0x0221
#define WM_MDIACTIVATE			0x0222
#define WM_MDIRESTORE			0x0223
#define WM_MDINEXT			0x0224
#define WM_MDIMAXIMIZE			0x0225
#define WM_MDITILE			0x0226
#define WM_MDICASCADE			0x0227
#define WM_MDIICONARRANGE		0x0228
#define WM_MDIGETACTIVE			0x0229
#define WM_MDISETMENU			0x0230
#define WM_DROPFILES			0x0233
#define WM_MDIREFRESHMENU		0x0234
#define WM_CUT				0x0300
#define WM_COPY				0x0301
#define WM_PASTE				0x0302
#define WM_CLEAR				0x0303
#define WM_UNDO				0x0304
#define WM_RENDERFORMAT			0x0305
#define WM_RENDERALLFORMATS		0x0306
#define WM_DESTROYCLIPBOARD		0x0307
#define WM_DRAWCLIPBOARD		0x0308
#define WM_PAINTCLIPBOARD		0x0309
#define WM_VSCROLLCLIPBOARD		0x030A
#define WM_SIZECLIPBOARD		0x030B
#define WM_ASKCBFORMATNAME		0x030C
#define WM_CHANGECBCHAIN		0x030D
#define WM_HSCROLLCLIPBOARD		0x030E
#define WM_QUERYNEWPALETTE		0x030F
#define WM_PALETTEISCHANGING		0x0310
#define WM_PALETTECHANGED		0x0311
#define WM_HOTKEY				0x0312
#define WM_THEMECHANGED			0x031A
#define WM_PENWINFIRST			0x0380
#define WM_PENWINLAST			0x038F

* WM_ACTIVATE state values
#define WA_INACTIVE			0
#define WA_ACTIVE				1
#define WA_CLICKACTIVE			2

* Shell notification fSources
#define SHCNRF_INTERRUPTLEVEL		0x0001
#define SHCNRF_SHELLLEVEL		0x0002
#define SHCNRF_RECURSIVEINTERRUPT	0x1000
#define SHCNRF_NEWDELIVERY		0x8000

* Device and Media Events
#define WM_USER_SHNOTIFY          WM_USER+10
#define SHCNE_RENAMEITEM          0x00000001
#define SHCNE_CREATE              0x00000002
#define SHCNE_DELETE              0x00000004
#define SHCNE_MKDIR               0x00000008
#define SHCNE_RMDIR               0x00000010
#define SHCNE_MEDIAINSERTED       0x00000020
#define SHCNE_MEDIAREMOVED        0x00000040
#define SHCNE_DRIVEREMOVED        0x00000080
#define SHCNE_DRIVEADD            0x00000100
#define SHCNE_NETSHARE            0x00000200
#define SHCNE_NETUNSHARE          0x00000400
#define SHCNE_ATTRIBUTES          0x00000800
#define SHCNE_UPDATEDIR           0x00001000
#define SHCNE_UPDATEITEM          0x00002000
#define SHCNE_SERVERDISCONNECT    0x00004000
#define SHCNE_UPDATEIMAGE         0x00008000
#define SHCNE_DRIVEADDGUI         0x00010000
#define SHCNE_RENAMEFOLDER        0x00020000
#define SHCNE_FREESPACE           0x00040000
#define SHCNE_ASSOCCHANGED	    0x08000000
 
#define SHCNE_DISKEVENTS          0x0002381F
#define SHCNE_GLOBALEVENTS        0x0C0581E0 
#define SHCNE_ALLEVENTS           0x7FFFFFFF
#define SHCNE_INTERRUPT           0x80000000 

#define CSIDL_DESKTOP                   0x0000        &&// <desktop>
#define CSIDL_INTERNET                  0x0001        &&// Internet Explorer (icon on desktop)
#define CSIDL_PROGRAMS                  0x0002        &&// Start Menu\Programs
#define CSIDL_CONTROLS                  0x0003        &&// My Computer\Control Panel
#define CSIDL_PRINTERS                  0x0004        &&// My Computer\Printers
#define CSIDL_PERSONAL                  0x0005        &&// My Documents
#define CSIDL_FAVORITES                 0x0006        &&// <user name>\Favorites
#define CSIDL_STARTUP                   0x0007        &&// Start Menu\Programs\Startup
#define CSIDL_RECENT                    0x0008        &&// <user name>\Recent
#define CSIDL_SENDTO                    0x0009        &&// <user name>\SendTo
#define CSIDL_BITBUCKET                 0x000a        &&// <desktop>\Recycle Bin
#define CSIDL_STARTMENU                 0x000b        &&// <user name>\Start Menu
#define CSIDL_MYDOCUMENTS               0x000c        &&// logical "My Documents" desktop icon
#define CSIDL_MYMUSIC                   0x000d        &&// "My Music" folder
#define CSIDL_MYVIDEO                   0x000e        &&// "My Videos" folder

#define WM_DEVICECHANGE         	    0x0219
#define DBT_DEVNODES_CHANGED            0x0007
#define DBT_DEVICEARRIVAL               0x8000  &&// system detected a new device
#define DBT_DEVICEQUERYREMOVE           0x8001  &&// wants to remove, may fail
#define DBT_DEVICEQUERYREMOVEFAILED     0x8002  &&// removal aborted
#define DBT_DEVICEREMOVEPENDING         0x8003  &&// about to remove, still avail.
#define DBT_DEVICEREMOVECOMPLETE        0x8004  &&// device is gone
#define DBT_DEVTYP_OEM                  0x00000000  &&// oem-defined device type
#define DBT_DEVTYP_DEVNODE              0x00000001  &&// devnode number
#define DBT_DEVTYP_VOLUME               0x00000002  &&// logical volume
#define DBT_DEVTYP_PORT                 0x00000003  &&// serial, parallel
#define DBT_DEVTYP_NET                  0x00000004  &&// network resource 
 
* Power Events
#define PBT_APMQUERYSUSPEND             0x0000
#define PBT_APMQUERYSTANDBY             0x0001
#define PBT_APMQUERYSUSPENDFAILED       0x0002
#define PBT_APMQUERYSTANDBYFAILED       0x0003
#define PBT_APMSUSPEND                  0x0004
#define PBT_APMSTANDBY                  0x0005
#define PBT_APMRESUMECRITICAL           0x0006
#define PBT_APMRESUMESUSPEND            0x0007
#define PBT_APMRESUMESTANDBY            0x0008
#define PBTF_APMRESUMEFROMFAILURE       0x00000001
#define PBT_APMBATTERYLOW               0x0009
#define PBT_APMPOWERSTATUSCHANGE        0x000A
#define PBT_APMOEMEVENT                 0x000B
#define PBT_APMRESUMEAUTOMATIC          0x0012

#define HWND_TOP        (0)
#define HWND_BOTTOM     (1)
#define HWND_TOPMOST    (0xffffffff)
#define HWND_NOTOPMOST  (0xfffffffe)

#define WS_OVERLAPPED       0x00000000
#define WS_POPUP            0x80000000
#define WS_CHILD            0x40000000
#define WS_MINIMIZE         0x20000000
#define WS_VISIBLE          0x10000000
#define WS_DISABLED         0x08000000
#define WS_CLIPSIBLINGS     0x04000000
#define WS_CLIPCHILDREN     0x02000000
#define WS_MAXIMIZE         0x01000000
#define WS_CAPTION          0x00C00000    
#define WS_BORDER           0x00800000
#define WS_DLGFRAME         0x00400000
#define WS_VSCROLL          0x00200000
#define WS_HSCROLL          0x00100000
#define WS_SYSMENU          0x00080000
#define WS_THICKFRAME       0x00040000
#define WS_GROUP            0x00020000
#define WS_TABSTOP          0x00010000
#define WS_MINIMIZEBOX      0x00020000
#define WS_MAXIMIZEBOX      0x00010000
#define WS_TILED            WS_OVERLAPPED
#define WS_ICONIC           WS_MINIMIZE
#define WS_SIZEBOX          WS_THICKFRAME
#define WS_TILEDWINDOW      WS_OVERLAPPEDWINDOW
#define WS_EX_DLGMODALFRAME     0x00000001
#define WS_EX_NOPARENTNOTIFY    0x00000004
#define WS_EX_TOPMOST           0x00000008
#define WS_EX_ACCEPTFILES       0x00000010
#define WS_EX_TRANSPARENT       0x00000020
#define WS_EX_MDICHILD          0x00000040
#define WS_EX_TOOLWINDOW        0x00000080
#define WS_EX_WINDOWEDGE        0x00000100
#define WS_EX_CLIENTEDGE        0x00000200
#define WS_EX_CONTEXTHELP       0x00000400
#define WS_EX_RIGHT             0x00001000
#define WS_EX_LEFT              0x00000000
#define WS_EX_RTLREADING        0x00002000
#define WS_EX_LTRREADING        0x00000000
#define WS_EX_LEFTSCROLLBAR     0x00004000
#define WS_EX_RIGHTSCROLLBAR    0x00000000
#define WS_EX_CONTROLPARENT     0x00010000
#define WS_EX_STATICEDGE        0x00020000
#define WS_EX_APPWINDOW         0x00040000
#define WS_EX_OVERLAPPEDWINDOW  (WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE)
#define WS_EX_PALETTEWINDOW     (WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST)
#define WS_EX_LAYERED           0x00080000

* Show Window Constants
#define SW_FORCEMINIMIZE  		11 
#define SW_HIDE  				0 
#define SW_MAXIMIZE  			3 
#define SW_MINIMIZE  			6 
#define SW_RESTORE  			9 
#define SW_SHOW  				5 
#define SW_SHOWDEFAULT  		10 
#define SW_SHOWMAXIMIZED  		3 
#define SW_SHOWMINIMIZED  		2 
#define SW_SHOWMINNOACTIVE  	7 
#define SW_SHOWNA  				8 
#define SW_SHOWNOACTIVATE  		4 
#define SW_SHOWNORMAL  			1 
