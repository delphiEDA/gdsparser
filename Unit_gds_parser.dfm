object frm_simple_gds_parser1: Tfrm_simple_gds_parser1
  Left = 0
  Top = 0
  Caption = 'simple gds parser'
  ClientHeight = 562
  ClientWidth = 887
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmo_debug: TMemo
    Left = 0
    Top = 97
    Width = 887
    Height = 465
    Align = alClient
    Lines.Strings = (
      'mmo_debug')
    TabOrder = 0
    ExplicitTop = 272
    ExplicitWidth = 889
    ExplicitHeight = 273
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 887
    Height = 97
    Align = alTop
    Color = clLime
    ParentBackground = False
    TabOrder = 1
    object btn_LoadGDS_FILE: TBitBtn
      Left = 32
      Top = 20
      Width = 169
      Height = 60
      Caption = 'LoadGDS_FILE'
      TabOrder = 0
      OnClick = btn_LoadGDS_FILEClick
    end
  end
  object dlgOpenGDS: TOpenDialog
    Left = 512
    Top = 200
  end
end
