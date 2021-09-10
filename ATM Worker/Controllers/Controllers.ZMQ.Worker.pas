unit Controllers.ZMQ.Worker;

interface

{$I Grijjy.inc}

uses
  System.SysUtils,
  System.Messaging,
  Grijjy.Console,
  PascalZMQ,
  ZMQ.Shared,
  ZMQ.WorkerProtocol,
  System.Classes,
  Rest.Client,
  REST.Types;

type
  TWorker = class(TZMQWorkerProtocol)
  protected
    { Receives a message from the Broker }
    procedure DoRecv(const ACommand: TZMQCommand;
      var AMsg: PZMessage; var ASentFrom: PZFrame); override;
  private

    procedure LogMessageListener(const Sender: TObject; const M: TMessage);
    function ProcessRequest(ARequest: string): String;
  public
    constructor Create;
    destructor Destroy; override;

    { Sends a command to the Broker }
    procedure Send(const AData: TBytes; var ARoutingFrame: PZFrame;
      const ADestroyRoutingFrame: Boolean = True); overload;
    procedure Send(const AData: Pointer; const ASize: Integer;
      var ARoutingFrame: PZFrame; const ADestroyRoutingFrame: Boolean = True); overload;
    procedure Send(const AGUID, AResponse: String; var ARoutingFrame: PZFrame;
      const ADestroyRoutingFrame: Boolean = True); overload;
  end;

implementation

constructor TWorker.Create;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TZMQLogMessage, LogMessageListener);
  inherited Create(
    True,   // use heartbeats
    True,   // expect reply routing frames
    True);  // use thread pool
end;

destructor TWorker.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TZMQLogMessage, LogMessageListener);
  inherited;
end;

{ Out internal messages to the console }
procedure TWorker.LogMessageListener(const Sender: TObject;
  const M: TMessage);
var
  LogMessage: TZMQLogMessage;
begin
  LogMessage := M as TZMQLogMessage;
  Synchronize(
    procedure
    begin
      if Assigned(OnLogMessage) then
        OnLogMessage(Self, LogMessage.Text);
    end);
//  raise Exception.Create(LogMessage.Text);
end;

function TWorker.ProcessRequest(ARequest: string): String;
var FRestClient: TRestClient;
    FRestRequest: TRestRequest;
    FRestResponse: TRestResponse;
    L: TStringList;

    function StringToRESTRequestMethod(const AMethod: string): TRESTRequestMethod;
    begin
      if SameText(AMethod, 'POST') then
        Result := TRESTRequestMethod.rmPOST
      else if SameText(AMethod, 'PUT') then
        Result := TRESTRequestMethod.rmPUT
      else if SameText(AMethod, 'DELETE') then
        Result := TRESTRequestMethod.rmDELETE
      else if SameText(AMethod, 'PATCH') then
        Result := TRESTRequestMethod.rmPATCH
      else
        Result := rmGET;
    end;

begin
  try
    FRestRequest := TRestRequest.Create(nil);
    FRestClient := TRestClient.Create(nil);
    FRestResponse:= TRESTResponse.Create(nil);
    L := TStringList.Create;
    try
      L.Text := ARequest;
      if L.Count >= 2 then
      begin
        FRestRequest.Method:= StringToRESTRequestMethod(Trim(L.Strings[0]));
        L.Delete(0);
        FRestRequest.Resource:= Trim(L.Strings[0]);
        L.Delete(0);
        FRestRequest.Params.AddHeader('Accept', 'application/json');
        FRestRequest.Params.AddHeader('ContentType', 'application/json');
        if L.Count > 0 then
        begin
          L.Delete(0);
          FRestRequest.Body.Add(L.Text, ctAPPLICATION_JSON);
        end;

        FRestClient.BaseURL := 'http://localhost:1235';
        FRestClient.Accept := 'application/json, text/plain, text/xml; q=0.9, text/html;q=0.8,';
        FRestClient.AcceptCharset := 'UTF-8, *;q=0.8';
        FRestClient.HandleRedirects := True;

        FRestResponse.ContentType:= 'application/json';

        FRestRequest.Client := FRestClient;
        FRestRequest.Response:= FRestResponse;
        FRestRequest.SynchronizedEvents := False;


        FRestRequest.Execute;

        Result := 'HTTP/1.1 ' + IntToStr(FRestResponse.StatusCode) + ' ' + FRestResponse.StatusText + #13#10;
        Result := Result + FRestResponse.Headers.Text + #13#10;
        Result := Result + FRestResponse.Content;
      end;
    finally
      FRestRequest.Free;
      FRestClient.Free;
      FRestResponse.Free;
      L.Free;
    end;
  except on E: Exception do
    begin
      Result := 'HTTP/1.1 500 Internal Server Error' + #13#10#13#10 + E.Message;
    end;
  end;
end;

procedure TWorker.Send(const AData: TBytes; var ARoutingFrame: PZFrame;
  const ADestroyRoutingFrame: Boolean = True);
var
  Msg: PZMessage;
  RoutingFrame: PZFrame;
begin
  Msg := TZMessage.Create;
  Msg.PushBytes(AData);
  if ADestroyRoutingFrame then
    inherited Send(Msg, ARoutingFrame)
  else
  begin
    RoutingFrame := ARoutingFrame.Clone;
    inherited Send(Msg, RoutingFrame)
  end;
end;

procedure TWorker.Send(const AData: Pointer; const ASize: Integer;
var ARoutingFrame: PZFrame; const ADestroyRoutingFrame: Boolean = True);
var
  Msg: PZMessage;
  RoutingFrame: PZFrame;
begin
  Msg := TZMessage.Create;
  Msg.PushMemory(AData^, ASize);
  if ADestroyRoutingFrame then
    inherited Send(Msg, ARoutingFrame)
  else
  begin
    RoutingFrame := ARoutingFrame.Clone;
    inherited Send(Msg, RoutingFrame)
  end;
end;

procedure TWorker.Send(const AGUID, AResponse: String; var ARoutingFrame: PZFrame;
  const ADestroyRoutingFrame: Boolean = True);
var
  Msg: PZMessage;
  RoutingFrame: PZFrame;
begin
  Msg := TZMessage.Create;
  Msg.PushString(AGuid);
  Msg.PushString(AResponse);
  if ADestroyRoutingFrame then
    inherited Send(Msg, ARoutingFrame)
  else
  begin
    RoutingFrame := ARoutingFrame.Clone;
    inherited Send(Msg, RoutingFrame)
  end;
end;

{ Receives a command from the Broker }
procedure TWorker.DoRecv(const ACommand: TZMQCommand; var AMsg: PZMessage;
  var ASentFrom: PZFrame);
var
  GUID, Request, Response: string;
begin
  Request := AMsg.PopString;
  GUID := AMsg.PopString;

  Response := ProcessRequest(Request);
  Send(GUID, Response, ASentFrom, false);

  {
  if Assigned(OnLogMessage) then
  begin
//    OnLogMessage(Self, 'GUID - ' + GUID);
    OnLogMessage(Self, 'Request - ' + Request);
  end;
  }
end;

end.
