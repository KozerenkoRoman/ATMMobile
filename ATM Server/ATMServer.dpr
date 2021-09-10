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
  Controllers.AtmIndex in 'Controllers\Controllers.AtmIndex.pas',
  Services.AtmIndex in 'Services\Services.AtmIndex.pas',
  Authentication in 'Authentication.pas',
  Entities.AtmIndex in 'Entities\Entities.AtmIndex.pas',
  CentralDM in 'DataModules\CentralDM.pas' {dmCentral: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmCentral, dmCentral);
  Application.Run;
end.
