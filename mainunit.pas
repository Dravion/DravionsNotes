unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBGrids, DBCtrls, Menus, {$IFDEF WINDOWS} Windows {$ENDIF}, LazUTF8;

type

  { TMainForm }

  TMainForm = class(TForm)
    bt_save: TButton;
    bt_search: TButton;
    bt_add: TButton;
    bt_edit: TButton;
    bt_close: TButton;
    bt_delete: TButton;
    ed_search_field: TComboBox;
    DataSource: TDataSource;
    DBGrid1: TDBGrid;
    ed_search: TEdit;
    lb_search_for: TLabel;
    lb_search_field: TLabel;
    DBConnection: TSQLite3Connection;
    SQLQuery: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    procedure bt_addClick(Sender: TObject);
    procedure bt_closeClick(Sender: TObject);
    procedure bt_editClick(Sender: TObject);
    procedure bt_saveClick(Sender: TObject);
    procedure bt_searchClick(Sender: TObject);
    procedure bt_deleteClick(Sender: TObject);
    procedure ed_search_fieldSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private

  public

  end;

var
  MainForm: TMainForm;

  search_field_global : string;

implementation

{$R *.lfm}

{ TMainForm }

function LCIDToLanguageName(LCID: LCID): string;
var
  Buffer: array[0..255] of Char;
begin
  FillChar(Buffer, SizeOf(Buffer), 0); // Initialisiere den Puffer mit Nullen
  if GetLocaleInfo(LCID, LOCALE_SENGLANGUAGE, Buffer, Length(Buffer)) > 0 then
    Result := Buffer
  else
    Result := '';
end;

function GetSystemLanguage: String;
begin
  {$IFDEF UNIX}
    Result := GetEnvironmentVariable('LANG');
  {$ENDIF}
  {$IFDEF WINDOWS}
    Result := LCIDToLanguageName(GetSystemDefaultLCID);
  {$ENDIF}
end;

procedure TMainForm.bt_saveClick(Sender: TObject);
begin
  SQLQuery.ApplyUpdates();
  SQLTransaction.Commit;
  SQLQuery.Active := False;
  SQLQuery.SQL.Clear;
  SQLQuery.SQL.Add('SELECT Name, Description, Datetime FROM Notes');
  SQLQuery.Active := True;
end;

procedure TMainForm.bt_addClick(Sender: TObject);
begin
  SQLQuery.Insert;
end;

procedure TMainForm.bt_closeClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.bt_editClick(Sender: TObject);
begin
  SQLQuery.Edit;
end;

procedure TMainForm.bt_searchClick(Sender: TObject);

 var search_term : string;

begin
  SQLQuery.Active := False;
  SQLQuery.SQL.Clear;

  search_term := MainForm.ed_search.Text;
  SQLQuery.SQL.Add('SELECT name, description, datetime FROM Notes WHERE '+ search_field_global +' LIKE ''%'+ search_term +'%''');
  SQLQuery.Active := True;

end;

procedure TMainForm.bt_deleteClick(Sender: TObject);

   var nid : String;

begin

    nid := SQLQuery.FieldByName('NID').AsString;
    SQLQuery.Active := False;
    DBConnection.ExecuteDirect('DELETE FROM Notes WHERE Nid = '+ nid +'');
    SQLQuery.Active := Active;
    SQLQuery.ApplyUpdates();
    bt_save.Click();

end;

procedure TMainForm.ed_search_fieldSelect(Sender: TObject);
begin
      search_field_global :=  MainForm.ed_search_field.Text;
      bt_search.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);

 var AppDir : String;
     i: Integer;

begin
  MainForm.Caption :=  'Dravion''s Notes (' +GetSystemLanguage() +')';
  DBConnection.DatabaseName := '';
  DBConnection.Connected := False;
  SQLTransaction.Active := False;
  SQLQuery.Active := False;
  DataSource.Enabled:= False;

  AppDir := extractfilepath(Application.ExeName);

  SQLQuery.SQL.Clear;
  DBConnection.DatabaseName := AppDir + 'database.s3db';
  SQLQuery.SQL.Add('SELECT Nid, Name, Description, Datetime FROM Notes');
  DBConnection.Connected := True;
  SQLTransaction.Active := True;
  SQLQuery.Active := True;

  MainForm.ed_search_field.Items.Clear;

  // iterates db fields
  for i := 0 to SQLQuery.FieldDefs.Count - 1 do
  begin
    MainForm.ed_search_field.Items.Add(SQLQuery.FieldDefs[i].Name);
  end;

  DataSource.Enabled := True;



end;


end.

