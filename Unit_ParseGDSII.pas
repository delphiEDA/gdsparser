unit Unit_ParseGDSII;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

const
  gdsrecordtypes = 54;

type
  TGDSTokenName = record
    Name: String;
    ID: Word;
  end;

type
  TGDSTokenTypes = array [1 .. gdsrecordtypes] of TGDSTokenName;
  TGDSDataType = array [0 .. 6] of TGDSTokenName;

const
  GDSTokens: TGDSTokenTypes = ((name: 'gds_HEADER'; ID: $0002),
    (name: 'gds_BGNLIB'; ID: $0102), (name: 'gds_LIBNAME'; ID: $0206),
    (name: 'gds_UNITS'; ID: $0305), (name: 'gds_ENDLIB'; ID: $0400),
    (name: 'gds_BGNSTR'; ID: $0502), (name: 'gds_STRNAME'; ID: $0606),
    (name: 'gds_ENDSTR'; ID: $0700), (name: 'gds_BOUNDARY'; ID: $0800),
    (name: 'gds_PATH'; ID: $0900), (name: 'gds_SREF'; ID: $0A00),
    (name: 'gds_AREF'; ID: $0B00), (name: 'gds_TEXT'; ID: $0C00),
    (name: 'gds_LAYER'; ID: $0D02), (name: 'gds_DATATYPE'; ID: $0E02),
    (name: 'gds_WIDTH'; ID: $0F03), (name: 'gds_XY'; ID: $1003),
    (name: 'gds_ENDEL'; ID: $1100), (name: 'gds_SNAME'; ID: $1206),
    (name: 'gds_COLROW'; ID: $1302), (name: 'gds_TEXTNODE'; ID: $1400),
    (name: 'gds_NODE'; ID: $1500), (name: 'gds_TEXTTYPE'; ID: $1602),
    (name: 'gds_PRESENTATION'; ID: $1701), (name: 'gds_STRING'; ID: $1906),
    (name: 'gds_STRANS'; ID: $1A01), (name: 'gds_MAG'; ID: $1B05),
    (name: 'gds_ANGLE'; ID: $1C05), (name: 'gds_REFLIBS'; ID: $1F06),
    (name: 'gds_FONTS'; ID: $2006), (name: 'gds_PATHTYPE'; ID: $2102),
    (name: 'gds_GENERATIONS'; ID: $2202), (name: 'gds_ATTRTABLE'; ID: $2306),
    (name: 'gds_STYPTABLE'; ID: $2406), (name: 'gds_STRTYPE'; ID: $2502),
    (name: 'gds_ELFLAGS'; ID: $2601), (name: 'gds_ELKEY'; ID: $2703),
    (name: 'gds_NODETYPE'; ID: $2A02), (name: 'gds_PROPATTR'; ID: $2B02),
    (name: 'gds_PROPVALUE'; ID: $2C06), (name: 'gds_BOX'; ID: $2D00),
    (name: 'gds_BOXTYPE'; ID: $2E02), (name: 'gds_PLEX'; ID: $2F03),
    (name: 'gds_BGNEXTN'; ID: $3003), (name: 'gds_ENDEXTN'; ID: $3103),
    (name: 'gds_TAPENUM'; ID: $3202), (name: 'gds_TAPECODE'; ID: $3302),
    (name: 'gds_STRCLASS'; ID: $3401), (name: 'gds_RESERVED'; ID: $3503),
    (name: 'gds_FORMAT'; ID: $3602), (name: 'gds_MASK'; ID: $3706),
    (name: 'gds_ENDMASKS'; ID: $3800), (name: 'gds_LIBDIRSIZE'; ID: $3902),
    (name: 'gds_SRFNAME'; ID: $3A06));

const
  GDSDataTypes: TGDSDataType = ((name: 'gds_none'; ID: $0000),
    (name: 'gds_BITARRAY'; ID: $0001), (name: 'gds_int16'; ID: $0002),
    (name: 'gds_int32'; ID: $0003), (name: 'gds_real'; ID: $0004),
    (name: 'gds_double'; ID: $0005), (name: 'gds_string'; ID: $0006));

type

  TReadBuffer = record
    BufferBytes: array of Byte;
    procedure clear;
  end;

type


  TRecordLength = record
    B1, B2: Byte;
    procedure clear;
  end;

type
  TRecordType = record
    B1, B2: Byte;
    procedure clear;
  end;

Type

  TGDSToken = class

  private

  public

    FData: TReadBuffer;

    FID: Word;

    FDataType: Word;

    function getName: String;

    function getDataType: String;

    property ID: Word read FID write FID;

    property DataType: Word read FDataType write FDataType;

    property Data: TReadBuffer read FData write FData;

    property Name: String read getName;

    property GDSDataType: String read getDataType;

  end;

function GetRecordlength(var fs: TFileStream;
  var mystreamposition: integer): Word;

function GetTokenInfo(var fs: TFileStream; var mystreamposition: integer;
  var TokenType: Word; var TokenDataType: Word): boolean;

function GetWord(B1, B2: Byte): Word;

function ByteToHex(InByte: Byte): shortstring;

procedure ReadDataBytes(var fs: TFileStream; var ReadBuffer: TReadBuffer;
  n: integer; var mystreamposition: integer);

implementation

procedure TReadBuffer.clear;
begin

  BufferBytes := nil;

end;

procedure TRecordLength.clear;

begin
  Self := Default (TRecordLength);
end;

procedure TRecordType.clear;

begin
  Self := Default (TRecordType);
end;

function GetRecordlength(var fs: TFileStream;
  var mystreamposition: integer): Word;
var
  TotalRecordLengh: integer;
  Templength: Word;
  RecordLength: TRecordLength;

begin
  fs.ReadBuffer(RecordLength, SizeOf(RecordLength));
  mystreamposition := fs.Position;


  Templength := RecordLength.B1;
  Templength := Templength shl 8;
  TotalRecordLengh := Templength + RecordLength.B2;

  // this gave the total length of records to be read from the stream.
  if TotalRecordLengh >= 2 then
  begin
    Result := TotalRecordLengh - 2;
  end
  else
  begin
    Result := 0;
  end;

  RecordLength.clear;

end;

function GetTokenInfo(var fs: TFileStream; var mystreamposition: integer;
  var TokenType: Word; var TokenDataType: Word): boolean;
var

  ReturnType: Word;
  RecordType: TRecordType;

begin
  fs.ReadBuffer(RecordType, SizeOf(RecordType));

  ReturnType := RecordType.B1;

  ReturnType := ReturnType shl 8;

  TokenType := ReturnType + RecordType.B2;

  TokenDataType := RecordType.B2;

  mystreamposition := fs.Position;

  RecordType.clear;
end;

function GetWord(B1, B2: Byte): Word;
var
  ReturnWord: Word;
begin
  ReturnWord := B1;
  ReturnWord := ReturnWord shl 8;
  ReturnWord := ReturnWord + B2;
  Result := ReturnWord;

end;

procedure ReadDataBytes(var fs: TFileStream; var ReadBuffer: TReadBuffer;
  n: integer; var mystreamposition: integer);
var
  i: integer;

begin

  SetLength(ReadBuffer.BufferBytes, n);
  for i := 0 to high(ReadBuffer.BufferBytes) do
  begin
    fs.ReadBuffer(ReadBuffer.BufferBytes[i], SizeOf(ReadBuffer.BufferBytes[i]));

  end;
  mystreamposition := fs.Position;

end;

function ByteToHex(InByte: Byte): shortstring;
const
  Digits: array [0 .. 15] of char = '0123456789ABCDEF';
begin
  Result := Digits[InByte shr 4] + Digits[InByte and $0F];
end;

{ TGDSToken }

function TGDSToken.getDataType: String;
var
  i: integer;
begin
  Result := 'no valid data type name';
  for i := 0 to 6 do
  begin
    if (GDSDataTypes[i].ID = Self.DataType) then
    begin
      Result := GDSDataTypes[i].Name;
      exit;
    end;

  end;

end;

function TGDSToken.getName: String;
var
  i: integer;
begin
  Result := 'no valid token name';
  for i := 0 to gdsrecordtypes do
  begin
    if (GDSTokens[i].ID = Self.ID) then
    begin
      Result := GDSTokens[i].Name;
      exit
    end;

  end;
end;

end.
