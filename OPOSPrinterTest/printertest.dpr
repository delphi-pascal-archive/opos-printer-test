program printertest;

uses
  Vcl.Forms,
  u_main in 'u_main.pas' {OPOSPrinterTest};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TOPOSPrinterTest, OPOSPrinterTest);
  Application.Run;
end.
