unit uConfig;

interface

uses SysUtils, IniFiles, Forms, Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

type TConfig = class
  private
    FIniFile: TIniFile;
    function GetBrokerAddress: string;
    procedure SetBrokerAddress(const Value: string);
    function GetServiceName: string;
    procedure SetServiceName(const Value: string);
    function GetMSSQLServerName: string;
    procedure SetMSSQLServerName(const Value: string);
    function GetMSSQLLogin: string;
    procedure SetMSSQLLogin(const Value: string);
    function GetMSSQLPassword: string;
    procedure SetMSSQLPassword(const Value: string);
    function GetMSSQLDatabase: string;
    procedure SetMSSQLPDatabase(const Value: string);
    function GetUseSSL: boolean;
    procedure SetUseSSL(const Value: boolean);
    function GetPortNumber: string;
    procedure SetPortNumber(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property BrokerAddress: string read GetBrokerAddress write SetBrokerAddress;
    property ServiceName: string read GetServiceName write SetServiceName;
    property MSSQLServerName: string read GetMSSQLServerName write SetMSSQLServerName;
    property MSSQLLogin: string read GetMSSQLLogin write SetMSSQLLogin;
    property MSSQLPassword: string read GetMSSQLPassword write SetMSSQLPassword;
    property MSSQLDatabase: string read GetMSSQLDatabase write SetMSSQLPDatabase;
    property UseSSL: boolean read GetUseSSL write SetUseSSL;
    property PortNumber: string read GetPortNumber write SetPortNumber;
end;

procedure TestConnection(AServerName, ALogin, APassword,
  ADatabase: string);

implementation

procedure TestConnection(AServerName, ALogin, APassword,
  ADatabase: string);
var FConn: TFDConnection;
begin
  FConn := TFDConnection.Create(nil);
  try
    try
      with FConn.Params do begin
        Clear;
        Add('DriverID=MSSQL');
        Add('Server='+ AServerName);
        Add('Database='+ ADatabase);
        if not ALogin.IsEmpty then
          Add('User_Name='+ ALogin);
        if not APassword.IsEmpty then
          Add('Password='+ APassword);
      end;
      FConn.Open;
      ShowMessage('Connection established successfully');
    except on E: Exception do
      ShowMessage(E.Message);
    end;
  finally
    FConn.Free;
  end;
end;

{ TConfig }

constructor TConfig.Create;
begin
  FIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
end;

destructor TConfig.Destroy;
begin
  if Assigned(FIniFile) then
    FreeAndNil(FIniFile);
  inherited;
end;

function TConfig.GetBrokerAddress: string;
begin
  Result := FIniFile.ReadString('Main', 'BrokerAddress', '');
end;

function TConfig.GetMSSQLDatabase: string;
begin
  Result := FIniFile.ReadString('MSSQL', 'Database', '');
end;

function TConfig.GetMSSQLLogin: string;
begin
  Result := FIniFile.ReadString('MSSQL', 'Login', '');
end;

function TConfig.GetMSSQLPassword: string;
begin
  Result := FIniFile.ReadString('MSSQL', 'Password', '');
end;

function TConfig.GetMSSQLServerName: string;
begin
  Result := FIniFile.ReadString('MSSQL', 'ServerName', '');
end;

function TConfig.GetPortNumber: string;
begin
  Result := FIniFile.ReadString('Main', 'PortNumber', '8080');
end;

function TConfig.GetServiceName: string;
begin
  Result := FIniFile.ReadString('Main', 'ServiceName', '');
end;

function TConfig.GetUseSSL: boolean;
begin
  Result := SameText(FIniFile.ReadString('Main', 'UseSSL', ''), 'true');
end;

procedure TConfig.SetBrokerAddress(const Value: string);
begin
  FIniFile.WriteString('Main', 'BrokerAddress', Value);
end;

procedure TConfig.SetMSSQLLogin(const Value: string);
begin
  FIniFile.WriteString('MSSQL', 'Login', Value);
end;

procedure TConfig.SetMSSQLPassword(const Value: string);
begin
  FIniFile.WriteString('MSSQL', 'Password', Value);
end;

procedure TConfig.SetMSSQLPDatabase(const Value: string);
begin
  FIniFile.WriteString('MSSQL', 'Database', Value);
end;

procedure TConfig.SetMSSQLServerName(const Value: string);
begin
  FIniFile.WriteString('MSSQL', 'ServerName', Value);
end;

procedure TConfig.SetPortNumber(const Value: string);
begin
  FIniFile.WriteString('Main', 'PortNumber', Value);
end;

procedure TConfig.SetServiceName(const Value: string);
begin
  FIniFile.WriteString('Main', 'ServiceName', Value);
end;

procedure TConfig.SetUseSSL(const Value: boolean);
begin
  if Value then
    FIniFile.WriteString('Main', 'UseSSL', 'true')
  else
    FIniFile.WriteString('Main', 'UseSSL', 'false');
end;

end.
