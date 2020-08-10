!include "MUI2.nsh"

!define BINARY_INPUT_PATH "..\build\Source\ui_qt\Release"

!searchparse /file ../Source/AppDef.h '#define APP_VERSIONSTR _T("' APP_VERSION '")'

; The name of the installer
Name "Play! v${APP_VERSION}"

; The file to write
OutFile "Play-${APP_VERSION}-32.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Play

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\NSIS_Play" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

;!insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
 
!insertmacro MUI_LANGUAGE "English"
;--------------------------------

; Pages

;Page components
;Page directory
;Page instfiles

;UninstPage uninstConfirm
;UninstPage instfiles

;--------------------------------

!define REG_UNINSTALL "Software\Microsoft\Windows\CurrentVersion\Uninstall\Play"

; The stuff to install
Section "Play! (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  CreateDirectory $INSTDIR\platforms
  CreateDirectory $INSTDIR\styles
  CreateDirectory $INSTDIR\imageformats
  
  ; Put file there
  File "${BINARY_INPUT_PATH}\Play.exe"
  File "${BINARY_INPUT_PATH}\Qt5Core.dll"
  File "${BINARY_INPUT_PATH}\Qt5Gui.dll"
  File "${BINARY_INPUT_PATH}\Qt5Widgets.dll"
  File /oname=platforms\qwindows.dll "${BINARY_INPUT_PATH}\platforms\qwindows.dll"
  File /oname=styles\qwindowsvistastyle.dll "${BINARY_INPUT_PATH}\styles\qwindowsvistastyle.dll"
  File /oname=imageformats\qjpeg.dll "${BINARY_INPUT_PATH}\imageformats\qjpeg.dll"
  File "..\Readme.html"
  File "..\Changelog.html"
  File "..\Patches.xml"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\NSIS_Play "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayName" "Play!"
  WriteRegStr HKLM "${REG_UNINSTALL}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "${REG_UNINSTALL}" "NoModify" 1
  WriteRegDWORD HKLM "${REG_UNINSTALL}" "NoRepair" 1
  WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayIcon" '"$INSTDIR\Play.exe"'
  WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayVersion" "${APP_VERSION}"
  WriteUninstaller "uninstall.exe"
  
SectionEnd

!include "vcredist2015_x86.nsh"

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Play!"
  CreateShortCut "$SMPROGRAMS\Play!\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\Play!\Play!.lnk" "$INSTDIR\Play.exe" "" "$INSTDIR\Play.exe" 0
  CreateShortCut "$SMPROGRAMS\Play!\Read Me.lnk" "$INSTDIR\Readme.html" "" "$INSTDIR\Readme.html" 0
  CreateShortCut "$SMPROGRAMS\Play!\Change Log.lnk" "$INSTDIR\changelog.html" "" "$INSTDIR\changelog.html" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "${REG_UNINSTALL}"
  DeleteRegKey HKLM SOFTWARE\NSIS_Play
  
  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Play!\*.*"
  
  ; Remove files and uninstaller
  Delete $INSTDIR\Play.exe
  Delete $INSTDIR\Qt5Core.dll
  Delete $INSTDIR\Qt5Gui.dll
  Delete $INSTDIR\Qt5Widgets.dll
  Delete $INSTDIR\platforms\qwindows.dll
  Delete $INSTDIR\styles\qwindowsvistastyle.dll
  Delete $INSTDIR\imageformats\qjpeg.dll
  Delete $INSTDIR\Readme.html
  Delete $INSTDIR\Changelog.html
  Delete $INSTDIR\Patches.xml
  Delete $INSTDIR\uninstall.exe
  
  ; Remove directories used
  RMDir $INSTDIR\platforms
  RMDir $INSTDIR\styles
  RMDir $INSTDIR\imageformats
  RMDir "$SMPROGRAMS\Play!"
  RMDir "$INSTDIR"

SectionEnd
