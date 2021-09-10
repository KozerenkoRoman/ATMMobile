program ATMServer;
{$APPTYPE GUI}
uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  MainForm in 'MainForm.pas' {frmMain},
  Commons in '..\COMMON\Commons.pas',
  MainDM in 'DataModules\MainDM.pas' {dmMain: TDataModule},
  WebModuleMain in 'DataModules\WebModuleMain.pas' {ATMWebModule: TWebModule},
  Controllers.Users in 'Controllers\Controllers.Users.pas',
  Controllers.MemoryWebSession in 'Controllers\Controllers.MemoryWebSession.pas',
  Controllers.Base in 'Controllers\Controllers.Base.pas',
  Services.Base in 'Services\Services.Base.pas',
  Controllers.AtmIndex in 'Controllers\Controllers.AtmIndex.pas',
  Authentication in 'Authentication.pas',
  CentralDM in 'DataModules\CentralDM.pas' {dmCentral: TDataModule},
  Controllers.ZMQ.Broker in 'Controllers\Controllers.ZMQ.Broker.pas',
  uConfig in '..\COMMON\uConfig.pas',
  Controllers.ZMQ.Client in 'Controllers\Controllers.ZMQ.Client.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmCentral, dmCentral);
  Application.Run;
end.
