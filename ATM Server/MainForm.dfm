object frmMain: TfrmMain
  Left = 271
  Top = 114
  Caption = 'ATM Server'
  ClientHeight = 510
  ClientWidth = 618
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
    Width = 618
    Height = 53
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'ATM Server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitLeft = -135
    ExplicitWidth = 783
  end
  object meLog: TMemo
    Left = 8
    Top = 318
    Width = 598
    Height = 181
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 220
    Top = 58
    Width = 386
    Height = 75
    Caption = 'ZeroMQ settings'
    TabOrder = 1
    object lbBrokerAddress: TLabel
      Left = 16
      Top = 27
      Width = 77
      Height = 13
      Caption = 'Broker Address:'
    end
    object lbZMQSample: TLabel
      Left = 104
      Top = 45
      Width = 61
      Height = 13
      Cursor = crHandPoint
      Caption = 'tcp://*:1234'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
      OnClick = lbZMQSampleClick
    end
    object edBrokerAddress: TEdit
      Left = 102
      Top = 24
      Width = 183
      Height = 21
      TabOrder = 0
    end
    object btnStart: TButton
      Left = 293
      Top = 24
      Width = 77
      Height = 21
      Caption = 'Start'
      TabOrder = 1
      OnClick = btnStartClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 58
    Width = 201
    Height = 186
    Caption = 'Web settings'
    TabOrder = 2
    object Label1: TLabel
      Left = 24
      Top = 62
      Width = 20
      Height = 13
      Caption = 'Port'
    end
    object ButtonOpenBrowser: TButton
      Left = 22
      Top = 150
      Width = 107
      Height = 25
      Caption = 'Open Browser'
      TabOrder = 0
      OnClick = ButtonOpenBrowserClick
    end
    object ButtonStart: TButton
      Left = 24
      Top = 22
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 1
      OnClick = ButtonStartClick
    end
    object ButtonStop: TButton
      Left = 105
      Top = 22
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 2
      OnClick = ButtonStopClick
    end
    object cbUseSSL: TCheckBox
      Left = 24
      Top = 108
      Width = 97
      Height = 17
      Caption = 'Use SSL'
      TabOrder = 3
      OnClick = cbUseSSLClick
    end
    object edtPort: TEdit
      Left = 24
      Top = 81
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '8080'
    end
  end
  object GroupBox3: TGroupBox
    Left = 220
    Top = 140
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
    Top = 265
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
    Left = 90
    Top = 265
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
    Left = 16
    Top = 8
  end
end
