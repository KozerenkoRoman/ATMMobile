unit Controllers.Base;

interface

uses
  MVCFramework, MVCFramework.Commons, MainDM, MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  Services.AtmIndex;

type
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

function TBaseController.GetDataModule: TdmMain;
begin
  if not Assigned(FDM) then
    FDM := TdmMain.Create(nil);
  Result := FDM;
end;

{ TPrivateController }

procedure TPrivateController.DeleteAllArticles;
begin
//  GetAmilService.DeleteAllArticles();
end;


end.
