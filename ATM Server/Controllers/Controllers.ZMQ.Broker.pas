unit Controllers.ZMQ.Broker;

interface

{$I Grijjy.inc}

uses
  System.SysUtils,
  System.Messaging,
  ZMQ.Shared,
  ZMQ.BrokerProtocol,
  PascalZMQ,
  System.Classes;

type
  TZMQBroker = class(TZMQBrokerProtocol)
  private
    procedure LogMessageListener(const Sender: TObject; const M: TMessage);

  protected
    { Receives a message from the Client }
    procedure DoRecvFromClient(const AService: String; const ASentFromId: String;
      const ASentFrom: PZFrame; var AMsg: PZMessage; var AAction: TZMQAction; var ASendToId: String); override;

    { Receives a message from the Worker }
    procedure DoRecvFromWorker(const AService: String; const ASentFromId: String;
      const ASentFrom: PZFrame; var AMsg: PZMessage; var AAction: TZMQAction); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var ZMQBroker: TZMQBroker;

implementation

{ TExampleBroker }

constructor TZMQBroker.Create;
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TZMQLogMessage, LogMessageListener);
end;

destructor TZMQBroker.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TZMQLogMessage, LogMessageListener);
  inherited;
end;

{ Out internal messages to the console }
procedure TZMQBroker.LogMessageListener(const Sender: TObject;
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
end;

{ This event is fired whenever a new message is received from a client }
procedure TZMQBroker.DoRecvFromClient(const AService: String; const ASentFromId: String;
  const ASentFrom: PZFrame; var AMsg: PZMessage; var AAction: TZMQAction; var ASendToId: String);
var AWorkerId: string;
begin
  if FindWorker(AService, AWorkerId) then
    AAction := TZMQAction.Forward
  else
  begin
    Synchronize(
      procedure
      begin
        raise Exception.Create('There is no worker for selected service');
      end);
  end;
end;

{ This event is fired whenever a new message is received from a worker }
procedure TZMQBroker.DoRecvFromWorker(const AService: String; const ASentFromId: String;
  const ASentFrom: PZFrame; var AMsg: PZMessage; var AAction: TZMQAction);
begin
  AAction := TZMQAction.Forward;
end;

end.
