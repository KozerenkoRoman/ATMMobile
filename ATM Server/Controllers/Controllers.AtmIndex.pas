unit Controllers.AtmIndex;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons, Controllers.Base, Services.Base, Services.AtmIndex,
  Entities.AtmIndex, Commons, mvcframework.Serializer.Intf, System.Generics.Collections, System.SysUtils;

type
  [MVCDoc('Resource that manages AtmIndex CRUD')]
  [MVCPath('/api/atmindex')]
  TAtmIndexController = class(TBaseController)
  public
    [MVCDoc('Returns the list of AtmIndex')]
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure GetAll;

    [MVCDoc('Returns the AtmIndex with the specified id')]
    [MVCPath('/meta')]
    [MVCHTTPMethod([httpGET])]
    procedure GetMeta;

    [MVCDoc('Returns the AtmIndex with the specified key')]
    [MVCPath('/($AKey)/($AYear)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetByName(AKey: string; AYear: Integer);

    [MVCDoc('Returns next value from AtmIndex with the specified key')]
    [MVCPath('/next')]
    [MVCHTTPMethod([httpGET])]
    procedure GetNextNumber;

    [MVCDoc('Deletes the AtmIndex with the specified id')]
    [MVCPath('/($AKey)/($AYear)')]
    [MVCHTTPMethod([httpDelete])]
    procedure Delete(AKey: string; AYear: Integer);

    [MVCDoc('Updates the AtmIndex with the specified id and return "200: OK"')]
    [MVCPath('/($AKey)')]
    [MVCHTTPMethod([httpPUT])]
    procedure Update(AKey: string);

    [MVCDoc('Creates a new AtmIndex and returns "201: Created"')]
    [MVCPath]
    [MVCHTTPMethod([httpPOST])]
    procedure Add;
  end;

implementation

{ TAtmIndexController }

procedure TAtmIndexController.GetAll;
begin
  Render(ObjectDict().Add('data', GetAtmIndexService.GetAll));
end;

procedure TAtmIndexController.GetMeta;
begin
  try
    Render(ObjectDict().Add('data', GetAtmIndexService.GetMeta));
  except
    on E: EServiceException do
    begin
      raise EMVCException.Create(E.Message, '', 0, 404);
    end
    else
      raise;
  end;
end;

procedure TAtmIndexController.GetByName(AKey: string; AYear: Integer);
begin
  try
    Render(ObjectDict().Add('data', GetAtmIndexService.GetByName(AKey, AYear)));
  except
    on E: EServiceException do
    begin
      raise EMVCException.Create(E.Message, '', 0, 404);
    end
    else
      raise;
  end;
end;

procedure TAtmIndexController.GetNextNumber;
var
  Key: string;
begin
  Key := Context.Request.Params['q'];
  try
    Render(ObjectDict().Add('data', GetAtmIndexService.GetNextNumber(Key, CurrentYear)));
  except
    on E: EServiceException do
    begin
      raise EMVCException.Create(E.Message, '', 0, 404);
    end
    else
      raise;
  end;
end;

procedure TAtmIndexController.Add;
var
  AtmIndex: TAtmIndex;
begin
  AtmIndex := Context.Request.BodyAs<TAtmIndex>;
  try
    GetAtmIndexService.Add(AtmIndex);
    Render201Created('/atmindex/' + AtmIndex.Key_String + '/' + AtmIndex.YehusYear.ToString, 'AtmIndex Created');
  finally
    AtmIndex.Free;
  end;
end;

procedure TAtmIndexController.Delete(AKey: string; AYear: Integer);
var
  AtmIndex: TAtmIndex;
begin
  GetAtmIndexService.StartTransaction;
  try
    AtmIndex := GetAtmIndexService.GetByName(AKey, AYear);
    try
      GetAtmIndexService.Delete(AtmIndex);
    finally
      AtmIndex.Free;
    end;
    GetAtmIndexService.Commit;
  except
    GetAtmIndexService.Rollback;
    raise;
  end;
end;

procedure TAtmIndexController.Update(AKey: string);
var
  AtmIndex: TAtmIndex;
begin
  AtmIndex := Context.Request.BodyAs<TAtmIndex>;
  try
    AtmIndex.Key_String := AKey;
    GetAtmIndexService.Update(AtmIndex);
    Render(200, 'AtmIndex Updated');
  finally
    AtmIndex.Free;
  end;
end;

end.
