unit UFlyes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uConstant;

Const

//������������ �������� �������� ���
MaxImageFly = 2;
MaxImageHitLeftFly = 5;
MaxImageHitRightFly = 5;

////������ �����: ����, �������, ������
type
    TFlyLiveStatus = (stLiveFly, stHitFly, stReadyForDestroyFly);

//type
//  TFlySpritesArr = array[0..MaxImageFly - 1] of TBitMap;
//  pFlySpritesArr = ^TFlySpritesArr;

type

  TMyFly = class (TObject)
  public
  Name: string;
  //������ �������� ���
//  ImgMass: array[0..MaxImageFly - 1] of TBitMap;
    //������ �������� �������
  ImgMassLeft: TList;
  ImgMassRight: TList;
  ImgHitMassLeft: TList;
  ImgHitMassRight: TList;

//  ImgMassLeft: pFlySpritesArr;
//  ImgMassRight: pFlySpritesArr;
//  ImgHitMassLeft: array[0..MaxImageHitLeftFly - 1] of TBitMap;
//  ImgHitMassRight: array[0..MaxImageHitRightFly - 1] of TBitMap;
  owner: TWinControl;
  shagx1,shagx2,shagy2: integer;
  sinyonoff: boolean;
  XFly,YFly,sprleftindex,sprrightindex: integer;
  sprminleft, sprminright: integer;
  sprmaxleftdeath, sprmaxrightdeath: integer;
  sprmaxright,sprmaxleft: integer;
  FlyesScore: integer;
  grad:real;
  ThereMove: TMoveDirection;
  FlyState: TLiveStatus;
  Timer: TTimer;
  procedure Show;
  procedure HitByObject(Sender: TObject);
  procedure HitByBullet(Sender: TObject);
  procedure TimerFly1Timer(Sender: TObject);
  Constructor CreateFly(ownerForm: TWinControl;
                         var pFlySpritesLeft, pFlySpritesRight,
                             pFlySpritesHitLeft, pFlySpritesHitRight: TList);
  Destructor Destroy(); override;
end;

implementation

Uses Unit1, USunflower;

constructor TMyFly.CreateFly( ownerForm: TWinControl;
                              var pFlySpritesLeft, pFlySpritesRight,
                              pFlySpritesHitLeft, pFlySpritesHitRight: TList);
var
i:integer;
begin
//�������������� ��������� ��������� ����� ��� ���
Randomize;
self.Timer:=TTimer.Create(nil);
self.Timer.OnTimer:=self.TimerFly1Timer;
self.Timer.Interval:=round((Random * 180) + 1);
//self.Timer.Interval:=round((Random*120)+(Random*60)+1);
//������������ ���������� �� X ��� ����, ����� ��� ������������
Xfly := xmax;
Yfly := round(Random*ymax) + SinFlyMax;
if Xfly < 0 then Xfly := SinFlyMax;
if Yfly > ymax then Yfly := ymax - SinFlyMax;
if Yfly < 0 then Yfly := 0;

self.grad := 0;

//��������� ��� ������� ���
ImgMassLeft := pFlySpritesLeft;
ImgMassRight := pFlySpritesRight;
ImgHitMassLeft := pFlySpritesHitLeft;
ImgHitMassRight := pFlySpritesHitRight;
self.owner := ownerForm;
//������� ���������� ��� �������� ���
sinyonoff := true;
sprmaxleftdeath := MaxImageHitLeftFly;
sprmaxrightdeath := MaxImageHitRightFly;
sprminleft := 0;
sprminright := 0;
sprmaxleft := MaxImageFly - 1;
sprmaxright := MaxImageFly - 1;
sprleftindex := sprminleft;
sprrightindex := sprminright;
shagx1 := -4;
shagy2 := 0;
ThereMove := directionLeft;
FlyState := StLive;
FlyesScore := 0;
//�������� ������ ���
self.Timer.Enabled:=true;
end;

Procedure TMyFly.HitByObject(Sender: TObject);
var
i:byte;
Stem: TStem;
Fly: TMyFly; //���� ���� � self, � ��� ������ ���� � ������� ������������ self
begin
//�����������
if sender is TStem then
  begin
  Stem := TStem(Sender);
  self.shagx1 := 0;
  self.shagx2 := 0;
  self.sinyonoff := false;
  self.shagy2 := 0;
  end;
if sender is TMyFly then
  begin
  Fly := TMyFly(Sender);
//   if Result=true then
//      begin
//      Obj1.shagx1:=0;
//      Obj1.shagx2:=0;
      //���� ����� �����
      If self.ThereMove = directionLeft then
         begin
         self.ThereMove := directionRight;
         self.shagx1:=4;
         end
      else
      //���� ����� ������
         begin
         self.ThereMove := directionLeft;
         self.shagx1:=-4;
         end;
      If Fly.ThereMove = directionLeft then
         begin
         Fly.ThereMove := directionRight;
         Fly.shagx1:=4;
         end
      else
      //����� ���� ����� �����
         begin
         Fly.ThereMove := directionLeft;
         Fly.shagx1:=-4;
         end;
  end;


//self.shagx1:=0;
//self.shagx2:=0;
//self.shagy2:=0;
end;

Procedure TMyFly.HitByBullet(Sender: TObject);
var
i:byte;
begin
self.FlyState := stHit;
self.Timer.Interval:=300;
self.sprleftindex := 0;
self.sprrightindex := 0;

FlyesScore := 1;
//Form1.TableFlyesScore := Form1.TableFlyesScore + FlyesScore;
//Form1.Caption:='������ ����: ' + IntToStr(Form1.TableFlyesScore);
FlyesScore := 0;


//self.FlyState := stReadyForDestroy;
//self.shagx1:=0;
//self.shagx2:=0;
//self.shagy2:=0;
end;

procedure TMyFly.TimerFly1Timer(Sender: TObject);
begin
grad := grad + 9;
//���� ����� �����
If self.Xfly>=xmax then
   begin
   shagx1 := -4;
   ThereMove := directionLeft;
   end;
//���� ����� ������
If self.Xfly <= xmin then
   begin
   shagx1 := 4;
   ThereMove := directionRight;
   end;
//if MyCanvas[1].Top>ymax then
//  begin

//������ ���� �� �������� ������ ����


If sinyonoff = true then
  self.Yfly := Yfly + round(SinFlyMax*Sin(pi/180*grad))
else
  self.Yfly := Yfly + self.shagy2;


//���� ����� �����
//����� �� �������� ����� �������
If (ThereMove = directionLeft) then
   begin
   sprleftindex := sprleftindex + 1;
   if self.Flystate <> stHit then
     begin
     if sprleftindex > sprmaxleft then
       begin
       sprleftindex := self.sprminleft;
       end;
     end
    else
      begin
      if sprleftindex >= sprmaxleftdeath then
        begin
        self.FlyState := stReadyForDestroy;
        sprleftindex := sprmaxleftdeath;
        end;
      end;
    end;
//���� ����� ������
If (ThereMove = directionRight) then
   begin
   sprrightindex := sprrightindex + 1;
   if self.Flystate <> stHit then
     begin
     if sprrightindex > sprmaxright then
       begin
       sprrightindex := self.sprminright;
       end;
     end
   else
     begin
     if sprrightindex >= sprmaxrightdeath then
       begin
       self.FlyState := stReadyForDestroy;
       sprrightindex := sprmaxrightdeath;
       end;
     end;
   end;
//   if sprrightindex>sprmaxright then
//     begin
//     sprrightindex:=self.sprminright;
//     end;
//   if self.FlyState = stHit then
//       begin
//       self.FlyState := stReadyForDestroy;
//       end;
//   end;
self.XFly:=self.XFly+self.shagx1;
end;

procedure TMyFly.Show;
begin
   //���������� � ����� ������� ����� ���� � ����������� ������ ������ ������� � ������������
if self.FlyState = stHit then
  begin
   If (self.ThereMove = directionLeft) then
     VirtBitmap.Canvas.Draw(self.XFly, self.YFly, TBitMap(self.ImgHitMassLeft.Items[self.sprleftindex]))
   else
     VirtBitmap.Canvas.Draw(self.XFly, self.YFly, TBitMap(self.ImgHitMassRight.Items[self.sprrightindex]));
   end;
if self.FlyState = stLive then
   begin
   If (self.ThereMove = directionRight) then
     VirtBitmap.Canvas.Draw(self.XFly, self.YFly, TBitMap(self.ImgMassRight.Items[self.sprrightindex]))
   else
     VirtBitmap.Canvas.Draw(self.XFly, self.YFly, TBitMap(self.ImgMassLeft.Items[self.sprleftindex]));
   end;
end;

//��� ���������� ���
destructor TMyFly.Destroy;
var
i:byte;
begin
//������� ������
Timer.free;
//����� ����������� ������������� ������
inherited;
end;

end.
