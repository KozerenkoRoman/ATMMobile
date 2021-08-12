unit MainDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Phys.FBDef, System.IOUtils, MVCFramework.DataSet.Utils, FireDAC.VCLUI.Wait, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef;

type
  TdmMain = class(TDataModule)
    Connection: TFDConnection;
    qAtmIndex: TFDQuery;
    updAtmIndex: TFDUpdateSQL;
  private
    { Private declarations }
  public
    function SearchProducts(const SearchText: string): TDataSet;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TdmMain.SearchProducts(const SearchText: string): TDataSet;
begin
  Result := nil;
  // Result := TFDMemTable.Create(nil);
  // if SearchText.IsEmpty then
  // dsAmil.Open('SELECT * FROM Amil')
  // else
  // dsAmil.Open('SELECT * FROM Amil WHERE AmilName CONTAINING ?', [SearchText]);
  // TFDTable(Result).CopyDataSet(dsAmil, [coStructure, coRestart, coAppend]);
end;

end.
