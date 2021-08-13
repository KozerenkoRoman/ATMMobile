program ATMServer;
{$APPTYPE GUI}
uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  MainForm in 'MainForm.pas' {frmMain},
  Commons in 'Commons.pas',
  MainDM in 'DataModules\MainDM.pas' {dmMain: TDataModule},
  WebModuleMain in 'DataModules\WebModuleMain.pas' {ATMWebModule: TWebModule},
  Controllers.Users in 'Controllers\Controllers.Users.pas',
  Controllers.MemoryWebSession in 'Controllers\Controllers.MemoryWebSession.pas',
  Controllers.Base in 'Controllers\Controllers.Base.pas',
  Services.Base in 'Services\Services.Base.pas',
  Entities.AtmIndex in 'Entities\Entities.AtmIndex.pas',
  Controllers.AtmIndex in 'Controllers\Controllers.AtmIndex.pas',
  Services.AtmIndex in 'Services\Services.AtmIndex.pas',
  Authentication in 'Authentication.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
