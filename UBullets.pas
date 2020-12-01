unit UBullets;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uConstant;

const
//������� ������� ������������
MaxImageBullet = 1;


type
    TBulletDirection = (blDirLeft, blDirRight);

type
  TBulletSpritesArr = array[0..MaxImageBullet] of TBitMap;
  pBulletSpritesArr = ^TBulletSpritesArr;

type

  TBullet = class (TObject)
    Name: string;
    WeaponType: TWeaponType;
    ImgMassBulletLeft: TList;
    ImgMassBulletRight: TList;
//    ImageMassBullet: array[0..MaxImageBullet-1] of TBitMap;
    owner:TWinControl;
//    ownerStem: TObject;
    LightTick: Longint;
    BulletTick: Longint;
//    TimerBullet: TTimer;
//    ShowIndex: integer;
    XBullet, YBullet: integer;
    //������ ������� ���� ��� �������� ����
    IndexBullet: integer;
// ��� ����������� �� ������ ��� ���� ����� ���� ������ ������
//��������� ���������� ���������� ����� ������ ������� ����������� ����
    OldXBullet, OldYBullet: integer;
//    procedure Grown(Element:byte);
    //����������� ������ ����
    BulletDirection: TBulletDirection;
    procedure BulletWasHitToSomeObject(HitedObject: TObject);
    procedure Show;
    procedure TimerBulletProcessing(Sender: TObject);
    Constructor CreateBullet(X, Y: integer; ownerForm: TWinControl; var pBulletSpritesArrLeft, pBulletSpritesArrRight: TList;
                             InitWeaponType: TWeaponType);
    Destructor Destroy(); override;
  end;

implementation

Uses Unit1, UOwl;

constructor TBullet.CreateBullet(X,Y:integer; ownerForm: TWinControl; var pBulletSpritesArrLeft, pBulletSpritesArrRight: TList;
                                 InitWeaponType: TWeaponType);
var
i,k:integer;
begin
//���������� X � Y ������� ������������
XBullet := X;
YBullet := Y;
OldXBullet := XBullet;
OldYBullet := YBullet;
self.WeaponType := InitWeaponType;
IndexBullet := 0;
LightTick := gettickcount();
//Sunflowerstemspr1:=2;
//self.TimerBullet:=TTimer.Create(nil);
//self.TimerBullet.OnTimer:=self.TimerBulletProcessing;
//self.TimerBullet.Interval:=700; //round((Random*120)+(Random*60)+1);
if Form1.Owl[0].ThereMove=OwldirectionLeft then
  begin
  self.BulletDirection := blDirLeft;
  end;
if Form1.Owl[0].ThereMove = OwldirectionRight then
  begin
  self.BulletDirection:= blDirRight;
  end;
self.owner:=ownerForm;
ImgMassBulletLeft := pBulletSpritesArrLeft;
ImgMassBulletRight := pBulletSpritesArrRight;

//if BulletDirection = blDirLeft then
//   begin
//   ImgMassBulletLeft := pBulletSpritesArrLeft;
   //��������� ��� ������� �������
//   For i:=0 to MaxImageBullet-1 Do
//       begin
//       ImageMassBullet[i]:=TBitMap.Create;
//       ImageMassBullet[i].LoadFromFile('Bullet'+IntToStr(i+1)+'.bmp');
//       ImageMassBullet[i].Transparent:=True;
//       ImageMassBullet[i].TransparentMode:=tmFixed;
//       ImageMassBullet[i].TransparentColor:=clBlack;
//      end;
//   end
//else
//   begin
//   ImgMassBulletRight := pBulletSpritesArrRight;
//   For i:=0 to MaxImageBullet-1 Do
//      begin
//      ImageMassBullet[i]:=TBitMap.Create;
//      ImageMassBullet[i].LoadFromFile('Bullet'+IntToStr(i)+'.bmp');
//      ImageMassBullet[i].Transparent:=True;
//      ImageMassBullet[i].TransparentMode:=tmFixed;
//      ImageMassBullet[i].TransparentColor:=clBlack;
//      end;
//   end;
end;

procedure TBullet.BulletWasHitToSomeObject(HitedObject: TObject);
begin
//���� ��� ������� ����� ������ � �� ������ � ����������
//����� ����� ������� �������� ����������� ���� ��� ��������� � �����

end;

procedure TBullet.Show;
var
res, newtick: Longint;
begin
//���������� � ������� �������� [TBullet]
If self.WeaponType = wtPssst then
  IndexBullet:=0
 else
  begin
   If self.WeaponType = wtLight then
   newtick := gettickcount();
   res := newtick - self.LightTick;
   if res > 100 then
     begin
   //��������� ����� �������� tick
   self.LightTick := newtick;

  IndexBullet := IndexBullet + 1;
  if IndexBullet >=2 then IndexBullet := 0;
    end;
  end;
VirtBitmap.Canvas.Draw(self.XBullet, self.YBullet, TBitMap(self.ImgMassBulletLeft.Items[IndexBullet]));
end;

procedure TBullet.TimerBulletProcessing(Sender: TObject);
//var
//res,newtick: Longint;
begin
//�������� ���������� ����
//������� �������� ��� ����
//newtick := gettickcount();
//res := newtick - self.BulletTick;
//if res > 1 then
//   begin
   //��������� ����� �������� tick
//   self.BulletTick := newtick;
   //� ������� ���������� ���������� ������� ������ 5 ������
   OldXBullet := XBullet;
   OldYBullet := YBullet;
   if BulletDirection = blDirLeft then
     begin
     XBullet := XBullet - 5; //-1
     end;
   if BulletDirection = blDirRight then
     begin
     XBullet := XBullet + 5; //+1
     end;
//   end;
end;

//��������� �� ������ ����������� �� ������� ������� ����
destructor TBullet.Destroy;
var
i:byte;
begin
//for i := 1 to MyCanvasMax do
//   begin
//   If MyCanvas[i]<>nil then MyCanvas[i].free;
//   end;
//For i := 0 to MaxImageBullet - 1 Do
//   begin
//   if ImageMassBullet[i] <> nil then freeandnil(ImageMassBullet[i]);
//   end;
//setLength(ImageMassBullet, 0);
//if self.TimerBullet<>nil then freeandnil(self.TimerBullet);
inherited;
end;

end.
