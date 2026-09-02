[Setup]
AppName=Star Electric ERP
AppVersion={#MyAppVersion}
AppPublisher=Nodetologic IT Solutions
DefaultDirName={autopf}\StarElectricERP
DisableProgramGroupPage=yes
OutputDir=..\build\windows\installer
OutputBaseFilename=StarElectricERP-Setup-{#MyAppVersion}
SetupIconFile=runner\resources\app_icon.ico
Compression=lzma
SolidCompression=no
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\Star Electric ERP"; Filename: "{app}\starelectricerp.exe"
Name: "{autodesktop}\Star Electric ERP"; Filename: "{app}\starelectricerp.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\starelectricerp.exe"; Description: "{cm:LaunchProgram,Star Electric ERP}"; Flags: nowait postinstall skipifsilent
