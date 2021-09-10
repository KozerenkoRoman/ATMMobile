unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uData, Controllers.ZMQ.Worker, PascalZMQ,
  IdHTTPWebBrokerBridge, Web.HTTPApp, ShellApi, Vcl.AppEvnts, uConfig;

type
  TfrmMain = class(TForm)
    meLog: TMemo;
    ApplicationEvents1: TApplicationEvents;
    gbZMQ: TGroupBox;
    lbBrokerAddress: TLabel;
    lbServiceName: TLabel;
    edServiceName: TEdit;
    edBrokerAddress: TEdit;
    gbWeb: TGroupBox;
    Label1: TLabel;
    edtPort: TEdit;
    ButtonOpenBrowser: TButton;
    ButtonStart: TButton;
    ButtonStop: TButton;
    btnStart: TButton;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    edServerName: TEdit;
    Label3: TLabel;
    edLogin: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edDatabase: TEdit;
    edPassword: TEdit;
    btnTest: TButton;
    btnStartAll: TButton;
    btnStopAll: TButton;
    btnSaveChanges: TButton;
    Label6: TLabel;
    btnDiscardChanges: TButton;
    lbZMQSample: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStartClick(Sender: TObject);
    procedure LogMessage(Sender: TObject; MessageText: string);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure btnSaveChangesClick(Sender: TObject);
    procedure btnDiscardChangesClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnStartAllClick(Sender: TObject);
    procedure btnStopAllClick(Sender: TObject);
    procedure lbZMQSampleClick(Sender: TObject);
  private
    { Private declarations }
    FWorker: TWorker;
    FServer: TIdHTTPWebBrokerBridge;
    FConfig: TConfig;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure StartServer(const APort: Integer);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  edtPort.Enabled := not FServer.Active;
end;

procedure TfrmMain.btnDiscardChangesClick(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfrmMain.btnSaveChangesClick(Sender: TObject);
begin
  SaveSettings;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
var bResult: boolean;
begin
  if not Assigned(FWorker) then
  begin
    if String(edBrokerAddress.Text).IsEmpty then
    begin
      ShowMessage('Enter Broker Address');
      Exit;
    end;
    if String(edServiceName.Text).IsEmpty then
    begin
      ShowMessage('Enter Service Name');
      Exit;
    end;
    meLog.Clear;
    FWorker := TWorker.Create;
    try
      FWorker.OnLogMessage := LogMessage;
      FWorker.Connect(edBrokerAddress.Text, '', TZSocketType.Dealer, edServiceName.Text);
      bResult := true;
    except on E: Exception do
      begin
        LogMessage(Sender, E.Message);
        bResult := false;
      end;
    end;
    if not bResult then
    begin
      if Assigned(FWorker) then
        FreeAndNil(FWorker);
    end;
  end
  else
  begin
    if Assigned(FWorker) then
      FreeAndNil(FWorker);
  end;
  if Assigned(FWorker) then
  begin
    btnStart.Caption := 'Stop';
    edBrokerAddress.Enabled := false;
    edServiceName.Enabled := false;
  end
  else
  begin
    btnStart.Caption := 'Start';
    edBrokerAddress.Enabled := true;
    edServiceName.Enabled := true;
  end;
end;

procedure TfrmMain.btnTestClick(Sender: TObject);
begin
  TestConnection(edServerName.Text, edLogin.Text, edPassword.Text, edDatabase.Text);
end;

procedure TfrmMain.btnStartAllClick(Sender: TObject);
begin
  if not FServer.Active then
    ButtonStart.Click;
  if not Assigned(FWorker) then
    btnStart.Click;
end;

procedure TfrmMain.btnStopAllClick(Sender: TObject);
begin
  if FServer.Active then
    ButtonStop.Click;
  if Assigned(FWorker) then
    btnStart.Click;
end;

procedure TfrmMain.ButtonOpenBrowserClick(Sender: TObject);
var
  URL: string;
begin
  URL := Format('http://localhost:%s/swagger', [edtPort.Text]);
  ShellExecute(0, nil, PChar(URL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmMain.ButtonStartClick(Sender: TObject);
begin
  StartServer(StrToInt(edtPort.Text));
end;

procedure TfrmMain.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TfrmMain.StartServer(const APort: Integer);
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := APort;
    FServer.Active := True;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FWorker) then
  begin
    Action := caNone;
    ShowMessage('You should stop worker before closing');
  end;
  SaveSettings;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  FConfig := TConfig.Create;
  LoadSettings;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FServer) then
    FreeAndNil(FServer);
  if Assigned(FConfig) then
    FreeAndNil(FConfig);
end;

procedure TfrmMain.lbZMQSampleClick(Sender: TObject);
begin
  edBrokerAddress.Text := lbZMQSample.Caption;
end;

procedure TfrmMain.LoadSettings;
begin
  edBrokerAddress.Text := FConfig.BrokerAddress;
  edServiceName.Text := FConfig.ServiceName;
  edServerName.Text := FConfig.MSSQLServerName;
  edLogin.Text := FConfig.MSSQLLogin;
  edPassword.Text := FConfig.MSSQLPassword;
  edDatabase.Text := FConfig.MSSQLDatabase;
  edtPort.Text := FConfig.PortNumber;
end;

procedure TfrmMain.LogMessage(Sender: TObject; MessageText: string);
begin
  meLog.Lines.Add(DateTimeToStr(Now) + ' - ' + MessageText);
end;

procedure TfrmMain.SaveSettings;
begin
  FConfig.BrokerAddress := edBrokerAddress.Text;
  FConfig.ServiceName := edServiceName.Text;
  FConfig.MSSQLServerName := edServerName.Text;
  FConfig.MSSQLLogin := edLogin.Text;
  FConfig.MSSQLPassword := edPassword.Text;
  FConfig.MSSQLDatabase := edDatabase.Text;
  FConfig.PortNumber := edtPort.Text;
end;

end.

