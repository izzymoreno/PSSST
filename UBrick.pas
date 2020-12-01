Unit UBrick;

interface

Uses

Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uConstant, USunflower, UWeapon;

Const

//������������ �������� �������� �����
MaxImageBrick = 1;

type
  TBrick = class (TObject)
  public
    //������ �������� �����
    Weapon: TWeapon;
    Direction: TBrickDirection;
    ImgMassLeftBrick: array[0..MaxImageBrick-1] of TBitMap;
    ImgMassRightBrick: array[0..MaxImageBrick-1] of TBitMap;
    XBrick, YBrick: integer;
    owner:TObject;
    XOffset, YOffset: integer;
    procedure Show;
    Constructor CreateBrick(X,Y: integer; BrickDirection:TBrickDirection; ownerForm: TObject);
    Destructor Destroy(); override;
  end;

implementation

Uses Unit1, UOwl;

constructor TBrick.CreateBrick(X, Y:integer; BrickDirection:TBrickDirection; ownerForm: TObject);
var
i:integer;
begin
//���������� X � Y ��� ������
XBrick:=X;
YBrick:=Y;
//��������� ��� ������� ������ ��� �����
For i:=0 to MaxImageBrick-1 Do
   begin
   ImgMassLeftBrick[i]:=TBitMap.Create;
   ImgMassLeftBrick[i].LoadFromFile('LBrick'+IntToStr(i+1)+'.bmp');
   ImgMassLeftBrick[i].Transparent:=True;
   ImgMassLeftBrick[i].TransparentMode:=tmFixed;
   ImgMassLeftBrick[i].TransparentColor:=clBlack;
   end;
//��������� ��� ������� ������ ��� ������
For i:=0 to MaxImageBrick-1 Do
   begin
   ImgMassRightBrick[i]:=TBitMap.Create;
   ImgMassRightBrick[i].LoadFromFile('RBrick'+IntToStr(i+1)+'.bmp');
   ImgMassRightBrick[i].Transparent:=True;
   ImgMassRightBrick[i].TransparentMode:=tmFixed;
   ImgMassRightBrick[i].TransparentColor:=clBlack;
   end;
Direction := BrickDirection;
Weapon := nil;
XOffset :=15;
YOffset :=0;
end;

procedure TBrick.Show;
begin
If (Direction=directionBrickLeft) then
   begin
   VirtBitmap.Canvas.Draw(self.XBrick, self.YBrick, self.ImgMassLeftBrick[0]);
   end;

If (Direction=directionBrickRight) then
   begin
   VirtBitmap.Canvas.Draw(self.XBrick, self.YBrick, self.ImgMassRightBrick[0]);
   end;
end;

destructor TBrick.Destroy;
var
i:byte;
begin
//����� �� ������� �� ������ ������
For i:=0 to MaxImageBrick - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if ImgMassLeftBrick[i] <> nil then Freeandnil(ImgMassLeftBrick[i]);
   end;
For i:=0 to MaxImageBrick - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if ImgMassRightBrick[i] <> nil then Freeandnil(ImgMassRightBrick[i]);
   end;
//����� ����������� ������������� ������
inherited;
end;

end.
