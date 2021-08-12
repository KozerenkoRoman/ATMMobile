unit WebModuleMainU;

interface

uses
  System.SysUtils, System.IOUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt,
  FireDAC.DApt.Intf, FireDAC.DatS, FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Async, FireDAC.Stan.Def, FireDAC.Stan.Error, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Pool, FireDAC.UI.Intf, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, MVCFramework.Controllers.Register, MVCFramework, MVCFramework.Commons,
  MVCFramework.ActiveRecordController, MVCFramework.ActiveRecord, MVCFramework.Middleware.StaticFiles, Web.HTTPApp,
  Controllers.AtmIndex, MVCFramework.Middleware.Swagger, MVCFramework.Swagger.Commons, MVCFramework.Middleware.CORS;

type
  TATMWebModule = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FEngine: TMVCEngine;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TATMWebModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TATMWebModule.WebModuleCreate(Sender: TObject);
var
  SwagInfo: TMVCSwaggerInfo;
begin
  FEngine := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      // session timeout (0 means session cookie)
      Config[TMVCConfigKey.SessionTimeout] := '30';
      // default content-type
      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;
      // default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      // unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      // default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      // view path
      Config[TMVCConfigKey.ViewPath] := 'templates';
      // Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := '20';
      // Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE);
    end);
  FEngine.AddController(TAtmIndexController);
  TControllersRegister.Instance.AddControllersInEngine(FEngine, 'ATMServer');

  SwagInfo.Title := 'ATM Server';
  SwagInfo.Version := 'v 0.1';
  SwagInfo.Description := 'ATM Server ' + DMVCFRAMEWORK_VERSION +' Swagger Support';
//  SwagInfo.ContactName := 'Daniele Teti';
//  SwagInfo.ContactEmail := 'd.teti@bittime.it';
//  SwagInfo.ContactUrl := 'http://www.danieleteti.it';
  SwagInfo.LicenseName := 'Apache v2';
  SwagInfo.LicenseUrl := 'https://www.apache.org/licenses/LICENSE-2.0';
  FEngine.AddMiddleware(TMVCCORSMiddleware.Create);
  FEngine.AddMiddleware(TMVCStaticFilesMiddleware.Create(
    '/swagger', { StaticFilesPath }
    '.\www', { DocumentRoot }
    'index.html' { IndexDocument }
    ));
  FEngine.AddMiddleware(TMVCSwaggerMiddleware.Create(FEngine, SwagInfo, '/api/swagger.json', 'Method for authentication using JSON Web Token (JWT)'));

end;

procedure TATMWebModule.WebModuleDestroy(Sender: TObject);
begin
  FEngine.Free;
end;

end.
