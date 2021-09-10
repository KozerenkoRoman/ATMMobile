unit Controllers.ZMQ.Client;

interface

uses
  System.SysUtils,
  PascalZMQ,
  ZMQ.Shared,
  ZMQ.ClientProtocol,
  System.SyncObjs,
  System.Generics.Collections;

type
  { Example Client using the ZMQ Client Protocol class }
  TZMQClient = class(TZMQClientProtocol)
  private
  protected
    { Implements the DoRecv from the client protocol class }
    procedure DoRecv(const ACommand: TZMQCommand;
      var AMsg: PZMessage; var ASentFrom: PZFrame); override;
  public
    GUIDEvents: TDictionary<string, TEvent>;
    GUIDValues: TDictionary<string, string>;
    constructor Create;
    destructor Destroy; override;
  public
    function GenerateGUID: String;
    procedure Connect(const ABrokerAddress: String); reintroduce;
    { Sends a message to the specified service, with optional data }
    procedure Send(const AService: String; const AData: String; AGUID: String); reintroduce;
    function SendRequestToService(const AService: String; const AData: string): string;
  end;

var ZMQClient: TZMQClient;
var ZMQClientLock: TCriticalSection;

implementation

{ TExampleClient }

constructor TZMQClient.Create;
begin
  inherited Create;
  GUIDEvents := TDictionary<string, TEvent>.Create;
  GUIDValues := TDictionary<string, string>.Create;
end;

destructor TZMQClient.Destroy;
var FEvent: TEvent;
begin
  if Assigned(GUIDEvents) then
  begin
    for FEvent in GUIDEvents.Values do
      FEvent.Free;
    FreeAndNil(GUIDEvents);
  end;
  if Assigned(GUIDValues) then
    FreeAndNil(GUIDValues);
  inherited;
end;

procedure TZMQClient.Connect(const ABrokerAddress: String);
begin
  inherited Connect(ABrokerAddress, '', TZSocketType.Dealer);
end;

procedure TZMQClient.Send(const AService: String; const AData: String; AGUID: String);
var
  Msg: PZMessage;
begin
  ZMQClientLock.Enter;
  Msg := TZMessage.Create;
  try
    Msg.PushString(AGUID);
    Msg.PushString(AData);
    inherited Send(AService, Msg);
  finally
    Msg.Free;
    ZMQClientLock.Leave;
  end;
end;

function TZMQClient.SendRequestToService(const AService: String;
  const AData: String): string;
var
  FEvent: TEvent;
  FGUID: string;
begin
  FGUID := ZMQClient.GenerateGUID;
  FEvent := TEvent.Create(nil,True,false, FGUID);
  try
    ZMQClient.GUIDEvents.AddOrSetValue(FGUID, FEvent);
    ZMQClient.Send(AService, AData, FGUID);

    FEvent.WaitFor(15000);

    if ZMQClient.GUIDValues.ContainsKey(FGUID) then
      Result := ZMQClient.GUIDValues.Items[FGUID];
  finally
    GUIDEvents.Remove(FGUID);
    GUIDValues.Remove(FGUID);
    FEvent.Free;
  end;
end;

procedure TZMQClient.DoRecv(const ACommand: TZMQCommand;
  var AMsg: PZMessage; var ASentFrom: PZFrame);
var
  Service: String;
  Response, GUID : String;
  FEvent: TEvent;
begin
  { Responding service name }
  Service := AMsg.PopString;

  { Response bytes }
  Response := AMsg.PopString;
  GUID := AMsg.PopString;

  GUIDValues.AddOrSetValue(GUID, Response);
//  if Assigned(OnLogMessage) then
//  begin
//    OnLogMessage(Self, 'GUID - ' + GUID);
//    OnLogMessage(Self, 'Response - ' + Response);
//  end;

  if GUIDEvents.ContainsKey(GUID) then
  begin
    FEvent := GUIDEvents.Items[GUID];
    FEvent.SetEvent;
  end;
end;

function TZMQClient.GenerateGUID: String;
var MyGUID : TGUID;
begin
  CreateGUID(MyGUID);
  Result := GUIDToString(MyGUID);
end;

initialization

  ZMQClientLock := TCriticalSection.Create;

finalization

  if Assigned(ZMQClientLock) then
    FreeAndNil(ZMQClientLock);
end.
