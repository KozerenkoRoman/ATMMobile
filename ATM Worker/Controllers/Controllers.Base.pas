unit Controllers.Base;

interface

uses
  MVCFramework, MVCFramework.Commons, uData, MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  Services.AtmIndex, MVCFramework.Swagger.Commons, uConfig;

type
  [MVCSwagAuthentication(atJsonWebToken)]
  TBaseController = class abstract(TMVCController)
  strict private
    FDM: TdmData;
    FAtmIndexService: TAtmIndexService;
    function GetDataModule: TdmData;
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

uses
  System.SysUtils;

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

function TBaseController.GetDataModule: TdmData;
var
  FConfig: TConfig;
begin
  if not Assigned(FDM) then
  begin
    FDM := TdmData.Create(nil);
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
