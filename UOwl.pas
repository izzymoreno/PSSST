unit UOwl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uConstant, UWeapon, USettings;

Const

//Константы изображений Совёнка
MaxImageOwl = 3;
MaxImageLeftOwl = 1;
MaxImageRightOwl = 1;
MaxImageLeftDieOwl = 3;
MaxImageRightDieOwl = 3;

MaxImageCrow = 3;
MaxImageLeftCrow = 1;
MaxImageRightCrow = 1;
MaxImageLeftDieCrow = 3;
MaxImageRightDieCrow = 3;



type
    TOwlDirection = (OwldirectionLeft, OwldirectionCenter, OwldirectionRight);

type
  TOwlSpritesArr = array[0..MaxImageOwl] of TBitMap;
  pOwlSpritesArr = ^TOwlSpritesArr;

type

  TMyOwl = class (TObject)
  public
  Name: string;
// Изображения хранятся в списке
  ImgMassLeft: TList;
  ImgMassRight: TList;
  ImgHitMassLeft: TList;
  ImgHitMassRight: TList;
//
  Weapon: TWeapon;
  owner:TWinControl;
  shagx,shagy:integer;
  sprleftdieindex, sprrightdieindex: integer;
  XOwl,YOwl,sprindex,sprmin,sprmax, AnimationShag:integer;
  ThereMove: TOwlDirection;
  OwlState: TLiveStatus;
  TheLoseOwl: boolean;
  Timer: TTimer;
  procedure HitByWorm(Sender: TObject);
  procedure HitByFly(Sender: TObject);
  procedure Show;
  procedure TimerAnimationOwl1(Sender: TObject);
  Constructor CreateOwl(ownerForm: TWinControl;
                         var pOwlSpritesLeft, pOwlSpritesRight,
                             pOwlSpritesHitLeft, pOwlSpritesHitRight: TList);
  Destructor Destroy(); override;
  end;

implementation

Uses Unit1;

constructor TMyOwl.CreateOwl(ownerForm: TWinControl;
                               var pOwlSpritesLeft, pOwlSpritesRight,
                                   pOwlSpritesHitLeft, pOwlSpritesHitRight: TList);
var
i:integer;
begin
//Èíèöèàëèçèðóåì ãåíåðàòîð ñëó÷àéíûõ ÷èñåë äëÿ ìóõ
//Randomize;
self.Timer:=TTimer.Create(nil);
self.Timer.OnTimer:=self.TimerAnimationOwl1;
self.Timer.Interval:=100;  //500
//Ìàêñèìàëüíàÿ êîîðäèíàòà ïî X äëÿ ìóõè, ÷òîáû îíà ðàçâåðíóëàñü
XOwl:=200;
YOwl:=200;
//self.grad:=0;
ImgMassLeft := pOwlSpritesLeft;
ImgMassRight := pOwlSpritesRight;
ImgHitMassLeft := pOwlSpritesHitLeft;
ImgHitMassRight := pOwlSpritesHitRight;

self.owner:=ownerForm;

//Çàâîäèì ïåðåìåííûå äëÿ àíèìàöèè ñîâû
self.TheLoseOwl := false;
self.OwlState := stLive;
sprmin:=0;
sprmax:=1;
sprindex:=sprmin;
sprleftdieindex := 0;
sprrightdieindex := 0;
shagx:=0;
shagy:=0;
AnimationShag := 0;
//Èçíà÷àëüíî ó ñîâû îðóæèÿ íåò
Weapon := nil;
//ThereMove:=OwldirectionCenter;
//Âêëþ÷àåì òàéìåð ñîâû
//self.Timer.Enabled:=true;
end;

//procedure TMyOwl.DeadAnimation(Sender: TObject);
//var
//begin

//end;

procedure TMyOwl.HitByWorm(Sender: TObject);
var
i:byte;
begin
self.OwlState := stHit;
self.Timer.Interval := 300;
//îáíóëÿåì ñ÷åò÷èê àíèìàöèè ÷òîáû îäèí ðàç ïðîêðóòèòü âñå ñïðàéòû ñìåðòè
self.sprleftdieindex := 0;
self.sprrightdieindex := 0;
self.shagx := 0;
self.shagy := 0;
//Form1.TableWormsScore := 0;
//Form1.TableFlyesScore := 0;
end;

procedure TMyOwl.HitByFly(Sender: TObject);
var
i:byte;
begin
self.OwlState := stHit;
self.Timer.Interval := 300;
//îáíóëÿåì ñ÷åò÷èê àíèìàöèè ÷òîáû îäèí ðàç ïðîêðóòèòü âñå ñïðàéòû ñìåðòè
self.sprleftdieindex := 0;
self.sprrightdieindex := 0;
self.shagx := 0;
self.shagy := 0;
//Form1.TableWormsScore := 0;
//Form1.TableFlyesScore := 0;
end;

//Анимация Совёнка
procedure TMyOwl.TimerAnimationOwl1(Sender: TObject);
begin
self.sprindex := self.sprindex + AnimationShag;
if self.sprindex > self.sprmax then self.sprindex := self.sprmin;
if self.OwlState = StHit then
  begin
  sprleftdieindex := sprleftdieindex + 1;
  sprrightdieindex := sprrightdieindex + 1;
  if sprleftdieindex >= MaxImageLeftDieOwl then
    begin
    sprleftdieindex := MaxImageLeftDieOwl;
    self.OwlState := StReadyForDestroy;
    If Weapon <> nil then Weapon.WeaponOwner := nil;
    end;
  if sprrightdieindex >= MaxImageRightDieOwl then
    begin
    sprrightdieindex := MaxImageRightDieOwl;
    self.OwlState := StReadyForDestroy;
    If Weapon <> nil then Weapon.WeaponOwner := nil;
    end;

  end;
end;

procedure TMyOwl.Show;
var modalRes: integer;
begin
//Îïðåäåëÿåì â êàêóþ ñòîðîíó èä¸ò ñîâà è ïðèñâàåâàåì íóæíûé èíäåêñ ñïðàéòà ñ íàïðàâëåíèåì
case self.OwlState of
  stLive:
    begin
    If (ThereMove=OwldirectionCenter) then
      begin
      VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgMassLeft.Items[1]);
      end;
    If (ThereMove=OwldirectionLeft) then
      begin
      VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgMassLeft.Items[sprindex]);
      end;
    If (ThereMove=OwldirectionRight) then
      begin
      VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgMassRight.Items[sprindex]);
      end;
      self.XOwl:=self.XOwl + shagx;
      self.YOwl:=self.YOwl + shagy;
     end;

  stHit:
    begin
    If (ThereMove=OwldirectionCenter) then
      begin
      VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgHitMassLeft.Items[1]);
      end;
    If (ThereMove=OwldirectionLeft) then
      begin
      VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgHitMassLeft.Items[sprleftdieindex]);
      end;
    If (ThereMove=OwldirectionRight) then
      begin
      VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgHitMassRight.Items[sprrightdieindex]);
      end;
      self.XOwl:=self.XOwl + shagx;
      self.YOwl:=self.YOwl + shagy;
    end;

  stReadyForDestroy:
    begin
    If (ThereMove=OwldirectionLeft) then
      begin
      VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgHitMassLeft.Items[sprleftdieindex]);
      end;
    If (ThereMove=OwldirectionRight) then
      begin
      VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgHitMassRight.Items[sprrightdieindex]);
      end;
      self.TheLoseOwl := true;
     self.OwlState := stGameOver;
    // SettingsForm.ModalResult := mrNone;
    //SettingsForm.FormShow(nil);
    //SettingsForm.Close;
    modalRes := SettingsForm.ShowModal;
    end;
  stGameOver:
    begin
    if self.OwlState = stGameOver then
      begin
      If (ThereMove=OwldirectionLeft) then
        begin
        VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgHitMassLeft.Items[sprleftdieindex]);
        end;
      If (ThereMove=OwldirectionRight) then
        begin
        VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgHitMassRight.Items[sprrightdieindex]);
        end;
    end;

    //Òóò ïðîèñõîäèò îæèäàíèå èíèöèàëèçàöèè íîâîé èãðû
    if modalRes = mrOk then
      begin
      //Íà÷èíàåòñÿ íîâàÿ èãðà
      end;
    end;

   //VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgMass[self.sprrightindex])
   //else
     //VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgMass[self.sprleftindex]);
(*if self.OwlState = stHit then
  begin
   If (ThereMove=OwldirectionLeft) then
   begin
   VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgMassLeft.Items[self.sprleftdieindex]);
   end
   else
     If (ThereMove=OwldirectionLeft) then
   begin
   VirtBitmap.Canvas.Draw(self.XOwl, self.YOwl, self.ImgMassLeft.Items[self.sprrightdieindex]);
   end;
  end;*)
end;
end;

//Выгружаем все спрайты и освобождаем память ПК
destructor TMyOwl.Destroy;
var
i:byte;
begin
//
(*For i:=0 to  MaxImageLeftOwl Do
   begin
   //Åñëè îáúåêò ñóùåñòâóåò â ïàìÿòè, òî ìû åãî óäàëÿåì
   if ImgMassLeftOwl[i]<>nil then ImgMassLeftOwl[i].free;
   end;
For i:=0 to  MaxImageRightOwl Do
   begin
   //Åñëè îáúåêò ñóùåñòâóåò â ïàìÿòè, òî ìû åãî óäàëÿåì
   if ImgMassRightOwl[i]<>nil then ImgMassRightOwl[i].free;
   end;

For i:=0 to  MaxImageLeftDieOwl Do
   begin
   //Åñëè îáúåêò ñóùåñòâóåò â ïàìÿòè, òî ìû åãî óäàëÿåì
   if ImgMassLeftDieOwl[i]<>nil then ImgMassLeftDieOwl[i].free;
   end;
For i:=0 to  MaxImageRightDieOwl Do
   begin
   //Åñëè îáúåêò ñóùåñòâóåò â ïàìÿòè, òî ìû åãî óäàëÿåì
   if ImgMassRightDieOwl[i]<>nil then ImgMassRightDieOwl[i].free;
   end; *)

//Óäàëÿåì òàéìåð
If Timer <> nil then Timer.free;
//Выгружаем таймер из памяти
inherited;
end;

end.
