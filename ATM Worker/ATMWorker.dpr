program ATMWorker;

uses
  Vcl.Forms,
  Web.WebReq,
  MainUnit in 'MainUnit.pas' {frmMain},
  uConfig in '..\COMMON\uConfig.pas',
  Commons in '..\COMMON\Commons.pas',
  uData in 'Modules\uData.pas' {dmData: TDataModule},
  Controllers.ZMQ.Worker in 'Controllers\Controllers.ZMQ.Worker.pas',
  Controllers.AtmIndex in 'Controllers\Controllers.AtmIndex.pas',
  Controllers.Base in 'Controllers\Controllers.Base.pas',
  Controllers.MemoryWebSession in 'Controllers\Controllers.MemoryWebSession.pas',
  Entities.AtmIndex in 'Entities\Entities.AtmIndex.pas',
  WebModuleMain in 'Modules\WebModuleMain.pas' {ATMWebModule: TWebModule},
  Services.AtmIndex in 'Services\Services.AtmIndex.pas',
  Services.Base in 'Services\Services.Base.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
