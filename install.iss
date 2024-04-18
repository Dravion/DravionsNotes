[Setup]
AppName=Dravion's Notes
AppVersion=1.0
AppPublisher=Dravionsoftware
AppPublisherURL=https://www.dravionosoftware.com
DefaultDirName={pf}\DravionsNotes
DefaultGroupName=Dravion's Notes
OutputDir=Output
OutputBaseFilename=DravionsNote_v1.0
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
ChangesAssociations=yes
SetupIconFile=Icon.ico



[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "DravionsNotes.exe"; DestDir: "{app}"
Source: "Icon.ico"; DestDir: "{app}"
Source: "sqlite3.dll"; DestDir: "{app}"
Source: "database.s3db"; DestDir: "{app}"
Source: "License.rtf"; DestDir: "{app}"

[Icons]
Name: "{commondesktop}\Dravion's Notes"; Filename: "{app}\DravionsNotes.exe"; IconFilename: "{app}\Icon.ico"

[Run]
Filename: "{app}\License.rtf"; Flags: shellexec postinstall runhidden
Filename: "{app}\DravionsNotes.exe"; Flags: postinstall runhidden runascurrentuser

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*.*"; 

[UninstallRun]
Filename: "{app}\Uninstall.exe"; Flags: runhidden
