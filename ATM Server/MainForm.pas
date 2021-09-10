unit MainForm;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, Winapi.Windows, Winapi.ShellApi, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp, IdSSLOpenSSL,
  System.IOUtils, MVCFramework.Logger, Controllers.Base, MVCFramework.Commons, uConfig, Controllers.ZMQ.Broker,
  Controllers.ZMQ.Client, System.SyncObjs;


type
  TSSLEventHandlers = class
    procedure OnGetSSLPassword(var APassword: string);
    procedure OnQuerySSLPort(APort: Word; var VUseSSL: boolean);
  end;

  TfrmMain = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    edtPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    cbUseSSL: TCheckBox;
    meLog: TMemo;
    GroupBox1: TGroupBox;
    lbBrokerAddress: TLabel;
    edBrokerAddress: TEdit;
    GroupBox2: TGroupBox;
    btnStart: TButton;
    Label6: TLabel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edServerName: TEdit;
    edLogin: TEdit;
    edDatabase: TEdit;
    edPassword: TEdit;
    btnTest: TButton;
    btnSaveChanges: TButton;
    btnStartAll: TButton;
    btnStopAll: TButton;
    btnDiscardChanges: TButton;
    lbZMQSample: TLabel;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure cbUseSSLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LogMessage(Sender: TObject; MessageText: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStartClick(Sender: TObject);
    procedure btnSaveChangesClick(Sender: TObject);
    procedure btnDiscardChangesClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnStartAllClick(Sender: TObject);
    procedure btnStopAllClick(Sender: TObject);
    procedure lbZMQSampleClick(Sender: TObject);
  private const
    OPENSSL_LIBS: array of string = ['libeay32.dll', 'ssleay32.dll'];
  private
    FSSLEventHandler : TSSLEventHandlers;
    FIOHandleSSL: TIdServerIOHandlerSSLOpenSSL;
    FServer: TIdHTTPWebBrokerBridge;
    FConfig: TConfig;
    procedure StartServer(const APort: Integer);
    procedure StartSSLServer(const APort: Integer);
    function CheckOpenSSLLibs: Boolean;
    procedure LoadSettings;
    procedure SaveSettings;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(ZMQBroker) then
  begin
    Action := caNone;
    ShowMessage('You should stop broker before closing');
  end;
  SaveSettings;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  FServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;
  FConfig := TConfig.Create;
  LoadSettings;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FSSLEventHandler) then
    FreeAndNil(FSSLEventHandler);
  if Assigned(FIOHandleSSL) then
    FreeAndNil(FIOHandleSSL);
  if Assigned(FServer) then
    FreeAndNil(FServer);
  if Assigned(FConfig) then
    FreeAndNil(FConfig);
end;

procedure TfrmMain.lbZMQSampleClick(Sender: TObject);
begin
  edBrokerAddress.Text := lbZMQSample.Caption;
end;

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
  if not Assigned(ZMQBroker) then
  begin
    if String(edBrokerAddress.Text).IsEmpty then
    begin
      ShowMessage('Enter Broker Address');
      Exit;
    end;
    ZMQBroker := TZMQBroker.Create;
    try
      ZMQBroker.OnLogMessage := LogMessage;
      ZMQBroker.Bind(edBrokerAddress.Text);
      bResult := true;
    except on E: Exception do
      begin
        LogMessage(Sender, E.Message);
        bResult := false;
      end;
    end;
    if not bResult then
    begin
      if Assigned(ZMQBroker) then
        FreeAndNil(ZMQBroker);
    end
    else
    begin
      ZMQClient := TZMQClient.Create;
      ZMQClient.OnLogMessage := LogMessage;
      ZMQClient.Connect(String(edBrokerAddress.Text).Replace('*', 'localhost'));
    end;
  end
  else
  begin
    if Assigned(ZMQBroker) then
      FreeAndNil(ZMQBroker);
    if Assigned(ZMQClient) then
      FreeAndNil(ZMQClient);
  end;
  if Assigned(ZMQBroker) then
  begin
    btnStart.Caption := 'Stop';
    edBrokerAddress.Enabled := false;
  end
  else
  begin
    btnStart.Caption := 'Start';
    edBrokerAddress.Enabled := true;
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
  if not Assigned(ZMQBroker) then
    btnStart.Click;
end;

procedure TfrmMain.btnStopAllClick(Sender: TObject);
begin
  if FServer.Active then
    ButtonStop.Click;
  if Assigned(ZMQBroker) then
    btnStart.Click;
end;

procedure TfrmMain.ButtonOpenBrowserClick(Sender: TObject);
var
  URL: string;
begin
  if cbUseSSL.Checked then
    URL := Format('https://localhost:%s/swagger', [edtPort.Text])
  else
    URL := Format('http://localhost:%s/swagger', [edtPort.Text]);
  ShellExecute(0, nil, PChar(URL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmMain.ButtonStartClick(Sender: TObject);
begin
  if cbUseSSL.Checked and not CheckOpenSSLLibs then
  begin
    ShowMessage('Library libeay32.dll or ssleay32.dll not found!');
    cbUseSSL.Checked := False;
  end;

  if cbUseSSL.Checked then
    StartSSLServer(StrToInt(edtPort.Text))
  else
    StartServer(StrToInt(edtPort.Text));
end;

procedure TfrmMain.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TfrmMain.cbUseSSLClick(Sender: TObject);
begin
  if cbUseSSL.Checked then
    edtPort.Text := '4433'
  else
    edtPort.Text := '8080';
end;

function TfrmMain.CheckOpenSSLLibs: Boolean;
var Lib: string;
begin
  Result := True;
  for  Lib in OPENSSL_LIBS do
    if not TFile.Exists(Lib) then
      Exit(False);
end;

procedure TfrmMain.StartSSLServer(const APort: Integer);
begin
  if not FServer.Active then
  begin
    if not Assigned(FSSLEventHandler) then
      FSSLEventHandler := TSSLEventHandlers.Create;
    if not Assigned(FIOHandleSSL) then
      FIOHandleSSL := TIdServerIOHandlerSSLOpenSSL.Create(FServer);
    FIOHandleSSL.SSLOptions.SSLVersions := [TIdSSLVersion.sslvSSLv23, TIdSSLVersion.sslvSSLv3, TIdSSLVersion.sslvTLSv1, TIdSSLVersion.sslvTLSv1_1, TIdSSLVersion.sslvTLSv1_2];
    FIOHandleSSL.SSLOptions.Mode := sslmServer;
    FIOHandleSSL.SSLOptions.CertFile := 'cacert.pem';
    FIOHandleSSL.SSLOptions.RootCertFile := '';
    FIOHandleSSL.SSLOptions.KeyFile := 'privkey.pem';
    FIOHandleSSL.OnGetPassword := FSSLEventHandler.OnGetSSLPassword;
    FServer.IOHandler := FIOHandleSSL;
    FServer.DefaultPort := APort;
    FServer.OnQuerySSLPort := FSSLEventHandler.OnQuerySSLPort;
    FServer.Active := True;
  end;
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

procedure TfrmMain.LoadSettings;
begin
  edBrokerAddress.Text := FConfig.BrokerAddress;
  edServerName.Text := FConfig.MSSQLServerName;
  edLogin.Text := FConfig.MSSQLLogin;
  edPassword.Text := FConfig.MSSQLPassword;
  edDatabase.Text := FConfig.MSSQLDatabase;
  cbUseSSL.Checked := FConfig.UseSSL;
  edtPort.Text := FConfig.PortNumber;
end;

procedure TfrmMain.LogMessage(Sender: TObject; MessageText: string);
begin
  meLog.Lines.Add(DateTimeToStr(Now) + ' - ' + MessageText);
end;

procedure TfrmMain.SaveSettings;
begin
  FConfig.BrokerAddress := edBrokerAddress.Text;
  FConfig.MSSQLServerName := edServerName.Text;
  FConfig.MSSQLLogin := edLogin.Text;
  FConfig.MSSQLPassword := edPassword.Text;
  FConfig.MSSQLDatabase := edDatabase.Text;
  FConfig.UseSSL := cbUseSSL.Checked;
  FConfig.PortNumber := edtPort.Text;
end;

{ TSSLEventHandlers }

procedure TSSLEventHandlers.OnGetSSLPassword(var APassword: string);
begin
  APassword := '';
end;

procedure TSSLEventHandlers.OnQuerySSLPort(APort: Word; var VUseSSL: boolean);
begin
  VUseSSL := True;
end;

end.
