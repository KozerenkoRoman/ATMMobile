unit Controllers.Base;

interface

uses
  MVCFramework, MVCFramework.Commons, MainDM, MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  {Services.AtmIndex, }MVCFramework.Swagger.Commons, System.SysUtils, System.IniFiles, System.IOUtils,
  Vcl.Forms, uConfig;

type
  [MVCSwagAuthentication(atJsonWebToken)]
  TBaseController = class abstract(TMVCController)
  strict private
    FDM: TdmMain;
    //FAtmIndexService: TAtmIndexService;
    function GetDataModule: TdmMain;
  strict protected
    //function GetAtmIndexService: TAtmIndexService;
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
  //FreeAndNil(FAtmIndexService);
  FreeAndNil(FDM);
  inherited;
end;

{
function TBaseController.GetAtmIndexService: TAtmIndexService;
begin
  if not Assigned(FAtmIndexService) then
    FAtmIndexService := TAtmIndexService.Create(GetDataModule);
  Result := FAtmIndexService;
end;
}

function TBaseController.GetDataModule: TdmMain;
var
  FConfig: TConfig;
begin
  if not Assigned(FDM) then
  begin
    FDM := TdmMain.Create(nil);
    FConfig := TConfig.Create;
    try
      with FDM.Connection.Params do begin
        Clear;
        Add('DriverID=MSSQL');
        Add('Server='+ FConfig.MSSQLServerName);
        Add('Database='+ FConfig.MSSQLDatabase);
        Add('User_Name='+ FConfig.MSSQLLogin);
        Add('Password='+ FConfig.MSSQLPassword);
      end;
    finally
      FConfig.Free;
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
