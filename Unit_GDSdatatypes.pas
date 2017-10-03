unit Unit_GDSdatatypes;

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



implementation

end.
