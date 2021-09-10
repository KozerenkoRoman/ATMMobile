unit Entities.AtmIndex;

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  System.Classes;

type
  [MVCNameCase(ncLowerCase)]
  [MVCTable('AtmIndex')]
  [MVCEntityActions([eaCreate, eaRetrieve, eaUpdate, eaDelete])]
  TAtmIndex = class(TMVCActiveRecord)
  private
    [MVCTableField('Key_String', [foPrimaryKey])]
    FKey_String: string;
    [MVCTableField('YehusYear', [foPrimaryKey])]
    FYehusYear: Integer;
    [MVCTableField('Last_Number')]
    FLast_Number: Integer;
    [MVCTableField('Second_Number')]
    FSecond_Number: Currency;
    [MVCTableField('Date_1')]
    FDate_1: TDateTime {timestamp};
    [MVCTableField('Date_2')]
    FDate_2: TDateTime {timestamp};
    [MVCTableField('YehusMonth1')]
    FYehusMonth1: Integer;
    [MVCTableField('LastUpDate')]
    FLastUpDate: TDateTime {timestamp};
    [MVCTableField('MaklidName')]
    FMaklidName: string;
    [MVCTableField('Rem1')]
    FRem1: string;
    [MVCTableField('date_3')]
    Fdate_3: Integer;
    [MVCTableField('key_string_1')]
    Fkey_string_1: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Key_String: string read FKey_String write FKey_String;
    property YehusYear: Integer read FYehusYear write FYehusYear;
    property Last_Number: Integer read FLast_Number write FLast_Number;
    property Second_Number: Currency read FSecond_Number write FSecond_Number;
    property Date_1: TDateTime {timestamp} read FDate_1 write FDate_1;
    property Date_2: TDateTime {timestamp} read FDate_2 write FDate_2;
    property YehusMonth1: Integer read FYehusMonth1 write FYehusMonth1;
    property LastUpDate: TDateTime {timestamp} read FLastUpDate write FLastUpDate;
    property MaklidName: string read FMaklidName write FMaklidName;
    property Rem1: string read FRem1 write FRem1;
    property date_3: Integer read Fdate_3 write Fdate_3;
    property key_string_1: string read Fkey_string_1 write Fkey_string_1;
  end;

implementation

constructor TAtmIndex.Create;
begin
  inherited Create;
end;

destructor TAtmIndex.Destroy;
begin
  inherited;
end;

initialization
  ActiveRecordMappingRegistry.AddEntity('atmindex', TAtmIndex);

end.
