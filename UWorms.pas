unit UWorms;

interface

Uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  uConstant, USunflower, ULeaf;

Const

//������������ �������� �������� �������
MaxImageWorm = 2;
MaxImageHitLeftWorm = 5;//���������� ������ ��������, � �� �������� � �������
MaxImageHitRightWorm = 5;

////������ ��������: ����, �������, ������
type
  TWormLiveStatus = (stLiveFly, stHitFly, stReadyForDestroyFly);

//type
//  TWormSpritesArr = array[0..MaxImageWorm-1] of TBitMap;
//  pWormSpritesArr = ^TWormSpritesArr;

type

  TMyWorm = class (TObject)
  public
  Name: string;
  //������ �������� �������
  ImgMassLeft: TList;
  ImgMassRight: TList;
  ImgHitMassLeft: TList;
  ImgHitMassRight: TList;

  owner: TWinControl;
  shagx1, shagy1: integer;
  Xworm, Yworm: integer;
  sprleftindex, sprrightindex :integer;
  sprminleft, sprminright:integer;
  sprmaxright, sprmaxleft: integer;
  sprmaxrightdeath, sprmaxleftdeath: integer;
  WormsScore:integer;
  ThereMove: TMoveDirection;
  WormState: TLiveStatus;
  EatSunflower: boolean;
  DamageStem: TStem;
  Timer: TTimer;
  procedure Show;
  procedure HitByObject(Sender: TObject);
  procedure HitByBullet(Sender: TObject);
  procedure TimerWorm1Timer(Sender: TObject);
  Constructor CreateWorm(ownerForm: TWinControl;
                         var pWormSpritesLeft, pWormSpritesRight,
                             pWormSpritesHitLeft, pWormSpritesHitRight: TList);
  Destructor Destroy(); override;
  end;


implementation

Uses Unit1, UFlyes, UOwl;

constructor TMyWorm.CreateWorm(ownerForm: TWinControl;
                               var pWormSpritesLeft, pWormSpritesRight,
                                   pWormSpritesHitLeft, pWormSpritesHitRight: TList);
var
i:integer;
begin
//�������������� ��������� ��������� ����� ��� �������
Randomize;
self.Timer := TTimer.Create(nil);
self.Timer.OnTimer := self.TimerWorm1Timer;
self.Timer.Interval := round((Random * 180) + 1);
//self.Timer.Interval := 20;//�������

//������������ ���������� �� X ��� ��������, ����� ��� ������������
Xworm := xmax;
if Xworm < 0 then Xworm := 0;
Yworm := round(Random * ymax) - TBitmap(pWormSpritesLeft.items[0]).Height;

//XWorm := 100;//�������

if Yworm < 0 then Yworm := 0;
self.owner := ownerForm;

//��������� ��� ������� �������
ImgMassLeft := pWormSpritesLeft;
ImgMassRight := pWormSpritesRight;
ImgHitMassLeft := pWormSpritesHitLeft;
ImgHitMassRight := pWormSpritesHitRight;
//
//������� ���������� ��� �������� �������
sprminleft := 0;
sprminright := 0;
sprmaxleft := MaxImageWorm - 1;
sprmaxright := MaxImageWorm - 1;
sprmaxleftdeath := MaxImageHitLeftWorm - 1;//���������� ������ ��������, � �� �������� � �������
sprmaxrightdeath := MaxImageHitRightWorm - 1;
sprleftindex := sprminleft;
sprrightindex := sprminright;
ThereMove := directionLeft;
WormState := StLive;
WormsScore := 0;
EatSunflower := false;
DamageStem := nil;
//�������� ������ �������
self.Timer.Enabled := true;
end;

procedure TMyWorm.TimerWorm1Timer(Sender: TObject);
begin
//����� �� �� ������������ ��������, � ���� �������� � ����������
If self.Xworm >= xmax then
   begin
   shagx1 := -4;
   ThereMove := directionLeft;
   end;
If self.Xworm <= xmin then
   begin
   shagx1 := 4;
   ThereMove := directionRight;
   end;
//����� �� �������� ����� �������
//�������� ����� �����
If (ThereMove = directionLeft) then
   begin
   sprleftindex := sprleftindex + 1;

   if self.Wormstate = stLive then
     begin
     //�����
     if sprleftindex > sprmaxleft then
       begin
       //������������� ������� ������ �� ������ ����
       sprleftindex := self.sprminleft;
       end;
     end
   else
     begin
     //�������
     if sprleftindex >= sprmaxleftdeath then
       begin
       //������������� ������� ������ �� ������ ����
       self.WormState := stReadyForDestroy;
       sprleftindex := sprmaxleftdeath;
       end;
     end;
   end;
//�������� ����� ������
If (ThereMove = directionRight) then
   begin
   sprrightindex := sprrightindex + 1;

   if self.Wormstate = stLive then
     begin
     //�����
     if sprrightindex > sprmaxright then
       begin
       sprrightindex := self.sprminright;
       end;
     end
   else
     begin
     //�������
     if sprrightindex >= sprmaxrightdeath then
       begin
       self.WormState := stReadyForDestroy;
       sprleftindex := sprmaxrightdeath;
       end;
     end;
   end;

//���������� ��� �������
self.Xworm := self.Xworm + shagx1;
if (self.WormState = stLive) and (EatSunflower = true) then
  begin
  if DamageStem <> nil then
    begin
    TSunflower(self.DamageStem.ownerSunflower).UnGrown(1);
    end;
  end;

end;

Procedure TMyWorm.HitByObject(Sender: TObject);
var
i:byte;
Stem: TStem;
Leaf: TLeaf;
begin
//�����������
if sender is TLeaf then
  begin
  Leaf := TLeaf(Sender);
  EatSunflower := true;
  Self.DamageStem := TStem(Leaf.ownerStem);
  end
else
if sender is TStem then
  begin
  Stem := TStem(Sender);
  EatSunflower := true;
  Self.DamageStem := Stem;
  end
else
  begin
  EatSunflower := false;
  DamageStem := nil;
  end;
self.shagx1 := 0;
self.shagy1 := 0;
end;

Procedure TMyWorm.HitByBullet(Sender: TObject);
var
i:byte;
begin
self.WormState := stHit;
self.Timer.Interval := 300;
//�������� ������� �������� ����� ���� ��� ���������� ��� ������� ������
self.sprrightindex := 0;
self.sprleftindex := 0;

self.shagx1 := 0;
self.shagy1 := 0;
WormsScore := 1;
//Form1.Caption:='������ ��������: ' + IntToStr(Form1.TableWormsScore);
WormsScore := 0;
end;

procedure TMyWorm.Show;
var tmpBitmap: TBitmap;
begin
   //���������� � ����� ������� ����� �������� � ����������� ������ ������ ������� � ������������
if self.WormState = stHit then
   begin
   if (self.ThereMove = directionLeft) then
     begin
     tmpBitmap := TBitmap(self.ImgHitMassLeft.Items[self.sprleftindex]);
     end
   else
     begin
     tmpBitmap := TBitmap(self.ImgHitMassRight.Items[self.sprrightindex]);
     end;
   VirtBitmap.Canvas.Draw(self.Xworm, self.Yworm, tmpBitmap);
   end;
if self.WormState = stLive then
   begin
   If (self.ThereMove = directionLeft) then
     begin
     tmpBitmap := TBitmap(self.ImgMassLeft.Items[self.sprLeftindex])
     end
   else
     begin
     tmpBitmap := TBitmap(self.ImgMassRight.Items[self.sprRightindex]);
     end;
   VirtBitmap.Canvas.Draw(self.Xworm, self.Yworm, tmpBitmap);
   end;
end;

//��� ���������� �������
destructor TMyWorm.Destroy;
var
i: byte;
begin
if self.Timer <> nil then
  begin
  Timer.Enabled := false;
  freeandnil(Timer);
  end;
//����� ����������� ������������� ������
inherited;
end;

end.
