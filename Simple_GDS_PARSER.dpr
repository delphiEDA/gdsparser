program Simple_GDS_PARSER;

uses
  Vcl.Forms,
  Unit_GDSClasses in 'Unit_GDSClasses.pas',
  Unit_GDSdatatypes in 'Unit_GDSdatatypes.pas',
  Unit_gds_parser in 'Unit_gds_parser.pas' {frm_simple_gdsparser};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_simple_gdsparser, frm_simple_gdsparser);
  Application.Run;
end.
