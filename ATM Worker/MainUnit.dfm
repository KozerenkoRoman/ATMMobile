object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'ATM Worker'
  ClientHeight = 543
  ClientWidth = 783
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 0
    Top = 0
    Width = 783
    Height = 53
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'ATM Worker'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object meLog: TMemo
    Left = 8
    Top = 350
    Width = 761
    Height = 185
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object gbZMQ: TGroupBox
    Left = 8
    Top = 62
    Width = 369
    Height = 139
    Caption = 'ZeroMQ settings'
    TabOrder = 1
    object lbBrokerAddress: TLabel
      Left = 16
      Top = 25
      Width = 77
      Height = 13
      Caption = 'Broker Address:'
    end
    object lbServiceName: TLabel
      Left = 16
      Top = 69
      Width = 69
      Height = 13
      Caption = 'Service Name:'
    end
    object lbZMQSample: TLabel
      Left = 104
      Top = 45
      Width = 97
      Height = 13
      Cursor = crHandPoint
      Caption = 'tcp://localhost:1234'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
      OnClick = lbZMQSampleClick
    end
    object edServiceName: TEdit
      Left = 102
      Top = 66
      Width = 254
      Height = 21
      TabOrder = 0
    end
    object edBrokerAddress: TEdit
      Left = 102
      Top = 22
      Width = 254
      Height = 21
      TabOrder = 1
    end
    object btnStart: TButton
      Left = 16
      Top = 97
      Width = 77
      Height = 25
      Caption = 'Start'
      TabOrder = 2
      OnClick = btnStartClick
    end
  end
  object gbWeb: TGroupBox
    Left = 383
    Top = 62
    Width = 386
    Height = 104
    Caption = 'Web settings'
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 26
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object edtPort: TEdit
      Left = 102
      Top = 23
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '1235'
    end
    object ButtonOpenBrowser: TButton
      Left = 240
      Top = 23
      Width = 107
      Height = 21
      Caption = 'Open Browser'
      TabOrder = 1
      OnClick = ButtonOpenBrowserClick
    end
    object ButtonStart: TButton
      Left = 16
      Top = 61
      Width = 77
      Height = 25
      Caption = 'Start'
      TabOrder = 2
      OnClick = ButtonStartClick
    end
    object ButtonStop: TButton
      Left = 99
      Top = 61
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 3
      OnClick = ButtonStopClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 383
    Top = 172
    Width = 386
    Height = 172
    Caption = 'MSSQL settings'
    TabOrder = 3
    object Label2: TLabel
      Left = 16
      Top = 28
      Width = 66
      Height = 13
      Caption = 'Server Name:'
    end
    object Label3: TLabel
      Left = 16
      Top = 55
      Width = 29
      Height = 13
      Caption = 'Login:'
    end
    object Label4: TLabel
      Left = 16
      Top = 83
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Label5: TLabel
      Left = 16
      Top = 110
      Width = 50
      Height = 13
      Caption = 'Database:'
    end
    object edServerName: TEdit
      Left = 116
      Top = 25
      Width = 254
      Height = 21
      TabOrder = 0
    end
    object edLogin: TEdit
      Left = 116
      Top = 52
      Width = 254
      Height = 21
      TabOrder = 1
    end
    object edDatabase: TEdit
      Left = 116
      Top = 107
      Width = 254
      Height = 21
      TabOrder = 2
    end
    object edPassword: TEdit
      Left = 116
      Top = 80
      Width = 254
      Height = 21
      TabOrder = 3
    end
    object btnTest: TButton
      Left = 16
      Top = 136
      Width = 75
      Height = 25
      Caption = 'Test'
      TabOrder = 4
      OnClick = btnTestClick
    end
    object btnSaveChanges: TButton
      Left = 116
      Top = 136
      Width = 102
      Height = 25
      Caption = 'Save changes'
      TabOrder = 5
      OnClick = btnSaveChangesClick
    end
    object btnDiscardChanges: TButton
      Left = 224
      Top = 136
      Width = 102
      Height = 25
      Caption = 'Discard changes'
      TabOrder = 6
      OnClick = btnDiscardChangesClick
    end
  end
  object btnStartAll: TButton
    Left = 8
    Top = 298
    Width = 75
    Height = 25
    Caption = 'Start All'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnStartAllClick
  end
  object btnStopAll: TButton
    Left = 89
    Top = 298
    Width = 75
    Height = 25
    Caption = 'Stop All'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnStopAllClick
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 48
    Top = 200
  end
end
