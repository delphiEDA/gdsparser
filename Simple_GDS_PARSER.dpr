program Simple_GDS_PARSER;

uses
  Vcl.Forms,
  Unit_gds_parser in 'Unit_gds_parser.pas' {frm_simple_gds_parser1},
  Unit_ParseGDSII in 'Unit_ParseGDSII.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_simple_gds_parser1, frm_simple_gds_parser1);
  Application.Run;
end.
