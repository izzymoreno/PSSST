unit UWeapon;

interface

Uses

Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uConstant, USunflower;

type
  TWeapon = class (TObject)
  public
    //������ �������� ������
    Direction: TMoveDirection;
    WeaponType: TWeaponType;
    ImgMassLeft: array[0..0] of TBitMap;
    ImgMassRight: array[0..0] of TBitMap;
    XWeapon, YWeapon: integer;
    WeaponinBox: boolean;
//    ������������ ������ � �������� ����
//    ����� ���������� �������� ������ ������ ����������
    WeaponOwner: pointer;//TObject;
    XOffset, YOffset: integer;
    Procedure WeaponDown(Owl: TObject; Brick: TObject);
    procedure WeaponTouch(Player: TObject; Brick: TObject);
    procedure Show;
    Constructor CreateWeapon(X,Y: integer; MoveDirection:TMoveDirection; ownerForm: TObject;
                             WeaponLeftSprites, WeaponRightSprites: TList; InitWeaponType: TWeaponType);
    Destructor Destroy(); override;
  end;

implementation

Uses Unit1, UOwl, UBrick;

constructor TWeapon.CreateWeapon(X, Y:integer; MoveDirection:TMoveDirection; ownerForm: TObject;
                                 WeaponLeftSprites, WeaponRightSprites: TList; InitWeaponType: TWeaponType);
var
i: integer;
begin
//���������� X � Y ��� ������
XWeapon := X;
YWeapon := Y;
//����� � ������� ����������
WeaponinBox := true;
WeaponType := InitWeaponType;
//��������� ��� ������� ������ ��� �����
For i := 0 to MaxImageWeapon - 1 Do
   begin
   ImgMassLeft[i] := TBitmap(WeaponLeftSprites.Items[i]);
   ImgMassLeft[i].Transparent:=True;
   ImgMassLeft[i].TransparentMode:=tmFixed;
   ImgMassLeft[i].TransparentColor:=clBlack;
   end;
//��������� ��� ������� ������ ��� ������
For i := 0 to MaxImageWeapon - 1 Do
   begin
   ImgMassRight[i] := TBitmap(WeaponRightSprites.Items[i]);
   ImgMassRight[i].Transparent:=True;
   ImgMassRight[i].TransparentMode:=tmFixed;
   ImgMassRight[i].TransparentColor:=clBlack;
   end;
//������� ���������� ��� �������� �������
//sprminleft:=0;
//sprminright:=2;
//sprmaxleft:=1;
//sprmaxright:=3;
//sprleftindex:=sprminleft;
//sprrightindex:=sprminright;
Direction := MoveDirection;
//���������� �� ������
XOffset := 15;
YOffset := 0;
//WormState := StLive;
//EatSunflower := false;
//DamageStem := nil;
//�������� ������ �������
//self.Timer.Enabled:=true;
end;

//� ��� ��������� ����� ������������ ������ ������ ������
//��������� ����� ��������������� !!!
Procedure TWeapon.WeaponDown(Owl: TObject; Brick: TObject);
var
  tmpOwl : TMyOwl;
  tmpBrick: TBrick;
begin
//tmpBrick := nil;
//tmpOwl := nil;
tmpOwl := TMyOwl(Owl);
tmpBrick := TBrick(Brick);
//������ ��� ������������� ������ � ����������� ������
//��������� � ������ ������ ������������ ���� ������
if TObject(self.WeaponOwner) is TMyOwl then
  begin
  //������ ��������� �������: ���� ������ ����� �������
  self.WeaponOwner := tmpBrick;
  tmpBrick.Weapon := self;
  tmpOwl.Weapon := nil;
  end
else
  begin
  //������ ��������� �������: ������ ������ ����� ����
  self.WeaponOwner := tmpOwl;//tmpBrick;
  tmpBrick.Weapon := nil;
  tmpOwl.Weapon := self;
  end;

{if Owl is TMyOwl then
  begin
  tmpOwl := TMyOwl(Owl);
//������ ��������� �������
  self.owner := Owl;
  tmpBrick.Weapon := nil;
  tmpOwl.Weapon := self;
  end;
if Brick is TBrick then
  begin
  //����������� ������ � ������� ��� �� ������ � ������� �������
  tmpBrick := TBrick(Brick);
  self.owner := Brick;
  tmpBrick.Weapon := self;
  tmpOwl.Weapon := nil;
  //self.XWeapon := tmpBrick.XBrick;
  //self.YWeapon := tmpBrick.YBrick + self.ImgMassLeft[0].Height;
  end;}
end;

Procedure TWeapon.WeaponTouch(Player: TObject; Brick: TObject);
var
  tmpOwl : TMyOwl;
  tmpBrick: TBrick;
begin
if Player is TMyOwl then
  begin
  tmpOwl := TMyOwl(Player);
  self.WeaponOwner := tmpOwl;
  tmpOwl.Weapon := self;
  if Brick <> nil then
    begin
    if Brick is TBrick then
      begin
      tmpBrick := TBrick(Brick);
      tmpBrick.Weapon := nil;
      end;
    end;
  end;
end;

procedure TWeapon.Show;
var
  tmpOwl : TMyOwl;
  tmpBrick: TBrick;
  begin
if self.WeaponOwner <> nil then
  begin
  //��������� ����� ������ ������ ������ �������� ���������� ������
  if TObject(WeaponOwner) is TMyOwl then
    begin
    //����������� ��������� � ������ ����
    tmpOwl := TMyOwl(WeaponOwner);

    self.XWeapon := tmpOwl.XOwl + self.XOffset;
    self.YWeapon := tmpOwl.YOwl + self.YOffset;
    If ( tmpOwl.ThereMove = OwldirectionLeft) then
      begin
      self.XWeapon := self.XWeapon - self.ImgMassLeft[0].Width; //- tmpOwl.ImgMass[tmpOwl.sprindex].Width;
      end;
    If ( tmpOwl.ThereMove = OwldirectionRight) then
      begin
      self.XWeapon := self.XWeapon - self.ImgMassRight[0].Width + TBitMap(tmpOwl.ImgMassRight.Items[tmpOwl.sprindex]).Width + TBitMap(tmpOwl.ImgMassRight.Items[tmpOwl.sprindex]).Width div 2;
      end;

    end;
  if TObject(WeaponOwner) is TBrick then
    begin
    //����������� ��������� � ������ �����
    tmpBrick := TBrick(WeaponOwner);

    self.XWeapon := tmpBrick.XBrick + self.XOffset;
    self.YWeapon := tmpBrick.YBrick + self.YOffset;
    If ( tmpBrick.Direction = directionBrickLeft) then
      begin
      self.XWeapon := self.XWeapon + self.ImgMassLeft[0].Width; //- tmpBrick.ImgMassLeftBrick[0].Width;
      self.YWeapon := self.YWeapon + self.ImgMassLeft[0].Height + self.ImgMassLeft[0].Height div 2;
      end;
    end;

  end;


If (Direction = directionLeft) then
   begin
   VirtBitmap.Canvas.Draw(self.XWeapon, self.YWeapon, self.ImgMassLeft[0]);
   end;

If (Direction = directionRight) then
   begin
   VirtBitmap.Canvas.Draw(self.XWeapon, self.YWeapon, self.ImgMassRight[0]);
   end;
end;

destructor TWeapon.Destroy;
var
i:byte;
begin
//����� �� ������� �� ������ ������
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
//   if ImgMassLeft[i] <> nil then Freeandnil(ImgMassLeft[i]);
   end;
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
//   if ImgMassRight[i] <> nil then Freeandnil(ImgMassRight[i]);
   end;
//����� ����������� ������������� ������
inherited;
end;

end.
