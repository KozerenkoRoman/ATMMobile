unit Controllers.MemoryWebSession;

interface

uses
  System.Classes, System.SysUtils, MVCFramework.Session;

type
  TWebSessionMemoryController = class(TWebSessionMemory)
  private
    FList: TStringList;
  public
    constructor Create(const SessionID: string; const Timeout: UInt64); override;
    destructor Destroy; override;
    property List: TStringList read FList;
  end;

implementation

{ TWebSessionMemoryController }

constructor TWebSessionMemoryController.Create(const SessionID: string; const Timeout: UInt64);
begin
  inherited Create(SessionID, Timeout);
  FList := TStringList.Create;
end;

destructor TWebSessionMemoryController.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

initialization
  TMVCSessionFactory.GetInstance.RegisterSessionType('memoryController', TWebSessionMemoryController);

end.
