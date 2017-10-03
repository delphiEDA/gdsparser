unit Unit_gds_parser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Unit_ParseGDSII,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  Tfrm_simple_gds_parser1 = class(TForm)
    mmo_debug: TMemo;
    pnl1: TPanel;
    btn_LoadGDS_FILE: TBitBtn;
    dlgOpenGDS: TOpenDialog;
    procedure btn_LoadGDS_FILEClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_simple_gds_parser1: Tfrm_simple_gds_parser1;

implementation

{$R *.dfm}

procedure Tfrm_simple_gds_parser1.btn_LoadGDS_FILEClick(Sender: TObject);
var
  FILENAME: String;
  fs: TFileStream;
  ReadBuffer: TReadBuffer;
  RecordType, RecordLength: word;
  mystreamposition: integer;
  i: integer;
  LINESTR: sTRING;
  GDSToken: TGDSToken;

begin

  if dlgOpenGDS.execute then
  begin

    mystreamposition := 1;

    FILENAME := dlgOpenGDS.FILENAME;

    fs := TFileStream.Create(FILENAME, fmOpenRead);

    while mystreamposition < fs.size do
    begin

      RecordLength := GetRecordlength(fs, mystreamposition);
      if RecordLength = 0 then
      begin

        Break;
      end
      else
      begin

        GDSToken := TGDSToken.Create;
        try

          GetTokenInfo(fs, mystreamposition, GDSToken.FID, GDSToken.FDataType);

          RecordLength := RecordLength - 2;

          ReadDataBytes(fs, GDSToken.FData, RecordLength, mystreamposition);

          LINESTR := ' ';

          for i := 0 to high(GDSToken.Data.BufferBytes) do
          begin
            LINESTR := LINESTR + ByteToHex(GDSToken.Data.BufferBytes[i]) + ' ';
          end;

          mmo_debug.Lines.Add('');

          mmo_debug.Lines.Add('type ' + ByteToHex(GDSToken.ID));

          mmo_debug.Lines.Add('name ' + GDSToken.Name);

          mmo_debug.Lines.Add('len  ' + ByteToHex(RecordLength));

          mmo_debug.Lines.Add('data type  ' + GDSToken.GDSDataType);

          mmo_debug.Lines.Add('data ' + LINESTR);

          ReadBuffer.clear;

        finally
          GDSToken.Free;
        end;

      end;
    end;
  end;
end;

end.
