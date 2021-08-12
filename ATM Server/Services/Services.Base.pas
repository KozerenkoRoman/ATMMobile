unit Services.Base;

interface

uses
  System.Generics.Collections, FireDAC.Stan.Option, FireDAC.Comp.Client, FireDAC.Stan.Param, MVCFramework.FireDAC.Utils,
  MVCFramework.DataSet.Utils, MVCFramework.Serializer.Commons, System.SysUtils, JsonDataObjects, MainDM;

type
  TServiceBase = class abstract
  strict protected
    FDM: TdmMain;
  public
    constructor Create(AdmMain: TdmMain); virtual;
    procedure Commit;
    procedure Rollback;
    procedure StartTransaction;
  end;

implementation

{ TServiceBase }

procedure TServiceBase.Commit;
begin
  FDM.Connection.Commit;
end;

constructor TServiceBase.Create(AdmMain: TdmMain);
begin
  inherited Create;
  FDM := AdmMain;
end;

procedure TServiceBase.Rollback;
begin
  FDM.Connection.Rollback;
end;

procedure TServiceBase.StartTransaction;
begin
  FDM.Connection.StartTransaction;
end;

end.
