unit Controllers.Base;

interface

uses
  MVCFramework, MVCFramework.Commons, MainDM, MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  Services.AtmIndex, MVCFramework.Swagger.Commons, System.SysUtils, System.IniFiles, System.IOUtils,
  Vcl.Forms;

type
  [MVCSwagAuthentication(atJsonWebToken)]
  TBaseController = class abstract(TMVCController)
  strict private
    FDM: TdmMain;
    FAtmIndexService: TAtmIndexService;
    function GetDataModule: TdmMain;
  strict protected
    function GetAtmIndexService: TAtmIndexService;
  public
    destructor Destroy; override;
  end;

  [MVCPath('/private')]
  TPrivateController = class(TBaseController)
  public
    [MVCPath('/articles')]
    [MVCHTTPMethods([httpDELETE])]
    procedure DeleteAllArticles;
  end;

implementation

{ TBaseController }

destructor TBaseController.Destroy;
begin
  FreeAndNil(FAtmIndexService);
  FreeAndNil(FDM);
  inherited;
end;

function TBaseController.GetAtmIndexService: TAtmIndexService;
begin
  if not Assigned(FAtmIndexService) then
    FAtmIndexService := TAtmIndexService.Create(GetDataModule);
  Result := FAtmIndexService;
end;

function TBaseController.GetDataModule: TdmMain;
var
  IniFile: TIniFile;
begin
  if not Assigned(FDM) then
  begin
    FDM := TdmMain.Create(nil);
    IniFile := TIniFile.Create(TPath.GetFileNameWithoutExtension(Application.ExeName) + '.ini');
    try
      FDM.Connection.Params.Database := IniFile.ReadString('Params', 'Database', 'Ben');
      FDM.Connection.Params.UserName := IniFile.ReadString('Params', 'UserName', 'sa');
      FDM.Connection.Params.Password := IniFile.ReadString('Params', 'Password', '111');
    finally
      FreeAndNil(IniFile);
    end;
  end;
  Result := FDM;
end;

{ TPrivateController }

procedure TPrivateController.DeleteAllArticles;
begin
//  GetAmilService.DeleteAllArticles();
end;


end.
