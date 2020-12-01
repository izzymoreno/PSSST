object Form1: TForm1
  Left = 0
  Top = 0
  ClientHeight = 551
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 674
    Height = 551
    Align = alClient
    OnClick = Image1Click
    ExplicitLeft = -8
    ExplicitTop = 8
    ExplicitHeight = 531
  end
  object TimerFPS: TTimer
    Enabled = False
    Interval = 20
    OnTimer = TimerFPSTimer
  end
  object TimerBullets: TTimer
    Interval = 1
    OnTimer = TimerBulletsTimer
    Left = 56
  end
end
