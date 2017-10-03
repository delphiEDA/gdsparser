object frm_simple_gdsparser: Tfrm_simple_gdsparser
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmo_debug: TMemo
    Left = 0
    Top = 97
    Width = 887
    Height = 446
    Align = alClient
    Lines.Strings = (
      '****  GDS PARSER ****')
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitTop = 103
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
      Caption = 'Load GDS_FILE'
      TabOrder = 0
      OnClick = btn_LoadGDS_FILEClick
    end
  end
  object statGDSBrowser: TStatusBar
    Left = 0
    Top = 543
    Width = 887
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object dlgOpenGDS: TOpenDialog
    Left = 512
    Top = 200
  end
end
