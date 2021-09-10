object dmCentral: TdmCentral
  OldCreateOrder = False
  Height = 316
  Width = 425
  object Connection: TFDConnection
    Params.Strings = (
      'Protocol=TCPIP'
      'Server=localhost'
      'CharacterSet=UTF8'
      'ServerCharSet=UTF8'
      'DriverID=MSSQL'
      'Database=Central'
      'Password=111'
      'ODBCAdvanced=AutoTranslate=yes'
      'User_Name=sa')
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtAnsiString
        TargetDataType = dtWideString
      end>
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 64
    Top = 40
  end
end
