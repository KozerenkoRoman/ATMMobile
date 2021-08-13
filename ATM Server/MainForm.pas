unit MainForm;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, Winapi.Windows, Winapi.ShellApi, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp, IdSSLOpenSSL,
  System.IOUtils, MVCFramework.Logger;

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
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure cbUseSSLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private const
    OPENSSL_LIBS: array of string = ['libeay32.dll', 'ssleay32.dll'];
  private
    FSSLEventHandler : TSSLEventHandlers;
    FIOHandleSSL: TIdServerIOHandlerSSLOpenSSL;
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer(const APort: Integer);
    procedure StartSSLServer(const APort: Integer);
    function CheckOpenSSLLibs: Boolean;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FSSLEventHandler) then
    FreeAndNil(FSSLEventHandler);
  if Assigned(FIOHandleSSL) then
    FreeAndNil(FIOHandleSSL);
  if Assigned(FServer) then
    FreeAndNil(FServer);
end;

procedure TfrmMain.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  edtPort.Enabled := not FServer.Active;
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
begin
  Result := True;
  for var Lib in OPENSSL_LIBS do
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
