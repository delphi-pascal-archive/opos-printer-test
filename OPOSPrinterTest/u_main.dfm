object OPOSPrinterTest: TOPOSPrinterTest
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'OPOSPrinterTest'
  ClientHeight = 460
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 87
    Height = 13
    Caption = #1042#1099#1073#1086#1088' '#1087#1088#1080#1085#1090#1077#1088#1072':'
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 27
    Width = 225
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 54
    Width = 225
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 81
    Width = 225
    Height = 25
    Caption = #1042#1086#1079#1073#1091#1076#1080#1090#1100' (0)'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 108
    Width = 225
    Height = 25
    Caption = #1040#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1086' (true)'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button8: TButton
    Left = 8
    Top = 135
    Width = 225
    Height = 25
    Caption = #1054#1073#1088#1072#1079#1077#1094' '#1087#1077#1095#1072#1090#1080
    TabOrder = 4
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 8
    Top = 162
    Width = 225
    Height = 25
    Caption = #1042#1099#1082#1083#1102#1095#1080#1090#1100' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1086' (FALSE)'
    TabOrder = 5
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 8
    Top = 189
    Width = 225
    Height = 25
    Caption = #1054#1089#1074#1086#1073#1086#1076#1080#1090#1100
    TabOrder = 6
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 8
    Top = 216
    Width = 225
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 7
    OnClick = Button11Click
  end
  object Memo1: TMemo
    Left = 239
    Top = 27
    Width = 289
    Height = 418
    ScrollBars = ssBoth
    TabOrder = 8
    OnChange = Memo1Change
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 254
    Width = 97
    Height = 17
    Caption = 'CoverOpen'
    Enabled = False
    TabOrder = 9
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 275
    Width = 97
    Height = 17
    Caption = 'JrnEmpty'
    Enabled = False
    TabOrder = 10
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 296
    Width = 97
    Height = 17
    Caption = 'RecEmty'
    Enabled = False
    TabOrder = 11
  end
  object CheckBox4: TCheckBox
    Left = 8
    Top = 317
    Width = 97
    Height = 17
    Caption = 'SlpEmpty'
    Enabled = False
    TabOrder = 12
  end
  object CheckBox5: TCheckBox
    Left = 8
    Top = 338
    Width = 97
    Height = 17
    Caption = 'FlagWhenIdle'
    Enabled = False
    TabOrder = 13
  end
  object RadioButton1: TRadioButton
    Left = 120
    Top = 275
    Width = 113
    Height = 17
    Caption = 'Journal'
    Enabled = False
    TabOrder = 14
  end
  object RadioButton2: TRadioButton
    Left = 120
    Top = 296
    Width = 113
    Height = 17
    Caption = 'Reseipt'
    Enabled = False
    TabOrder = 15
  end
  object RadioButton3: TRadioButton
    Left = 120
    Top = 317
    Width = 113
    Height = 17
    Caption = 'Slip'
    Enabled = False
    TabOrder = 16
  end
  object POSPrinter1: TPOSPrinter
    Left = 8
    Top = 413
    Width = 32
    Height = 32
    OnErrorEvent = POSPrinter1ErrorEvent
    OnStatusUpdateEvent = POSPrinter1StatusUpdateEvent
    ControlData = {00000100560A00002B05000000000000}
  end
  object btn1: TButton
    Left = 96
    Top = 388
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 18
    OnClick = btn1Click
  end
end
