unit WebModuleMain;

interface

uses
  System.SysUtils, System.IOUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, System.DateUtils,
  FireDAC.DApt.Intf, FireDAC.DatS, FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Async, FireDAC.Stan.Def, FireDAC.Stan.Error, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Pool, FireDAC.UI.Intf, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, MVCFramework.Controllers.Register, MVCFramework, MVCFramework.Commons, Controllers.Users,
  MVCFramework.ActiveRecordController, MVCFramework.ActiveRecord, MVCFramework.Middleware.StaticFiles, Web.HTTPApp,
  Controllers.AtmIndex, MVCFramework.Middleware.Swagger, MVCFramework.Swagger.Commons, MVCFramework.Middleware.CORS,
  MVCFramework.Middleware.Authentication, MVCFramework.Middleware.JWT, MVCFramework.JWT, Authentication,
  IdHTTPWebBrokerBridge;

type TMVCEngine = class(MVCFramework.TMVCEngine)
  protected
    procedure OnBeforeDispatch(ASender: TObject; ARequest: TWebRequest; AResponse: TWebResponse;
      var AHandled: Boolean); override;
end;

type THackIdHTTPAppRequest = class(TIdHTTPAppRequest);

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
const
  key = 'AE3b6D1E-df4b-40EB-adba-497F28cf8172';
var
  SwagInfo: TMVCSwaggerInfo;
  ClaimsSetup: TJWTClaimsSetup;
begin
  FEngine := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
     // session timeout (0 means session cookie)
      Config[TMVCConfigKey.SessionTimeout] := '30'; // 30minutes
      // comment the line to use default session type (memory)
      Config[TMVCConfigKey.SessionType] := 'memoryController';
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
      // SSL
      Config['ISAPI_PATH'] := '/isapi32/myisapi.dll';
    end);
  TControllersRegister.Instance.AddControllersInEngine(FEngine, 'ATMServer');
  FEngine.AddController(TUsersController);
  FEngine.AddController(TAtmIndexController);
  FEngine.AddMiddleware(TMVCCORSMiddleware.Create);
  FEngine.AddMiddleware(TMVCStaticFilesMiddleware.Create(
    '/swagger', { StaticFilesPath }
    '.\www', { DocumentRoot }
    'index.html' { IndexDocument }
    ));

  ClaimsSetup := procedure(const JWT: TJWT)
    begin
      JWT.Claims.Issuer := 'Delphi MVC Framework Swagger Documentation';
      JWT.Claims.ExpirationTime := Now + OneHour / 2;  // valid for 0.5 hour
      JWT.Claims.NotBefore := Now - OneMinute * 5; // valid since 5 minutes ago
      JWT.Claims.IssuedAt := Now;
    end;

  SwagInfo.Title := 'ATM Server';
  SwagInfo.Version := 'v 0.1';
  SwagInfo.Description := 'Users for authentication:' + sLineBreak + 'admin - adminpass'  + sLineBreak + 'user1 - user1pass'  + sLineBreak + 'user2 - user2pass';
  FEngine.AddMiddleware(TMVCSwaggerMiddleware.Create(FEngine, SwagInfo, '/api/swagger.json', 'Method for authentication using JSON Web Token (JWT)'));
  FEngine.AddMiddleware(TMVCJWTAuthenticationMiddleware.Create(TAuthentication.Create, key, '/api/login', ClaimsSetup, [TJWTCheckableClaim.ExpirationTime, TJWTCheckableClaim.NotBefore, TJWTCheckableClaim.IssuedAt]));
 end;

procedure TATMWebModule.WebModuleDestroy(Sender: TObject);
begin
  FEngine.Free;
end;

{ TMVCEngine }

// will try to forward request here later
procedure TMVCEngine.OnBeforeDispatch(ASender: TObject; ARequest: TWebRequest;
  AResponse: TWebResponse; var AHandled: Boolean);
begin
  inherited;

//    if SameText(ARequest.PathTranslated, '/api/login') then
//      inherited
//    else
//    begin
//
//      AHandled := true;
//    end;

end;

end.
