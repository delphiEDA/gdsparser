unit Unit_GDSClasses;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, math, generics.collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Unit_GDSdatatypes;

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

    FDataType: Byte;

    function BufferByteAsString: String;

    function getName: String;

    function getDataType: String;

    property ID: Word read FID write FID;

    property DataType: Byte read FDataType write FDataType;

    property Data: TReadBuffer read FData write FData;

    property Name: String read getName;

    property GDSDataType: String read getDataType;

    property DataString: String read BufferByteAsString;

  end;

type
  TTokenList = class(TObjectlist<TGDSToken>)

    procedure parseGDSfile(afilename: String);
  end;

function GetRecordlength(var fs: TFileStream;
  var mystreamposition: integer): Word;

function GetTokenInfo(var fs: TFileStream; var mystreamposition: integer;
  var TokenType: Word; var TokenDataType: Byte): boolean;

function BytestoWord(B1, B2: Byte): Word;

function BytestoReal(B0, B1, B2, B3, B4, B5, B6, B7: Byte): Double;

function ByteToHex(InByte: Byte): shortstring;

function BytestoString(BytesBuffer: TReadBuffer): AnsiString;

function BytestoSmallInt(B0, B1: Byte): SmallInt;

function BytestoLongInt(var B0, B1, B2, B3: Byte): LongInt;

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
  var TokenType: Word; var TokenDataType: Byte): boolean;
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

function BytestoSmallInt(B0, B1: Byte): SmallInt;
var
  Number: SmallInt;
  small: array [0 .. 1] of Byte absolute Number;
begin
  small[0] := B1;
  small[1] := B0;
  Result := Number;

end;

function BytestoLongInt(var B0, B1, B2, B3: Byte): LongInt;
var

  returnInt: LongInt;
  pointer: ^LongInt;
  Longbyte: Array [0 .. 3] of Byte absolute returnInt;

begin
  pointer := @returnInt;
  Longbyte[0] := B3; // $40;//
  Longbyte[1] := B2; // $f6;//
  Longbyte[2] := B1; // $f1;//
  Longbyte[3] := B0; // $ff;//

  Result := pointer^;
end;

function BytestoString(BytesBuffer: TReadBuffer): AnsiString;
var
  arraylength: integer;
  s: AnsiString;
begin

  arraylength := high(BytesBuffer.BufferBytes) + 1;
  SetString(s, PAnsiChar(@BytesBuffer.BufferBytes[0]), arraylength);
  Result := s;

end;

function BytestoReal(B0, B1, B2, B3, B4, B5, B6, B7: Byte): Double;

var

  RealBytes: Array [0 .. 6] of Byte;

  sign, temp: Byte;
  exp: ShortInt;
  i: integer;
  n: int64;

begin
  n := 0;
  temp := B0 and $7F;
  exp := temp - $40;
  sign := B0 and $80;

  RealBytes[0] := B1;
  RealBytes[1] := B2;
  RealBytes[2] := B3;
  RealBytes[3] := B4;
  RealBytes[4] := B5;
  RealBytes[5] := B6;
  RealBytes[6] := B7;

  for i := 0 to 6 do

  begin
    n := 256 * n + RealBytes[i];

  end;
  if sign <> 0 then
  begin
    n := -n;
  end;

  Result := (n / (System.math.power(2, 56))) * System.math.power(16, (exp));

end;

function BytestoWord(B1, B2: Byte): Word;
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

function TGDSToken.BufferByteAsString: String;
var
  len: integer;
  j: integer;
  tempLine: String;
begin

  case FDataType of

    $00:
      begin
        Result := 'no data record';
      end;

    $01:
      begin
        Result := 'BITARRAY ';
      end;

    $02:
      begin
        tempLine := '';
        for j := low(Self.FData.BufferBytes)
          to High(Self.FData.BufferBytes) - 1 do
        begin
          tempLine := tempLine +
            IntToStr(BytestoSmallInt(Self.FData.BufferBytes[j],
            Self.FData.BufferBytes[j + 1])) + ';'
        end;

        Result := tempLine;
      end;

    $03:
      begin
        tempLine := '';
        for j := low(Self.FData.BufferBytes)
          to High(Self.FData.BufferBytes) - 1 do
        begin
          tempLine := tempLine +
            IntToStr(BytestoLongInt(Self.FData.BufferBytes[j],
            Self.FData.BufferBytes[j + 1], Self.FData.BufferBytes[j + 2],
            Self.FData.BufferBytes[j + 3])) + ';'
        end;

        Result := tempLine;
      end;

    $04:
      begin
        tempLine := '';
        for j := low(Self.FData.BufferBytes)
          to High(Self.FData.BufferBytes) - 1 do
        begin
          tempLine := tempLine +
            FloatToStr(BytestoReal(Self.FData.BufferBytes[j],
            Self.FData.BufferBytes[j + 1], Self.FData.BufferBytes[j + 2],
            Self.FData.BufferBytes[j + 3], Self.FData.BufferBytes[j + 4],
            Self.FData.BufferBytes[j + 5], Self.FData.BufferBytes[j + 6],
            Self.FData.BufferBytes[j + 7])) + ';'
        end;

        Result := tempLine;
      end;

    $05:
      begin
        tempLine := 'not yet';


        Result := tempLine;
      end;

    $06:
      begin
        Result := String(BytestoString(Self.FData));
      end;

  else
    Result := 'INVALID DATATYPE ';
  end;

end;

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

{ TTokenList }

procedure TTokenList.parseGDSfile(afilename: String);
var
  fs: TFileStream;
  mystreamposition: integer;
  GDSToken: TGDSToken;
  ReadBuffer: TReadBuffer;
  RecordType, RecordLength: Word;
begin
  mystreamposition := 1;
  fs := TFileStream.Create(afilename, fmOpenRead);

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

      finally
        Self.Add(GDSToken);
      end;

    end;
  end;

end;

end.
