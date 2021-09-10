unit uData;

interface

uses
  System.SysUtils, System.Classes, uConfig, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet;

type
  TdmData = class(TDataModule)
    Connection: TFDConnection;
    qAtmIndex: TFDQuery;
    updAtmIndex: TFDUpdateSQL;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FConfig: TConfig;
  public
    { Public declarations }
    property Config: TConfig read FConfig;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  FConfig := TConfig.Create;
end;

procedure TdmData.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(FConfig) then
    FreeAndNil(FConfig);
end;

end.
