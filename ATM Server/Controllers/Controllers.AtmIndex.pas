unit Controllers.AtmIndex;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons, MVCFramework.Swagger.Commons, Controllers.Base,
  Services.Base, Commons, mvcframework.Serializer.Intf, System.Generics.Collections, System.SysUtils, {Services.AtmIndex,
  Entities.AtmIndex,} System.Classes, Controllers.ZMQ.Client;

type
  [MVCDoc('Resource that manages AtmIndex CRUD')]
  [MVCPath('/api/atmindex')]
  [MVCSwagAuthentication(atJsonWebToken)]
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
    [MVCSwagParam(plPath, 'AYear', 'yehusyear field', ptInteger, True, '2021')]
    [MVCSwagParam(plPath, 'AKey', 'key_string field', ptString, True, 'Hafkada')]
    [MVCPath('/($AKey)/($AYear)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetByName(AKey: string; AYear: Integer);

    [MVCDoc('Returns next value from AtmIndex with the specified key')]
    [MVCSwagParam(plPath, 'AKey', 'key_string field', ptString, True, 'Hafkada')]
    [MVCPath('/next')]
    [MVCHTTPMethod([httpGET])]
    procedure GetNextNumber;

    [MVCDoc('Deletes the AtmIndex with the specified id')]
    [MVCSwagParam(plPath, 'AYear', 'yehusyear field', ptInteger, True, '2021')]
    [MVCSwagParam(plPath, 'AKey', 'key_string field', ptString, True, 'Hafkada')]
    [MVCPath('/($AKey)/($AYear)')]
    [MVCHTTPMethod([httpDelete])]
    procedure Delete(AKey: string; AYear: Integer);

    [MVCDoc('Updates the AtmIndex with the specified id and return "200: OK"')]
    [MVCSwagParam(plPath, 'AYear', 'yehusyear field', ptInteger, True, '2021')]
    [MVCSwagParam(plPath, 'AKey', 'key_string field', ptString, True, 'Hafkada')]
    [MVCPath('/($AKey)/($AYear)')]
    [MVCHTTPMethod([httpPUT])]
    procedure Update(AKey: string; AYear: Integer);

    [MVCDoc('Creates a new AtmIndex and returns "201: Created"')]
    [MVCPath]
    [MVCHTTPMethod([httpPOST])]
    procedure Add;

    procedure ProcessRequestOnWorker;
  end;

implementation

uses
  REST.Types;

{ TAtmIndexController }

procedure TAtmIndexController.GetAll;
begin
  ProcessRequestOnWorker;
end;

procedure TAtmIndexController.GetMeta;
begin
  ProcessRequestOnWorker;
end;

procedure TAtmIndexController.GetByName(AKey: string; AYear: Integer);
begin
  ProcessRequestOnWorker;
end;

procedure TAtmIndexController.GetNextNumber;
begin
  ProcessRequestOnWorker;
end;

procedure TAtmIndexController.ProcessRequestOnWorker;
var L: TStringList;
    cBody, cRequest, cStr, cHeader, cValue: string;
begin
  cRequest := GetContext.Request.HTTPMethodAsString + #13#10 + GetContext.Request.PathInfo;
  cBody := GetContext.Request.Body;
  L := TStringList.Create;
  try
    if not cBody.IsEmpty then
      cRequest := cRequest + #13#10#13#10 + cBody;
    L.Text := ZMQClient.SendRequestToService('MyService', cRequest);
    if L.Count > 0 then
    begin
      cStr := L.Strings[0];
      if cStr.StartsWith('HTTP/1.1') then
      begin
        cStr := Copy(cStr, 10, Length(cStr));
        GetContext.Response.StatusCode := StrToIntDef(Copy(cStr, 1, Pos(' ', cStr) - 1), 0);
        L.Delete(0);
      end;
      while L.Count > 0 do
      begin
        cStr := L.Strings[0];
        if cStr.IsEmpty then
        begin
          L.Delete(0);
          break;
        end;
        cHeader := Copy(cStr, 1, Pos(':', cStr) - 1);
        cValue := Copy(cStr, Pos(':', cStr) + 1, Length(cStr));
        GetContext.Response.SetCustomHeader(cHeader, cValue);
        L.Delete(0);
      end;
      GetContext.Response.Content := L.Text;
      GetContext.Response.Flush;
    end
    else
      raise EMVCException.Create('No response from worker', '', 0, 503);
  finally
    L.Free;
  end;

end;

procedure TAtmIndexController.Add;
begin
  ProcessRequestOnWorker;
end;

procedure TAtmIndexController.Delete(AKey: string; AYear: Integer);
begin
  ProcessRequestOnWorker;
end;

procedure TAtmIndexController.Update(AKey: string; AYear: Integer);
begin
  ProcessRequestOnWorker;
end;

end.
