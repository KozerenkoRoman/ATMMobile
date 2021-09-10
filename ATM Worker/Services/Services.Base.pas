unit Services.Base;

interface

uses
  System.Generics.Collections, FireDAC.Stan.Option, FireDAC.Comp.Client, FireDAC.Stan.Param, MVCFramework.FireDAC.Utils,
  MVCFramework.DataSet.Utils, MVCFramework.Serializer.Commons, System.SysUtils, JsonDataObjects, uData;

type
  TServiceBase = class abstract
  strict protected
    FDM: TdmData;
  public
    constructor Create(AdmData: TdmData); virtual;
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

constructor TServiceBase.Create(AdmData: TdmData);
begin
  inherited Create;
  FDM := AdmData;
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
