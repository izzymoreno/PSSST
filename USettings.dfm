object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 633
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 336
    Width = 108
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1089#1090#1074#1086' '#1075#1091#1089#1077#1085#1080#1094
  end
  object Label2: TLabel
    Left = 32
    Top = 400
    Width = 95
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1084#1091#1096#1077#1082
  end
  object Label3: TLabel
    Left = 32
    Top = 24
    Width = 71
    Height = 13
    Caption = #1040#1074#1090#1086#1088#1099' '#1080#1075#1088#1099':'
  end
  object Label4: TLabel
    Left = 32
    Top = 43
    Width = 131
    Height = 13
    Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1080#1089#1090': Izzy Moreno'
  end
  object Label5: TLabel
    Left = 32
    Top = 72
    Width = 111
    Height = 13
    Caption = #1061#1091#1076#1086#1078#1085#1080#1082': Dart Hydra'
  end
  object Label6: TLabel
    Left = 32
    Top = 208
    Width = 107
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1080#1084#1103' '#1048#1075#1088#1086#1082#1072':'
  end
  object TrackBarWorms: TTrackBar
    Left = 30
    Top = 361
    Width = 163
    Height = 25
    Max = 20
    Min = 1
    Position = 1
    TabOrder = 0
    OnChange = TrackBarWormsChange
  end
  object TrackBarFlyes: TTrackBar
    Left = 32
    Top = 430
    Width = 163
    Height = 30
    Max = 20
    Min = 1
    Position = 1
    TabOrder = 1
    OnChange = TrackBarFlyesChange
  end
  object Button1: TButton
    Left = 32
    Top = 466
    Width = 162
    Height = 49
    Caption = #1053#1072#1095#1072#1090#1100' '#1080#1075#1088#1091
    TabOrder = 2
    OnClick = Button1Click
  end
  object EditWorms: TEdit
    Left = 146
    Top = 328
    Width = 49
    Height = 21
    TabOrder = 3
    Text = '1'
  end
  object Button2: TButton
    Left = 32
    Top = 576
    Width = 163
    Height = 49
    Caption = #1042#1099#1081#1090#1080' '#1080#1079' '#1080#1075#1088#1099
    TabOrder = 4
    OnClick = Button2Click
  end
  object EditFlyes: TEdit
    Left = 143
    Top = 392
    Width = 52
    Height = 21
    TabOrder = 5
    Text = '1'
  end
  object RadioGroup1: TRadioGroup
    Left = 30
    Top = 249
    Width = 147
    Height = 73
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1077#1088#1089#1086#1085#1072#1078#1072' '#1080#1075#1088#1099
    ItemIndex = 0
    Items.Strings = (
      #1057#1086#1074#1105#1085#1086#1082
      #1042#1086#1088#1086#1085#1105#1085#1086#1082)
    TabOrder = 6
  end
  object Button3: TButton
    Left = 32
    Top = 521
    Width = 163
    Height = 49
    Caption = #1058#1072#1073#1083#1080#1094#1072' '#1056#1077#1082#1086#1088#1076#1086#1074
    TabOrder = 7
    OnClick = Button3Click
  end
  object EditPlayerName: TEdit
    Left = 143
    Top = 200
    Width = 81
    Height = 21
    TabOrder = 8
    Text = #1048#1075#1088#1086#1082'1'
  end
end
