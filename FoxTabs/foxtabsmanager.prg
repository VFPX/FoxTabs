* _________________________________________________________________
*
* FoxTabs Manager Class
*
* [TODO] Describe class
* _________________________________________________________________

#Include "FoxTabs.h"

* _________________________________________________________________
*
* FoxTab Manager class
*
Define Class FoxTabsManager As Custom 

	* _____________________________________________________________
	*
	* Define class properties

	Add Object FoxTabs As Collection
	Add Object WindowsEvents As FoxTabsEventHandler
	Dimension aEventList[1]

	* _____________________________________________________________
	*
	* Define class members	

	Function Init()
		* Declare Win32 API functions 
		IF !('FoxTabsDeclareAPI' $ SET( 'Procedure' ))
			SET PROCEDURE TO FoxTabsDeclareAPI ADDITIVE
		ENDIF
	EndFunc 

	Function SetBindings()
	
		* Bind to all WM_CREATE messages
		BindWinEvent(0, WM_CREATE, This.WindowsEvents, "WMEventHandler")	

		* Setup event bindings to our Windows message event handler
		BindEvent(This.WindowsEvents, "WindowShowEvent", This, "WindowShow")
		BindEvent(This.WindowsEvents, "WindowSetTextEvent", This, "WindowSetText")
		BindEvent(This.WindowsEvents, "WindowSetFocusEvent", This, "WindowSetFocus")
		BindEvent(This.WindowsEvents, "WindowDestroyEvent", This, "WindowDestroy")

	EndFunc 
		
	Function LoadWindows(hWnd As Integer)

		Local oException As Exception 
		Local lnChildHWnd As Integer 

		Try 
			* Check if the window is a VFP IDE window
			If This.IsIDEWindow(hWnd) 
				* Add a new FoxTab object to our collection
				This.NewFoxTab(hWnd)
			EndIf 
			
			* Check all child windows
			lnChildHWnd = 0
			Do While .T.
				
				* Look for a child window of the current hWnd
				lnChildHWnd = FindWindowEx(hWnd, lnChildHWnd, 0, 0)
				If Empty(lnChildHWnd)
					* No child exists
					Exit 
				EndIf  
				
				* Call this method recursively until all child windows have been processed
				This.loadWindows(lnChildHWnd)

			EndDo
	
		Catch To oException
			* Raise error event
			RaiseEvent(This.Parent, "LogError", oException, "Exception caught while loading existing IDE windows.")
			
		EndTry
			
	EndFunc 
	
	Function NewFoxTab(hWnd As Integer) 

		Local oException As Exception
		Local oFoxTab As FoxTab
		
		Try
			* Check if a FoxTab already exists for this handle
			If Not Empty(This.FoxTabs.GetKey(Transform(hWnd, "@0x")))
				Exit
			EndIf 

			* Create a new instance of our FoxTab class
			oFoxTab = NewObject("FoxTab")

			* Set windows handle and window name properties
			oFoxTab.hWnd = Transform(hWnd, "@0x")
			oFoxTab.WindowName = This.getWindowTitle(hWnd)
			
			* Add the class to our collection
			This.FoxTabs.Add(oFoxTab, Transform(hWnd, "@0x"))
			
			* Raise the add FoxTab event
			RaiseEvent(This, "AddFoxTabEvent", oFoxTab)
			
			* Setup event bindings for this window
			This.WindowsEvents.SetBindings(hWnd)

		Catch To oException When oException.ErrorNo = 2071		&& user thrown
			* Throw to caller
			Throw oException
		
		Catch To oException
			* Set exception header details and throw to caller
			oException.UserValue = "Unhandled exception caught while adding a new FoxTab object to the collection."
			Throw oException
				
		EndTry
		
	EndFunc
	
	Function GetWindowTitle(hWnd As Integer) As String

		Local lcBuffer As String

		* Get the title using the WIN32API function
		lcBuffer = Space(200)

		GetWindowText(hWnd, @lcBuffer, Len(lcBuffer))

		* Strip out nulls and trim
		lcBuffer = Alltrim(Chrtran(lcBuffer, Chr(0), ""))

		Return lcBuffer
		
	EndFunc
	
	Function IsIDEWindow(hWnd As Integer) As Boolean 

		Local oException As Exception
		Local lbReturn As Boolean, lcWindowTitle As String, lnParentHWnd As Integer
		
		Local laToolbars[1]
		laToolBars = ""
		=ADockState(laToolBars, 2)

		Try
			* Gather the windows title
			lcWindowTitle = Nvl(This.getWindowTitle(hWnd), "")

			* Check the window title exclusion conditions
*JAL*				lbReturn = Application.hWnd # hWnd ;					&& Ignore the main FoxPro window
*JAL*							And This.Parent.FoxTabsToolbar.hWnd # hWnd ;	&& Ignore foxtabs toolbar
*JAL*							And Not Empty(lcWindowTitle) ;				&& Ignore windows with no titles
*JAL*							And Not InList(Lower(lcWindowTitle), "compile", "command", "properties", "document view", "data session", "debugger", "watch", "locals", "trace", "call stack", "debug output", "parentclass browser") ;
*JAL*							And Not InList(Lower(lcWindowTitle), "expression builder", "expression builder options") ;
*JAL*							And Ascan(laToolbars,lcWindowTitle,-1,-1,1,7) = 0
						
			*JAL* Now allow tracking of IDE windows except debugger
			lbReturn = Application.hWnd # hWnd ;					&& Ignore the main FoxPro window
						And This.Parent.FoxTabsToolbar.hWnd # hWnd ;	&& Ignore foxtabs toolbar
						And Not Empty(lcWindowTitle) ;				&& Ignore windows with no titles
						And Not InList(Lower(lcWindowTitle), "compile", "debugger", "watch", "locals", "trace", "call stack", "debug output", "parentclass browser") ;
						And Not InList(Lower(lcWindowTitle), "expression builder", "expression builder options") ;
						And Ascan(laToolbars,lcWindowTitle,-1,-1,1,7) = 0
			*Wait window nowait Transform(lcWindowTitle)			

			* Gather the hWnd of this windows parent
			lnParentHWnd = GetAncestor(hWnd, GA_PARENT)
			
			* Only allow children of _Screen
			lbReturn = lbReturn And lnParentHWnd = _Screen.hWnd

			* Check the border style
			lbReturn = lbReturn And This.HasBorder(hWnd)
			
		Catch To oException
			* Set details and throw to caller
			oException.UserValue = "Unhandled exception caught checking if the hWnd is an IDE Window."
			Throw oException

		EndTry

		Return lbReturn

	EndFunc
	
	Function HasBorder(hWnd As Integer) As Boolean

		Local lbReturn As Boolean, lcBuffer As String, lcStyle As String

		* Check the border style using the GetWindowInfo API
		lcBuffer = Space(60)

		GetWindowInfo(hWnd, @lcBuffer)

		* Parse WINDOWINFO struct
		lcStyle = CToBin(Substr(lcBuffer, (4*9)+1, 4), "4rs")
		If Bitand(lcStyle, WS_BORDER) = WS_BORDER
			lbReturn = .T.
		EndIf 

		Return lbReturn
	
	EndFunc 
	
	Function RefreshWindows(hWnd As Integer)

		Local oException As Exception 
		Local lnChildHWnd As Integer 
		
		Local i As Integer
		Local lnTabHWnd AS Integer 
		
		Try 
			* Go through and refresh all the Windows 
			For i = 1 TO This.FoxTabs.Count
				* refresh all the FoxTabs titles
				* convert the hex back to integer first though
				lnTabHWnd	= INT(VAL(This.FoxTabs.Item[i].hWnd))
				This.FoxTabs.Item[i].WindowName = This.getWindowTitle(lnTabHWnd)
			EndFor

			This.loadWindows(hWnd)
		
		Catch To oException
			* Raise error event
			RaiseEvent(This.Parent, "LogError", oException, "Exception caught while loading existing IDE windows.")
			
		EndTry
			
	EndFunc 
	
	* _____________________________________________________________
	*
	* Define event handlers

	Function WindowShow(hWnd As Integer)

		Local oFoxTab As Object
		Local oException As Exception
		
		Try
			* Check if a valid hWnd was passed
			If Empty(hWnd)
				Exit
			EndIf 

			* Data Environment defers setting of window title when opening
			* If it is the top window after opening, reload windows so it will show in tabs
			If Wontop() = "DATA ENVIRONMENT -"
				oFoxTabs.FoxTabsManager.LoadWindows(_VFP.hWnd)
			EndIf 
				
			* Check if a FoxTab object exists for this hWnd in our collection
			If Not Empty(This.FoxTabs.GetKey(Transform(hWnd, "@0x")))
				* Check the window is still a child of _Screen.
				If _Screen.hWnd	# GetAncestor(hWnd, GA_PARENT)
					* Remove FoxTab from our collection
					This.WindowDestroy(hWnd)
				EndIf 
				* Exit the try...catch block
				Exit										
			EndIf 
			
			* Check if the window is a VFP IDE window we are intersted in
			If Not This.IsIDEWindow(hWnd) 			
				* Release WM_SETTEXT event binding to this window
				UnBindWinEvents(hWnd, WM_SETTEXT, This.WindowsEvents, "WMEventHandler")
				* Exit the try...catch block
				Exit										
			EndIf 
			
			* Add a new FoxTab object to our collection
			This.NewFoxTab(hWnd)
			
		Catch To oException When oException.ErrorNo = 2071		&& user thrown
			* Throw to caller
			Throw oException
		
		Catch To oException
			* Set exception header details and throw to caller
			oException.UserValue = "Unhandled exception caught while adding a new FoxTab object to the collection."
			Throw oException				

		EndTry

	EndFunc 

	Function WindowSetText(hWnd As Integer)

		Local oFoxTab As Object
		Local oException As Exception
		Local cWindowCaption As String
		
		Try
			* Check if a valid hWnd was passed
			If Empty(hWnd)
				Exit
			EndIf 
			
			* Sometimes the WM_SETEXT event occurs before the WM_SHOWWINDOW (eg when VFP opens a window maximised)
			*	so we check if we need to add a FoxTab object here as well.
			This.WindowShow(hWnd)
			
			* Check if a FoxTab object exists for this hWnd in our collection
			If Empty(This.FoxTabs.GetKey(Transform(hWnd, "@0x")))
				* Exit the try...catch block
				Exit										
			EndIf 
			
			* Check the window is still a child of _Screen.
			* 	I have noticed VFP will create a child of _Screen, then 
			*	SetParent to a descendent of _Screen later.
			If _Screen.hWnd	# GetAncestor(hWnd, GA_PARENT)
				* Remove FoxTab from our collection
				This.WindowDestroy(hWnd)
				* Exit the try...catch block
				Exit
			EndIf 
				
			* Set the window name of the corresponding FoxTab object
			oFoxTab = This.FoxTabs.Item(Transform(hWnd, "@0x"))
			cWindowCaption = This.getWindowTitle(hWnd)
			If NOT oFoxTab.WindowName == cWindowCaption
				oFoxTab.WindowName = cWindowCaption

				* Raise the OnChange event
				RaiseEvent(This, "OnChangeEvent", oFoxTab) 
			EndIf 				
				
			* Set the window name of the corresponding FoxTab object
			*oFoxTab = This.FoxTabs.Item(Transform(hWnd, "@0x"))
			*oFoxTab.WindowName = This.getWindowTitle(hWnd)

			* Raise the OnChange event
			*RaiseEvent(This, "OnChangeEvent", oFoxTab)	
		
		Catch To oException When oException.ErrorNo = 2071		&& user thrown
			* Throw to caller
			Throw oException
		
		Catch To oException
			* Set exception header details and throw to caller
			oException.UserValue = "Unhandled exception caught while adding a new FoxTab object to the collection."
			Throw oException				

		EndTry
		
	EndFunc 

	Function WindowSetFocus(hWnd As Integer)

		Local oFoxTab As Object
		Local oException As Exception
		
		Try
			* Check the window is still a child of _Screen.
			* 	I have noticed VFP will create a child of _Screen, then 
			*	SetParent to a descendent of _Screen later.
			If _Screen.hWnd	# GetAncestor(hWnd, GA_PARENT)
				* Remove FoxTab from our collection
				This.WindowDestroy(hWnd)
				* Exit the try...catch block
				Exit
			EndIf 
		
			* Obtain a reference to the FoxTab object to pass to event delegate
			oFoxTab = This.FoxTabs.Item(Transform(hWnd, "@0x"))
			
			* Update the window name
			oFoxTab.WindowName = This.getWindowTitle(hWnd)

			* Raise the got focus event
			RaiseEvent(This, "GotFocusEvent", oFoxTab)	
			
		Catch To oException When oException.ErrorNo = 2071		&& user thrown
			* Throw to caller
			Throw oException
		
		Catch To oException
			* Set exception header details and throw to caller
			oException.UserValue = "Unhandled exception caught while updating the window name of the active FoxTab."
			Throw oException				

		EndTry
						
	EndFunc 

	Function WindowDestroy(hWnd As Integer)

		Local oFoxTab As Object
		Local oException As Exception
		
		Try
			* Check if a FoxTab object exists for this hWnd in our collection
			If Empty(This.FoxTabs.GetKey(Transform(hWnd, "@0x")))
				* Not interested
				Exit
			EndIf

			* Obtain a reference to the FoxTab object to pass to event delegate
			oFoxTab = This.FoxTabs.Item(Transform(hWnd, "@0x"))

			* Raise the remove FoxTab event
			RaiseEvent(This, "RemoveFoxTabEvent", oFoxTab)		

			* Release FoxTab reference so we can remove it from the collection
			oFoxTab = Null
					
			* Remove the FoxTab from the collection
			This.FoxTabs.Remove(Transform(hWnd, "@0x"))

			* Release event bindings to this window
			UnBindWinEvents(hWnd, 0, This.WindowsEvents, "WMEventHandler")

		Catch To oException When oException.ErrorNo = 2071		&& user thrown
			* Throw to caller
			Throw oException
		
		Catch To oException
			* Set exception header details and throw to caller
			oException.UserValue = "Unhandled exception caught while removing the active FoxTab from our collection."
			Throw oException				

		EndTry

	EndFunc 
	
	* Remove all bindings
	* Pause function when user wants to avoid any interaction while testing their app
	Function RemoveBindings()

		Do while Type("This.FoxTabs[1]") = "O"
			This.WindowDestroy(Val(This.FoxTabs[1].hWnd))
		EndDo 
		
		UnBindWinEvents(0, 0, This.WindowsEvents, "WMEventHandler")
		
	EndFunc 	
	
	Function IsEvent(lpcWindowName as String) as Logical
		Local lcEventList, lcMethod, llEvent
		
		If Alen(This.aEventList) <= 1				
			* Event list from VFP Help File
			Text to lcEventList NoShow
Activate Event
AdjustObjectSize Event 
AfterBand Event 
AfterBuild Event 
AfterCloseTables Event 
AfterCursorAttach Event 
AfterCursorClose Event 
AfterCursorDetach Event 
AfterCursorFill Event 
AfterCursorRefresh Event 
AfterCursorUpdate Event 
AfterDelete Event 
AfterInsert Event 
AfterRecordRefresh Event 
AfterUpdate Event 
AfterDock Event 
AfterReport Event 
AfterRowColChange Event 
BeforeBand Event 
BeforeCursorAttach Event 
BeforeCursorClose Event 
BeforeCursorDetach Event 
BeforeCursorFill Event 
BeforeCursorRefresh Event 
BeforeCursorUpdate Event 
BeforeDelete Event 
BeforeInsert Event 
BeforeDock Event 
BeforeOpenTables Event 
BeforeRecordRefresh Event 
BeforeReport Event 
BeforeRowColChange Event 
BeforeUpdate Event 
Click Event 
dbc_Activate Event 
dbc_AfterAddTable Event 
dbc_AfterAppendProc Event 
dbc_AfterCloseTable Event 
dbc_AfterCopyProc Event 
dbc_AfterCreateConnection Event 
dbc_AfterCreateOffline Event 
dbc_AfterCreateTable Event 
dbc_AfterCreateView Event 
dbc_AfterDBGetProp Event 
dbc_AfterDBSetProp Event 
dbc_AfterDeleteConnection Event 
dbc_AfterDropOffline Event 
dbc_AfterDropTable Event 
dbc_AfterModifyConnection Event 
dbc_AfterModifyProc Event 
dbc_AfterModifyTable Event 
dbc_AfterModifyView Event 
dbc_AfterOpenTable Event 
dbc_AfterRemoveTable Event 
dbc_AfterRenameConnection Event 
dbc_AfterRenameTable Event 
dbc_AfterRenameView Event 
dbc_AfterValidateData Event 
dbc_BeforeAddTable Event 
dbc_BeforeAppendProc Event 
dbc_BeforeCloseTable Event 
dbc_BeforeCopyProc Event 
dbc_BeforeCreateConnection Event 
dbc_BeforeCreateOffline Event 
dbc_BeforeCreateTable Event 
dbc_BeforeCreateView Event 
dbc_BeforeDBGetProp Event 
dbc_BeforeDBSetProp Event 
dbc_BeforeDeleteConnection Event 
dbc_BeforeDropOffline Event 
dbc_BeforeDropTable Event 
dbc_BeforeModifyConnection Event 
dbc_BeforeModifyProc Event 
dbc_BeforeModifyTable Event 
dbc_BeforeModifyView Event 
dbc_BeforeOpenTable Event 
dbc_BeforeRemoveTable Event 
dbc_BeforeRenameConnection Event 
dbc_BeforeRenameTable Event 
dbc_BeforeRenameView Event 
dbc_BeforeValidateData Event 
dbc_CloseData Event 
dbc_Deactivate Event 
dbc_ModifyData Event 
dbc_OpenData Event 
dbc_PackData Event 
DblClick Event 
Deactivate Event 
Deleted Event 
Destroy Event 
DoCmd Method 
DownClick Event 
DragDrop Event 
DragOver Event 
DropDown Event 
Error Event
ErrorMessage Event 
EvaluateContents Event 
GotFocus Event 
Init Event 
InteractiveChange Event 
KeyPress Event 
Load Event 
LoadReport Event 
LostFocus Event 
Message Event 
MiddleClick Event 
MouseDown Event 
MouseEnter Event 
MouseLeave Event 
MouseMove Event 
MouseUp Event 
MouseWheel Event 
Moved Event 
OLECompleteDrag Event 
OLEDragOver Event 
OLEGiveFeedback Event 
OLESetData Event 
OLEStartDrag Event 
OnMoveItem Event 
Paint Event 
ProgrammaticChange Event 
QueryAddFile Event 
QueryModifyFile Event 
QueryNewFile Event 
QueryRemoveFile Event 
QueryRunFile Event 
QueryUnload Event 
RangeHigh Event 
RangeLow Event 
ReadActivate Event 
ReadDeactivate Event 
ReadShow Event 
ReadValid Event 
ReadWhen Event 
Resize Event 
RightClick Event 
SCCInit Event 
SCCDestroy Event 
Scrolled Event 
Timer Event 
UIEnable Event 
UnDock Event 
Unload Event 
UnloadReport Event 
UpClick Event 
Valid Event 
When Event 
			EndText 
			ALines(This.aEventList, Lower(Strtran(lcEventList, " Event", "")), 1)
		EndIf 
		lcMethod = Lower(GetWordNum(lpcWindowName, GetWordCount(lpcWindowName, "."), "."))
		* Remove [Read Only]
		If "[read only]" $ lcMethod 
			lcMethod = Strtran(lcMethod, "[read only]", "")
		EndIf 
		* Asterisk in view parent code window
		If "*" $ lcMethod 
			lcMethod = Strtran(lcMethod, "*", "")
		EndIf 		
		llEvent = (Ascan(This.aEventList, lcMethod, 1, 0, 0, 2 + 4) > 0)
		Return llEvent
	EndFunc

	* _____________________________________________________________
	*
	* Define event delegates

	Function AddFoxTabEvent(oFoxTab As Object)
		* Event interface
	EndFunc 

	Function RemoveFoxTabEvent(oFoxTab As Object)
		* Event interface
	EndFunc 

	Function GotFocusEvent(oFoxTab As Object)
		* Event interface
	EndFunc 

	Function OnChangeEvent(oFoxTab As Object)
		* Event interface
	EndFunc 

EndDefine

* _________________________________________________________________
*
* FoxTab class
*
Define Class FoxTab As Custom

	* Define class properties
	hWnd 			= ""
	WindowName 		= ""
	ContentType		= ""
	AssociatedIcon	= ""

	* Define class members	
	Function WindowName_Assign(lpcWindowName As String)
	
		* Set the content type derived from the window name
		This.ContentType = This.GetContentType(lpcWindowName)
				
		* Finally, set the property value
		This.WindowName = lpcWindowName 
		
	EndFunc 

	Function ContentType_Assign(lpcContentType As String)
	
		* Set the associated icon that corresponds to this content type
		This.AssociatedIcon = This.GetAssociatedIcon(lpcContentType)
		
		* Finally, set the property value
		This.ContentType = lpcContentType 
		
	EndFunc
	
	Function GetContentType(lpcWindowName As String) As String

		Local lcContentType As String, lnWindowType as Integer

		lnWindowType = This.GetWindowType(Val(This.hWnd))
		
		Do Case
			Case Empty(lpcWindowName)	&& should not occur
				lcContentType = "VFP"			
		
			Case "project manager" $ Lower(lpcWindowName)
				lcContentType = "PJX"

			Case "form designer" $ Lower(lpcWindowName)
				lcContentType = "SCX"
	
			Case "class designer" $ Lower(lpcWindowName) ;
				Or "class browser" $ Lower(lpcWindowName)
				lcContentType = "VCX"

			Case "database designer" $ Lower(lpcWindowName)
				lcContentType = "DBC"

			Case "table designer" $ Lower(lpcWindowName)
				lcContentType = "DBF"			
				
			Case "report designer" $ Lower(lpcWindowName)
				lcContentType = "FRX"			
				
			Case "menu designer" $ Lower(lpcWindowName)
				lcContentType = "MNX"			
				
			Case "label designer" $ Lower(lpcWindowName)
				lcContentType = "LBX"			
				
			Case "query designer" $ Lower(lpcWindowName)
				lcContentType = "QPX"		

			Case "view designer" $ Lower(lpcWindowName)
				lcContentType = "VIEW"					
				
			Case "data environment" $ Lower(lpcWindowName)
				lcContentType = "DATAENV"			

			Case This.IsForm(Val(This.hwnd))
				lcContentType = "FORM"			

			Case This.IsUsed(lpcWindowName)
				lcContentType = "DBF"			

			Case lnWindowType = EDPROGRAM
				* 1 – Program file (MODIFY COMMAND)
				lcContentType = "PRG"
				
			Case lnWindowType = EDFILE
				* 2 – Text Editor (MODIFY FILE)
				lcContentType = "TXT"
				
			Case lnWindowType = EDMEMO
				* 3 - Memo field
				lcContentType = "MEMO"				

			Case lnWindowType = EDQUERY
				* 6 - Query
				lcContentType = "QPX"				
				
			Case lnWindowType = EDMENU
				* 8 - Menu
				lcContentType = "MNX"	

			Case lnWindowType = EDVIEW
				* 9 - View
				lcContentType = "VIEW"	
				
			Case InList(lnWindowType, EDSNIP, EDTEXT)
				* 10 – Method code edit window of the Class or Form Designer
				* 11 - View parent code of method
				If oFoxTabs.FoxTabsManager.IsEvent(lpcWindowName)
					lcContentType = "EVENT"
				Else
					lcContentType = "METHOD"
				EndIf 
				
			Case lnWindowType = EDPROC
				* 12 - Stored procedure in a DBC (MODIFY PROCEDURE)
				lcContentType = "CUR"

			Otherwise
				* Check if the window name contains the name of the file
				lpcWindowName = STRTRAN(lpcWindowName, ' ', '')
				lpcWindowName = STRTRAN(lpcWindowName, '*', '')
				
				If At(".", lpcWindowName) > 0 And Len(JustExt(lpcWindowName)) <= 3
					lcContentType = Upper(JustExt(lpcWindowName))
				Else
					* Default to VFP type
					lcContentType = "VFP"
				EndIf 
				
		EndCase 

		Return lcContentType 
	
	EndFunc  	
	
	Function GetWindowType(hWnd As Integer) As Integer

		Local lnWHandle as Integer, lnWindowType as Integer
		Local Array laEnv[25]	

		* Get editor window type using FoxTools
		* Editor Session – The editor session is as follows:
		* 0 – Command Window
		* 1 – Program file (MODIFY COMMAND)
		* 2 – Text Editor (MODIFY FILE)
		* 3 - Memo field
		* 8 – Menu code edit window
		* 10 – Method code edit window of the Class or Form Designer
		* 11 - View parent code of method
		* 12 – Stored procedure in a DBC (MODIFY PROCEDURE)
		If Not 'FOXTOOLS.FLL' $ Upper (Set ('Library'))
			Set Library To (Home() + 'FoxTools.Fll') Additive
		EndIf
		lnWHandle = Sys(2326, hWnd)
		If _EdGetEnv(lnWHandle, @laEnv) = 1
			lnWindowType = laEnv[25]
		Else
			* Not editor window
			lnWindowType = 0
		EndIf 

		Return lnWindowType		
	EndFunc	
	
	Function GetAssociatedIcon(lpcContentType As String) As String

		Local lcAssociatedIcon As String
		
		* Set the associated icon that corresponds to this content type
		Do Case
			Case lpcContentType = "VCX"
				lcAssociatedIcon = "icoClass"
				
			Case lpcContentType = "CUR"
				lcAssociatedIcon = "icoCursor"
	
			Case lpcContentType = "DBC"
				lcAssociatedIcon = "icoDatabase"
	
			Case lpcContentType = "SCX"
				lcAssociatedIcon = "icoForm"
	
			Case lpcContentType = "MNX"
				lcAssociatedIcon = "icoMenu"
	
			Case lpcContentType = "PRG"
				lcAssociatedIcon = "icoProgram"
	
			Case lpcContentType = "PJX"
				lcAssociatedIcon = "icoProject"

			Case lpcContentType = "FRX"
				lcAssociatedIcon = "icoReport"
	
			Case lpcContentType = "SLX"
				lcAssociatedIcon = "icoSolution"
	
			Case lpcContentType = "DBF"
				lcAssociatedIcon = "icoTable"
	
			Case InList(lpcContentType, "TXT", "H", "INI", "LOG")
				lcAssociatedIcon = "icoText"
	
			Case InList(lpcContentType, "XML", "XSD")
				lcAssociatedIcon = "icoXml"
	
			Case InList(lpcContentType, "XSL", "XSLT")
				lcAssociatedIcon = "icoXsl"
				
			Case InList(lpcContentType, "QPX", "VIEW")
				lcAssociatedIcon = "icoQuery"				
	
			Case lpcContentType = "METHOD"
				lcAssociatedIcon = "icoMethod"

			Case lpcContentType = "EVENT"
				lcAssociatedIcon = "icoEvent"

			Case lpcContentType = "DATAENV"
				lcAssociatedIcon = "icoDataEnvironment"

			Case lpcContentType = "MEMO"
				lcAssociatedIcon = "icoEdit"

			Case lpcContentType = "FORM"
				* Running form, not form designer
				lcAssociatedIcon = "icoFormRun"

			Otherwise
				lcAssociatedIcon = "icoVfp"
				
		EndCase 
		
		Return lcAssociatedIcon 
	
	EndFunc
	
	Function IsUsed(lpcWindowName as String) as Logical
		* Check all datasessions to see if name is used
		Local Array laSessions[1]
		Local lnSession, llUsed

		Try 			
			llUsed = .f.
			Asessions(laSessions)
			For Each lnSession in laSessions
				Set Datasession To (lnSession)
				If Used(lpcWindowName)
					llUsed = .t.
					Exit 
				EndIf
			EndFor 
		Finally
			Set Datasession To (oFoxTabs.DataSession.DataSessionID)  
		EndTry		
		Return llUsed
	EndFunc
	
	Function IsForm(hWnd As Integer) As Logical
		* Returns .T. if window is running form (not form designer)
		Local llForm, lnFormCount, lnForm
		llForm = .f.
		lnFormCount = _Screen.FormCount
		For lnForm = 1 to lnFormCount
			Try
				If _Screen.Forms(lnForm).hWnd = hWnd
					llForm = .t.
					Exit
				EndIf 
			Catch
				* Ignore errors
			EndTry
		EndFor 
		Return llForm
	EndFunc 
	
	Function GetFormIcon(hWnd As Integer) As Logical
		* Returns .T. if window is running form (not form designer)
		Local lcIcon, lnFormCount, lnForm
		lcIcon = ""
		lnFormCount = _Screen.FormCount
		For lnForm = 1 to lnFormCount
			Try
				If _Screen.Forms(lnForm).hWnd = hWnd
					lcIcon = _Screen.Forms(lnForm).Icon
					Exit
				EndIf 
			Catch
				* Ignore errors
			EndTry
		EndFor 
		Return lcIcon
	EndFunc 
EndDefine 

* _________________________________________________________________
*
* Windows Message Events Handler
*
Define Class FoxTabsEventHandler As Custom 

	* _____________________________________________________________
	*
	* Define class properties
	
	PrevWndFunc	= 0
	LastHWnd = 0
	
	* _____________________________________________________________
	*
	* Define class members	
	Function Init()
		
		IF !('FoxTabsDeclareAPI' $ SET( 'Procedure' ))
			SET PROCEDURE TO FoxTabsDeclareAPI ADDITIVE
		ENDIF

		* Store handle for use in CallWindowProc
		This.PrevWndFunc = GetWindowLong(_Vfp.hWnd, GWL_WNDPROC)

	EndFunc
	
	Function Destroy()
	
		* Unbind all windows message events
		UnBindWinEvents(0, 0, This, "WMEventHandler")
		
	EndFunc 
		
	Function WMEventHandler(hWnd As Integer, Msg As Integer, wParam As Integer, lParam As Integer)

		Local oException As Exception 
		Local lnReturn As Integer
		Local lcWindowTitle, lcParentWindow

		lnReturn = 0

		* In some scenarios, the hWnd and/or Msg variables do not exist.
		* I don't see how that's possible, given that they are defined above, but it happens.
		* See http://www.codeplex.com/VFPX/WorkItem/View.aspx?WorkItemId=20989 for an example.
		* My hope is that this code will prevent other scenarios that cause C5s.
		If Type("hWnd") <> "N" or Type("Msg") <> "N"
			Return 0
		EndIf 

		Try
			lcWindowTitle = Lower(This.Parent.GetWindowTitle(hWnd))
			* Handle each windows message case
			Do Case	
				*CASE INLIST(lParam, 1235848, 1236368, 1236268, 1238376, 1238848, 1234504, 1235024, 1237032, 1236884, 1235540, 1234504)
					* Don't do anything if these paramaters are passed, they refer to compile dialog events
					* This was the nasty workaround - we've left the code in here for laughs for now
					
				Case Type('This.Parent.Parent') <> 'O'
					* Don't do anything	- the simple Compile error work around
					* If we can't reference our parent's parent, then something weird is happening
					* eg we are in the middle of a compile and VFP has totally shelled out to a 
					* different memory space which can't even recognise our parent
					* so just let it fall through with out trying to bind to the events
				
				Case lcWindowTitle = "work area"
					* Work around issue with Work Area Properties window (Browse then select Table->Properties from the menu)
					* Clicking on a button on this screen that opens another dialog can cause and Out of Memory error.
					* In my testing, this only happens on 64-bit Windows when -C (config file) command-line 
					*	switch is used to open VFP. 
					* The fix is to turn off WM_CREATE binding while the window is open, and rebind when it closes.
					* See http://vfpx.codeplex.com/workitem/30286
					Do Case 
					Case Msg = WM_CREATE
						UnBindWinEvents(0, WM_CREATE, This, "WMEventHandler")
						BindWinEvent(hWnd, WM_DESTROY, This, "WMEventHandler", 4)
					Case Msg = WM_DESTROY
						BindWinEvent(0, WM_CREATE, This, "WMEventHandler")	
						UnBindWinEvents(hWnd, WM_DESTROY, This, "WMEventHandler")
					Otherwise 
						* Not expecting other events, but do nothing if they fire
					EndCase 
				
				Case Msg = WM_CREATE

					*JAL* VFP crashes if bound to WM_CREATE when Call Stack window is opened manually after 
					*	a program is suspended. This code temporarily unbinds WM_CREATE and turns it back on 
					*	in the WM_ACTIVATE event below.
					* See http://www.codeplex.com/VFPX/WorkItem/View.aspx?WorkItemId=19307
					If lcWindowTitle = "call stack" and Program(0) <> "FOXTABS"
						UnBindWinEvents(0, WM_CREATE, This, "WMEventHandler")
						BindWinEvent(0, WM_ACTIVATE, This, "WMEventHandler")
					EndIf 
				
					* Raise the window create event
					RaiseEvent(This, "WindowCreateEvent", hWnd)
					
					* Bind to these events so we can add it to our collection
					BindWinEvent(hWnd, WM_SHOWWINDOW, This, "WMEventHandler", 4)
					BindWinEvent(hWnd, WM_SETTEXT, This, "WMEventHandler", 4)
					
				Case Msg = WM_ACTIVATE
					* Rebind WM_CREATE event after unbound above
					UnBindWinEvents(0, WM_ACTIVATE, This, "WMEventHandler")
					BindWinEvent(0, WM_CREATE, This, "WMEventHandler")	

				Case Msg = WM_SHOWWINDOW

					If wParam # 0
						* Raise the window show event
						RaiseEvent(This, "WindowShowEvent", hWnd)
					EndIf 
					
					* Unbind to the this event as we do not require it any more
					* Unbinding this can cause issues similar to http://www.codeplex.com/VFPX/WorkItem/View.aspx?WorkItemId=19330
					* Doesn't seem to cause any harm to leave event bound.  
					* UnBindWinEvents(hWnd, WM_SHOWWINDOW, This, "WMEventHandler")
					
				Case InList(Msg, WM_SETFOCUS, WM_WINDOWPOSCHANGED, WM_CHILDACTIVATE)
					* Raise the window set focus event 
					* Only raise when window is different than last time, to avoid flicker in toolbar
					If hWnd <> This.LastHWnd
						This.LastHWnd = hWnd			
						RaiseEvent(This, "WindowSetFocusEvent", hWnd)
					EndIf 

				Case Msg = WM_SETTEXT
					* Raise the window set text event
					RaiseEvent(This, "WindowSetTextEvent", hWnd)
					
				Case Msg = WM_DESTROY
					* Raise the window destroy event
					RaiseEvent(This, "WindowDestroyEvent", hWnd)
					
			EndCase
			
		Catch To oException
			* Raise error event
			
			* log the event call - used for debugging the compile dialog error
			* Temporary code for catching the compile crash lParam
			* Again, just left in for amusement value for now
			* lcLog = CHR(13) + TRANSFORM(DATETIME()) + ' - ' + TRANSFORM(hWnd) + ' - ' + TRANSFORM(Msg) + ' - ' + TRANSFORM(wParam) + ' - ' + TRANSFORM(lParam) + ' - Crash '
			* = STRTOFILE( lcLog, 'c:\foxtabscrashlog.txt', 1)

			If Type('This.Parent.Parent') = 'O' and PemStatus(This.Parent.Parent, "LogError", 5)
				RaiseEvent(This.Parent.Parent, "LogError", oException, "Exception caught while handling windows message event." + Chr(13) + " hWnd:" + Transform(hWnd, "@x0") + " Msg:" + Transform(Msg, "@x0") + " wParam:" + Transform(wParam, "@x0") + " lParam:" + Transform(lParam, "@x0"))
			EndIf
				
		Finally 
			* Must pass the message on
			lnReturn = CallWindowProc(This.PrevWndFunc, hWnd, Msg, wParam, lParam)
			
		EndTry

		Return lnReturn 
		
	EndFunc 
	
	Function SetBindings(hWnd As Integer)
	
		* Setup event bindings for this window
		BindWinEvent(hWnd, WM_DESTROY, This, "WMEventHandler", 4)
		BindWinEvent(hWnd, WM_SETTEXT, This, "WMEventHandler", 4)
		BindWinEvent(hWnd, WM_SETFOCUS, This, "WMEventHandler", 4)
		* Some IDE Windows don't have WM_SETFOCUS event, so use other events
		If InList(Lower(This.Parent.GetWindowTitle(hWnd)), "project manager", "properties", "class designer", "form designer")
			BindWinEvent(hWnd, WM_WINDOWPOSCHANGED, This, "WMEventHandler", 4)
		EndIf 

	EndFunc 
	
	* _____________________________________________________________
	*
	* Define event delegates
	
	Function WindowCreateEvent(hWnd As Integer)
		* Event interface
	EndFunc 

	Function WindowShowEvent(hWnd As Integer)
		* Event interface
	EndFunc 

	Function WindowDestroyEvent(hWnd As Integer)
		* Event interface
	EndFunc 

	Function WindowSetFocusEvent(hWnd As Integer)
		* Event interface
	EndFunc 

	Function WindowSetTextEvent(hWnd As Integer)
		* Event interface
	EndFunc 

	* _____________________________________________________________

EndDefine

* _________________________________________________________________
