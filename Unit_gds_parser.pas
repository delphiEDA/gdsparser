unit Unit_gds_parser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Unit_GDSClasses,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls;

type
  Tfrm_simple_gdsparser = class(TForm)
    mmo_debug: TMemo;
    pnl1: TPanel;
    btn_LoadGDS_FILE: TBitBtn;
    dlgOpenGDS: TOpenDialog;
    statGDSBrowser: TStatusBar;
    procedure btn_LoadGDS_FILEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FTokenList: TTokenList;
  end;

var
  frm_simple_gdsparser: Tfrm_simple_gdsparser;

implementation

{$R *.dfm}

procedure Tfrm_simple_gdsparser.btn_LoadGDS_FILEClick(Sender: TObject);
var
  FILENAME: String;
  i, j: integer;
  LINESTR: String;
  GDSToken: TGDSToken;

begin

  if dlgOpenGDS.execute then
  begin

    FILENAME := dlgOpenGDS.FILENAME;

    statGDSBrowser.SimpleText := ' start browsing ' + FILENAME;

    FTokenList.parseGDSfile(FILENAME);

    statGDSBrowser.SimpleText := ' start show data ' + FILENAME;

    for j := 0 to FTokenList.count - 1 do
    begin

      GDSToken := FTokenList.Items[j];

      LINESTR := ' ';
      for i := 0 to high(GDSToken.Data.BufferBytes) do
      begin
        LINESTR := LINESTR + ByteToHex(GDSToken.Data.BufferBytes[i]) + ' ';
      end;

      mmo_debug.Lines.Add('');

      mmo_debug.Lines.Add('type ' + ByteToHex(GDSToken.ID));

      mmo_debug.Lines.Add('name ' + GDSToken.Name);

      mmo_debug.Lines.Add
        ('len  ' + ByteToHex(Length(GDSToken.Data.BufferBytes)));

      mmo_debug.Lines.Add('data type  ' + GDSToken.GDSDataType);

      mmo_debug.Lines.Add('data#row ' + LINESTR);

      mmo_debug.Lines.Add('data#str ' + GDSToken.DataString);




      statGDSBrowser.SimpleText := ' writing TokenCount ' + InTToStr(j) +
        ' out of ' + InTToStr(FTokenList.count);

    end;

    statGDSBrowser.SimpleText := ' end show ' + FILENAME + ' TokenCount ' +
      InTToStr(FTokenList.count);
  end;
end;

procedure Tfrm_simple_gdsparser.FormCreate(Sender: TObject);
begin
  FTokenList := TTokenList.Create;
end;

end.
