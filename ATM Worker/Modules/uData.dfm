object dmData: TdmData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 306
  Width = 440
  object Connection: TFDConnection
    Params.Strings = (
      'Server=(local)\SQLEXPRESS'
      'Password=1111'
      'User_Name=sa'
      'Database=Ben'
      'DriverID=MSSQL')
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
  object qAtmIndex: TFDQuery
    Connection = Connection
    FormatOptions.AssignedValues = [fvSortLocale]
    FormatOptions.SortLocale = 1255
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'GEN_ARTICOLI_ID'
    UpdateOptions.UpdateTableName = 'ARTICOLI'
    UpdateOptions.KeyFields = 'ID'
    UpdateObject = updAtmIndex
    SQL.Strings = (
      'SELECT *'
      ' FROM AtmIndex')
    Left = 136
    Top = 40
  end
  object updAtmIndex: TFDUpdateSQL
    Connection = Connection
    InsertSQL.Strings = (
      'INSERT INTO BEN.dbo.AtmIndex'
      '(Key_String, YehusYear, Last_Number, LastUpDate, MaklidName)'
      
        'VALUES (:NEW_Key_String, :NEW_YehusYear, :NEW_Last_Number, :NEW_' +
        'LastUpDate, '
      '  :NEW_MaklidName)')
    ModifySQL.Strings = (
      'UPDATE BEN.dbo.AtmIndex'
      
        'SET Key_String = :NEW_Key_String, YehusYear = :NEW_YehusYear, La' +
        'st_Number = :NEW_Last_Number, '
      '  LastUpDate = :NEW_LastUpDate'
      
        'WHERE Key_String = :OLD_Key_String AND YehusYear = :OLD_YehusYea' +
        'r')
    DeleteSQL.Strings = (
      'DELETE FROM BEN.dbo.AtmIndex'
      
        'WHERE Key_String = :OLD_Key_String AND YehusYear = :OLD_YehusYea' +
        'r')
    FetchRowSQL.Strings = (
      
        'SELECT Key_String, YehusYear, Last_Number, LastUpDate, MaklidNam' +
        'e'
      'FROM (select * from Ben.dbo.AtmIndex) '
      
        'WHERE Key_String = :OLD_Key_String AND YehusYear = :OLD_YehusYea' +
        'r')
    Left = 136
    Top = 104
  end
end
