unit Services.AtmIndex;

interface

uses
  System.Generics.Collections, Entities.AtmIndex, MainDM, System.SysUtils, Services.Base, JsonDataObjects,
  FireDAC.Stan.Option, FireDAC.Comp.Client, FireDAC.Stan.Param, MVCFramework.FireDAC.Utils, MVCFramework.DataSet.Utils,
  MVCFramework.Serializer.Commons, MVCFramework.Logger, Commons, Data.DB;

type
  TAtmIndexService = class(TServiceBase)
  public
    function GetAll: TObjectList<TAtmIndex>;
    function GetByName(const AKey: string; const AYear: Integer): TAtmIndex;
    function GetNextNumber(const AKey: string; const AYear: Integer): TAtmIndex;
    function GetMeta: TJSONObject;
    procedure Add(AAtmIndex: TAtmIndex);
    procedure Delete(AAtmIndex: TAtmIndex);
    procedure Update(AAtmIndex: TAtmIndex);
  end;

implementation

{ TAtmIndexService }

function TAtmIndexService.GetAll: TObjectList<TAtmIndex>;
begin
  FDM.qAtmIndex.Open('SELECT * FROM AtmIndex ORDER BY key_string, yehusyear', []);
  Result := FDM.qAtmIndex.AsObjectList<TAtmIndex>;
  FDM.qAtmIndex.Close;
end;

function TAtmIndexService.GetByName(const AKey: string; const AYear: Integer): TAtmIndex;
begin
  FDM.qAtmIndex.Open('SELECT * FROM AtmIndex WHERE Key_String LIKE :Key and YehusYear=:Year', [AKey, AYear], [ftString, ftInteger]);
  try
    if not FDM.qAtmIndex.Eof then
      Result := FDM.qAtmIndex.AsObject<TAtmIndex>
    else
      raise EServiceException.Create('AtmIndex not found');
  finally
    FDM.qAtmIndex.Close;
  end;
end;

function TAtmIndexService.GetMeta: TJSONObject;
begin
  FDM.qAtmIndex.Open('SELECT Key_String, YehusYear, Last_Number, LastUpDate, MaklidName FROM AtmIndex WHERE 1 = 0');
  Result := FDM.qAtmIndex.MetadataAsJSONObject();
end;

function TAtmIndexService.GetNextNumber(const AKey: string; const AYear: Integer): TAtmIndex;
begin
  try
    Result := GetByName(AKey, AYear);
    Result.Last_Number := Result.Last_Number + 1;
    Update(Result);
  except
    on E: EServiceException do
    begin
      Result := TAtmIndex.Create;
      Result.Key_String := AKey;
      Result.YehusYear := CurrentYear;
      Result.Last_Number := 1;
      Result.LastUpDate := Now;
      Add(Result);
    end;
  end;
end;

procedure TAtmIndexService.Update(AAtmIndex: TAtmIndex);
var
  Cmd: TFDCustomCommand;
begin
  Cmd := FDM.updAtmIndex.Commands[arUpdate];
  TFireDACUtils.ObjectToParameters(Cmd.Params, AAtmIndex, 'NEW_');
  Cmd.ParamByName('OLD_Key_String').AsString := AAtmIndex.Key_String;
  Cmd.ParamByName('OLD_YehusYear').AsInteger := AAtmIndex.YehusYear;
  Cmd.Execute;
  if Cmd.RowsAffected <> 1 then
    raise Exception.Create('AtmIndex not found');
end;

procedure TAtmIndexService.Add(AAtmIndex: TAtmIndex);
var
  Cmd: TFDCustomCommand;
begin
  Cmd := FDM.updAtmIndex.Commands[arInsert];
  TFireDACUtils.ObjectToParameters(Cmd.Params, AAtmIndex, 'NEW_');
  Cmd.Execute;
end;

procedure TAtmIndexService.Delete(AAtmIndex: TAtmIndex);
var
  Cmd: TFDCustomCommand;
begin
  Cmd := FDM.updAtmIndex.Commands[arDelete];
  TFireDACUtils.ObjectToParameters(Cmd.Params, AAtmIndex, 'OLD_');
  Cmd.Execute;
end;

end.
