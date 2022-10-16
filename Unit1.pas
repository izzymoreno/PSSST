unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ComCtrls,
  Dialogs, ExtCtrls, USunflower, UFlyes, UWorms, ULeaf, UOwl, UBullets, UWeapon, UBrick, UClouds, uConstant,
  jpeg, Menus, USettings, ULoading;

//�������� ���������
Const
//��� ���� � ������������ � ������� ������
OwlXStep = 5;
OwlYStep = 5;
//MyCanvasMax = 1;
//���������� ����
MaxBrick = 2;
//���������� ���
MaxOwl = 1;
//���������� �������
//MaxWorm = 10; //20
//���������� ���
//MaxFly = 10; //20
//���������� �����������
MaxSunflower = 1;
//���������� �������� ����������
//MaxSunflowerStem = 150;
//��������� �������� ���
SinFlyMax = 8; //50
//������������ ���������� ����
MaxBullet = 10;
//���������� �������
MaxSpray = 2;
//������������ �������� �������� ������
MaxImageWeapon = 1;
//��� ������ �������������
MaxImageSpriteWeapon = 1;
//���������� ������� � ����
MaxInGameClouds = 1;
//������ ����������
xmax = 800;
ymax = 600;
xmin = 0;
ymin = 0;
XScreenMax = 826;
YScreenMax = 683;

type
     TFormLoading = class(TForm)
     TimerBar: TTimer;
     Bar: TProgressBar;
//     procedure FormCreate(Sender: TObject);
//     procedure TimerBarTimer(Sender: TObject);
     end;

type
  TForm1 = class(TForm)
    Image1: TImage;
    TimerFPS: TTimer;
    TimerBullets: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerFPSTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TimerBulletsTimer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
        //���� ��� ������� ��������
    //��������
    TableWormsScore: integer;
    //����
    TableFlyesScore: integer;
    //��� ���� � ������������ � ������� ������
    OwlXStep, OwlYStep: integer;
    TheVictory: boolean;
    //������ �������
//    Worms:  array[0..MaxWorm - 1] of TMyWorm;
    Worms:  array of TMyWorm;
    //������ ���
    Flyes:  array of TMyFly;
    //������ ���
    Owl:    array[0..MaxOwl - 1] of TMyOwl;
    //������ �����������
    Sunflowers: array[0..MaxSunflower - 1] of TSunflower;
    //������ ����
    Bullets: array[0..MaxBullet - 1] of TBullet;
    //�����
    Weapons: array[0..MaxSpray - 1] of TWeapon;
    //������ ����
    Bricks:  array[0..MaxBrick - 1] of TBrick;
    //������ �������
    Clouds: array[0..MaxInGameClouds - 1] of TCloud;
    //    SunflowersHead:TMySunflower;
    BulletTick: Longint;
    Function CheckCollisionsBulletWorm():boolean;
    Function CheckCollisionsBulletFly():boolean;

    Function CheckCollisionsFlowerFly():boolean;
    Function CheckCollisionsFlowerWorm():boolean;
    Function CheckCollisionsFlyes():boolean;
    Function CheckCollisionsWorms():boolean;
    Function CheckCollisionOwlWeapon():boolean;
    Function CheckCollisionWeaponBrick():boolean;
    Function CheckCollisionsOwlWorms():boolean;
    Function CheckCollisionsOwlFlyes():boolean;
    Function CheckEndGame():boolean;
    Procedure TheVictoryinGame;
    Procedure TheLoseGame;

    Procedure ProcessingBullets;
    //Function FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
    //                   Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer
    //                   ):Boolean;
    Function FindCollision(RectBullet,
                           RectBox: TRect
                           ):Boolean;
    Function InitGame():boolean;
    Procedure InitLevel();
    Procedure DestroyLevel;
  end;


var
  Form1: TForm1;
  FormLoading: TFormLoading;
  SettingsForm : TSettingsForm;
  MaxWorm: integer;
  MaxFly: integer;
  LevelNumber: integer;
  //������� ����������� Canvas
  VirtBitmap: TBitmap;
  BackGroundBitmap: TBitmap;

  FlySpritesArrLeft: TList;
  FlySpritesArrRight: TList;
  FlySpritesArrHitLeft: TList;
  FlySpritesArrHitRight: TList;

  WormSpritesArrLeft: TList;
  WormSpritesArrRight: TList;
  WormSpritesArrHitLeft: TList;
  WormSpritesArrHitRight: TList;

  OwlSpritesArrLeft: TList;
  OwlSpritesArrRight: TList;
  OwlSpritesArrHitLeft: TList;
  OwlSpritesArrHitRight: TList;

  BulletSpritesArrLeft: TList;
  BulletSpritesArrRight: TList;

  StemSpritesArr: TList;
  HeadSpritesArr: TList;

  WeaponPssstSpritesArrLeft: TList;
  WeaponPssstSpritesArrRight: TList;
  WeaponLightSpritesArrLeft: TList;
  WeaponLightSpritesArrRight: TList;

  LightSpritesArrLeft: TList;
  LightSpritesArrRight: TList;

  CrowSpritesArrLeft: TList;
  CrowSpritesArrRight: TList;
  CrowSpritesArrHitLeft: TList;
  CrowSpritesArrHitRight: TList;

  CloudsSpritesArr: TList;
//  CloudSpritesArrSmall: TList;

  LightSpritesArr: TList;
  RainSpritesArr: TList;

implementation

{$R *.dfm}
Procedure TForm1.TheLoseGame;
begin
  begin
  VirtBitmap.Canvas.Font.Size := 18;
  VirtBitmap.Canvas.Font.Color:=clWhite;
  VirtBitmap.Canvas.TextOut(200,30,'���� ! �� ��������� ...');
  VirtBitmap.Canvas.TextOut(200,60,'�� �����: '+IntToStr({Form1.}TableWormsScore)+' �������');
  VirtBitmap.Canvas.TextOut(200,90,'�� �����: '+IntToStr({Form1.}TableFlyesScore)+' ���');
  end;
end;

Procedure TForm1.TheVictoryinGame;
begin
self.Sunflowers[0].TimerGrown.Interval := 1;
if self.Sunflowers[0].ShowHeadOn <> 0 then
  begin
  VirtBitmap.Canvas.Font.Size := 18;
  VirtBitmap.Canvas.Font.Color:=clWhite;
  VirtBitmap.Canvas.TextOut(200,30,'��� ! �� �������� ���� ��� � �������');
  //SettingsForm.EditPlayerName
  end;
end;

//Procedure TForm1.TheLoseGame;
//begin
//VirtBitmap.Canvas.Font.Size := 18;
//VirtBitmap.Canvas.Font.Color:=clWhite;
//VirtBitmap.Canvas.TextOut(200,30,'���� ! �� ��������� ...');
//end;

procedure TForm1.FormCreate(Sender: TObject);
begin
InitGame();
InitLevel();
end;

Function TForm1.InitGame():boolean;
var
//WX,WY,SX,SY:integer;
i, rnd: byte;
tmpBitmap: TBitmap;
mresult: integer;
begin
TheVictory := false;
//TheLose := false;
SetLength(Worms, 0);
SetLength(Flyes, 0);
//SettingsForm.Visible := false;
//SettingsForm.FormStyle := fsNormal;

BulletTick := gettickcount();
self.TimerFPS.Enabled := false;
self.TimerFPS.Interval := 20;   //20
//��������� Canvas ������ ������
//Form1.Image1.Canvas.Brush.Color:=clBlack;
//Form1.Image1.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));
Form1.Image1.Width := XScreenMax;
Form1.Image1.Height := YScreenMax;
//������ ����������� Bitmap
VirtBitmap := TBitmap.Create;
VirtBitmap.Canvas.Brush.Color := clBlack;
VirtBitmap.Width := XScreenMax;//Image1.Width;
VirtBitmap.Height := YScreenMax;//Image1.Height;
Form1.Image1.Width := XScreenMax;
Form1.Image1.Height := YScreenMax;

BackGroundBitmap := TBitmap.Create;
//BackGroundBitmap.LoadFromFile('Field.bmp');

Randomize;

 //������ ����� � ��������� �����������

//FormLoading := TFormLoading.Create(self);

//procedure TFormLoading.FormCreate(Sender: TObject);
//begin

//end;

//��������� ��� ������� ��� ����
FlySpritesArrLeft := TList.Create;
For i := 0 to MaxImageFly - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LFly' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode := tmFixed;
   tmpBitmap.TransparentColor := clBlack;
   FlySpritesArrLeft.Add(tmpBitmap);
   end;
//��������� ��� ������� ��� �����
FlySpritesArrRight := TList.Create;
For i := 0 to MaxImageFly - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('RFly' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode := tmFixed;
   tmpBitmap.TransparentColor := clBlack;
   FlySpritesArrRight.Add(tmpBitmap);
   end;

//��������� ��� ������� ���������� ��� �����
FlySpritesArrHitLeft := TList.Create;
For i := 0 to MaxImageHitLeftWorm - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LHitFly' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode := tmFixed;
   tmpBitmap.TransparentColor := clBlack;
   FlySpritesArrHitLeft.Add(tmpBitmap);
   end;
//��������� ��� ������� ���������� ��� ������
FlySpritesArrHitRight := TList.Create;
For i := 0 to MaxImageHitRightWorm - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('RHitFly' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   FlySpritesArrHitRight.Add(tmpBitmap);
   end;

//��������� ��� ������� ������� �����
WormSpritesArrLeft := TList.Create;
For i := 0 to MaxImageWorm - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LWorm' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   WormSpritesArrLeft.Add(tmpBitmap);
   end;
//��������� ��� ������� ������� ������
WormSpritesArrRight := TList.Create;
For i := 0 to MaxImageWorm - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('RWorm' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   WormSpritesArrRight.Add(tmpBitmap);
   end;


//��������� ��� ������� ���������� ������� �����
WormSpritesArrHitLeft := TList.Create;
For i := 0 to MaxImageHitLeftWorm - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LHitWorm' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode := tmFixed;
   tmpBitmap.TransparentColor := clBlack;
   WormSpritesArrHitLeft.Add(tmpBitmap);
   end;
//��������� ��� ������� ���������� ������� ������
WormSpritesArrHitRight := TList.Create;
For i := 0 to MaxImageHitRightWorm - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('RHitWorm' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   WormSpritesArrHitRight.Add(tmpBitmap);
   end;
//��������� � ������� ���� ��������� �����
OwlSpritesArrLeft := TList.Create;
For i:=0 to MaxImageLeftOwl Do
   begin
   tmpBitmap :=TBitMap.Create;
   tmpBitmap.LoadFromFile('LOwl' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   OwlSpritesArrLeft.Add(tmpBitmap);
   end;
//��������� � ������� ���� ��������� ������
OwlSpritesArrRight := TList.Create;
For i:=0 to MaxImageRightOwl Do
   begin
   tmpBitmap :=TBitMap.Create;
   tmpBitmap.LoadFromFile('ROwl' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   OwlSpritesArrRight.Add(tmpBitmap);
   end;
//��������� � ������� ���� ���������� �����
OwlSpritesArrHitLeft := TList.Create;
For i := 0 to MaxImageLeftDieOwl Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LOwlDie' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   OwlSpritesArrHitLeft.Add(tmpBitmap);
   end;
//��������� � ������� ���� ���������� ������
OwlSpritesArrHitRight := TList.Create;
For i := 0 to MaxImageRightDieOwl Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('ROwlDie' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   OwlSpritesArrHitRight.Add(tmpBitmap);
   end;

//��������� ��� ������� ����� ������� �����
BulletSpritesArrLeft := TList.Create;
For i := 0 to MaxImageBullet - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LBullet' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode := tmFixed;
   tmpBitmap.TransparentColor := clBlack;
   BulletSpritesArrLeft.Add(tmpBitmap);
   end;
//��������� ��� ������� ����� ������� ������
BulletSpritesArrRight := TList.Create;
For i := 0 to MaxImageBullet - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('RBullet' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode := tmFixed;
   tmpBitmap.TransparentColor := clBlack;
   BulletSpritesArrRight.Add(tmpBitmap);
   end;

StemSpritesArr := TList.Create;
For i := 0 to MaxImageStem - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('Stem' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode := tmFixed;
   tmpBitmap.TransparentColor := clBlack;
   StemSpritesArr.Add(tmpBitmap);
   end;
HeadSpritesArr := TList.Create;
For i := 0 to MaxImageHead - 1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('Sunflower'+IntToStr(i)+'.bmp');
   tmpBitmap.Transparent := True;
   tmpBitmap.TransparentMode := tmFixed;
   tmpBitmap.TransparentColor := clBlack;
   HeadSpritesArr.Add(tmpBitmap);
   end;
//��������� ������� ������ ��������� �����
WeaponPssstSpritesArrLeft := TList.Create;
For i:=0 to MaxImageWeapon-1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LGun'+IntToStr(i+1)+'.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   WeaponPssstSpritesArrLeft.Add(tmpBitmap);
   end;
//��������� ������� ������ ��������� ������
WeaponPssstSpritesArrRight := TList.Create;
For i:=0 to MaxImageWeapon-1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('RGun'+IntToStr(i+1)+'.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   WeaponPssstSpritesArrRight.Add(tmpBitmap);
   end;

//��������� ������� ������ ����������� �����
WeaponLightSpritesArrLeft := TList.Create;
For i:=0 to MaxImageWeapon-1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('TeslaLeft'+IntToStr(i+1)+'.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   WeaponLightSpritesArrLeft.Add(tmpBitmap);
   end;
//��������� ������� ������ ����������� ������
WeaponLightSpritesArrRight := TList.Create;
For i:=0 to MaxImageWeapon-1 Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('TeslaRight'+IntToStr(i+1)+'.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   WeaponLightSpritesArrRight.Add(tmpBitmap);
   end;

//��������� ������� ������ ����������� �����
LightSpritesArrLeft := TList.Create;
For i:=0 to MaxImageSpriteWeapon Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LightLeft'+IntToStr(i)+'.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   LightSpritesArrLeft.Add(tmpBitmap);
   end;
//��������� ������� ������ ����������� ������
LightSpritesArrRight := TList.Create;
For i:=0 to MaxImageSpriteWeapon Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LightRight'+IntToStr(i)+'.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   LightSpritesArrRight.Add(tmpBitmap);
   end;

//��������� ������� ������ ���������� �����
CrowSpritesArrLeft := TList.Create;
For i:=0 to MaxImageLeftCrow Do
   begin
   tmpBitmap :=TBitMap.Create;
   tmpBitmap.LoadFromFile('LCrow' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   CrowSpritesArrLeft.Add(tmpBitmap);
   end;
//��������� ������� ���� ��������� ������
CrowSpritesArrRight := TList.Create;
For i:=0 to MaxImageRightCrow Do
   begin
   tmpBitmap :=TBitMap.Create;
   tmpBitmap.LoadFromFile('RCrow' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   CrowSpritesArrRight.Add(tmpBitmap);
   end;
//��������� ������� ���� ���������� �����
CrowSpritesArrHitLeft := TList.Create;
For i := 0 to MaxImageLeftDieCrow Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('LCrowDie' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   CrowSpritesArrHitLeft.Add(tmpBitmap);
   end;
//��������� ������� ���� ���������� ������
CrowSpritesArrHitRight := TList.Create;
For i := 0 to MaxImageRightDieCrow Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('RCrowDie' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   CrowSpritesArrHitRight.Add(tmpBitmap);
   end;
//��������� ������� ���� �������
CloudsSpritesArr := TList.Create;
For i := 0 to MaxClouds Do
   begin
   tmpBitmap := TBitMap.Create;
   tmpBitmap.LoadFromFile('Cloud' + IntToStr(i) + '.bmp');
   tmpBitmap.Transparent:=True;
   tmpBitmap.TransparentMode:=tmFixed;
   tmpBitmap.TransparentColor:=clBlack;
   CloudsSpritesArr.Add(tmpBitmap);
   end;

FormLoading.Free;

//�������� ���������� ����������� ������� � ���
SettingsForm := TSettingsForm.Create(self);
mresult := SettingsForm.ShowModal;
LevelNumber:= SettingsForm.TrackBarLevels.Position;
//Form1.Caption := '������: ' + SettingsForm.EditPlayerName.Text;
end;

//procedure TFormLoading.TimerBarTimer(Sender: TObject);
//begin
//FormLoading.ProgressBar1.StepIt;
//end;

Procedure TForm1.InitLevel();
var
//WX,WY,SX,SY:integer;
i, rnd: byte;
tmpBitmap: TBitmap;
mresult: integer;
begin
Form1.TableWormsScore := 0;
Form1.TableFlyesScore := 0;
Form1.Caption := '';
Form1.Caption := '������ ����� �� �����: ' + (SettingsForm.EditPlayerName.Text);
MaxWorm := SettingsForm.TrackBarWorms.Position;
SetLength(Worms, MaxWorm);

MaxFly := SettingsForm.TrackBarFlyes.Position;
SetLength(Flyes, MaxFly);

//���� ������� ������ ����� 1 �� ������ �� ������ ������ ������ �������
if LevelNumber = 1 then
   begin
   //Form1.Caption := IntToStr(LevelNumber);
   if length(Worms) > 0 then
      begin
      for i := 0 to MaxWorm - 1 do
         begin
         //������ ������� � ������������� ������������ ���������� �� X � ��������� �� Y
         Worms[i] := TMyWorm.CreateWorm( Form1, WormSpritesArrLeft, WormSpritesArrRight,
                                  WormSpritesArrHitLeft, WormSpritesArrHitRight);
   //������ ��� �������
//   Worms[i].Xworm := 400;
//   Worms[i].Yworm := 250;
         end;
      end;
   end;

//���� ������� ������ ����� 2 �� ������ �� ������ ������ ������ ���
if LevelNumber = 2 then
   begin
   //������ ���
   if length(Flyes) > 0 then
      begin
      for i := 0 to MaxFly - 1 do
         begin
         //������ ��� � ������������� ������������ ���������� �� X � ��������� �� Y
         Flyes[i] := TMyFly.CreateFly( Form1, FlySpritesArrLeft, FlySpritesArrRight,
                                  FlySpritesArrHitLeft, FlySpritesArrHitRight);
         end;
      end;
   end;

//���� ������� ������ ����� 3 �� ������ �� ������ ������ ������� � ���

if LevelNumber = 3 then
   begin
   //Form1.Caption := IntToStr(LevelNumber);
   if length(Worms) > 0 then
      begin
      for i := 0 to MaxWorm - 1 do
         begin
         //������ ������� � ������������� ������������ ���������� �� X � ��������� �� Y
         Worms[i] := TMyWorm.CreateWorm( Form1, WormSpritesArrLeft, WormSpritesArrRight,
                                  WormSpritesArrHitLeft, WormSpritesArrHitRight);
   //������ ��� �������
//   Worms[i].Xworm := 400;
//   Worms[i].Yworm := 250;
         end;
      end;

   //������ ���
   if length(Flyes) > 0 then
      begin
      for i := 0 to MaxFly - 1 do
         begin
         //������ ��� � ������������� ������������ ���������� �� X � ��������� �� Y
         Flyes[i] := TMyFly.CreateFly( Form1, FlySpritesArrLeft, FlySpritesArrRight,
                                  FlySpritesArrHitLeft, FlySpritesArrHitRight);
         end;
      end;
   end;



//������ ����
If (SettingsForm.RadioGroup1.ItemIndex = 0) then
  begin
  Owl[0] := TMyOwl.CreateOwl(Form1, OwlSpritesArrLeft, OwlSpritesArrRight,
                             OwlSpritesArrHitLeft, OwlSpritesArrHitRight);
  end
   else
   begin
   Owl[0] := TMyOwl.CreateOwl(Form1, CrowSpritesArrLeft, CrowSpritesArrRight,
                             CrowSpritesArrHitLeft, CrowSpritesArrHitRight);
   end;

If (SettingsForm.CheckBox1.Checked = true) then
   begin
   Form1.Owl[0].OwlState := stGodMode;
   end;

//������ ������-������
rnd := 0;
if length(Weapons) > 0 then
  begin
  for i := 0 to MaxSpray - 1 do
    begin
    if rnd = 0 then
      Weapons[i] := TWeapon.CreateWeapon(20+i*20,200,directionLeft,nil, WeaponPssstSpritesArrLeft, WeaponPssstSpritesArrRight, wtPssst);
    if rnd = 1 then
      Weapons[i] := TWeapon.CreateWeapon(20+i*50,280,directionLeft,nil, WeaponLightSpritesArrLeft, WeaponLightSpritesArrRight, wtLight);
    inc(rnd);
    end;
  end;
//������ ���������

if length(Clouds) > 0 then
  begin
  for i := 0 to MaxInGameClouds-1 do
    begin
    Clouds[i]:=TCloud.CreateCloud(50,50, Form1, CloudsSpritesArr); // CreateSunflower(round(VirtBitmap.Width/2),VirtBitmap.Height-50, Form1);
//    Sunflowers[i]:=TSunflower.CreateSunflower(Random(xmax)-60,Random(ymax)-20,Form1);
//�������� ��������� ������ ������
    Clouds[i].Show;
    end;
  end;


if length(Sunflowers) > 0 then
  begin
  for i := 0 to MaxSunflower-1 do
    begin
    Sunflowers[i]:=TSunflower.CreateSunflower(round(VirtBitmap.Width/2),VirtBitmap.Height-50, Form1);
//    Sunflowers[i]:=TSunflower.CreateSunflower(Random(xmax)-60,Random(ymax)-20,Form1);
//���� ���������� �� 1 ������
    Sunflowers[i].Grown(1);
//�������� ��������� ������ ����������
    Sunflowers[i].Show;
    end;
  end;

//�������������� ������ ����, �.�, ��������� ��� nil
if length(Bullets) > 0 then
  begin
  for i := 0 to MaxBullet-1 do
    begin
    //������ ������� � ������������� ������������ ���������� �� X � ��������� �� Y
    Bullets[i] := nil;
    end;
  end;
//��� �� ��� � �� ����� ������
OwlXStep := 5;
OwlYStep := 5;
//������������ ������
Owl[0].Show;
//����� �����
if length(Bricks) > 0 then
  begin
  for i := 0 to MaxBrick-1 do
    begin
    Bricks[i] := TBrick.CreateBrick(round(0),round(VirtBitmap.Height - 190-i*130),directionBrickLeft,nil);
    Bricks[i].Show;
    //����� �����
    //Brick[1]:=TBrick.CreateBrick(250,30,directionBrickRight,nil);
    //Brick[1].Show;
    end;
  end;

//��������� ��� ������ CheatMode
if Form1.Caption = '������ ����� �� �����: ���� �����' then TheVictory := true;
if Form1.Caption = '������ ����� �� �����: ���� ������' then
   begin
   if LevelNumber = 1 then
       begin
       for i:= 1 to MaxWorm-1 do
          begin
          Worms[i].WormState := stHit;
          end;
       end;
if Form1.Caption = '���� �����' then
   begin
   end;

   end;
//

if (mresult = mrClose) then
    begin
    //���������� ����
    //Self.Destroy;
    postmessage(self.Handle, WM_CLOSE, 0, 0);
    end;

//�������� ������ ���������
self.TimerFPS.Enabled := true;
end;

Procedure TForm1.DestroyLevel;
var
i: byte;
tmpBitmap: TBitmap;
begin
//��������� ������ ���������
if BackGroundBitmap <> nil then FreeAndNil(BackGroundBitmap);
self.TimerFPS.Enabled := false;
//������� �� ������ ���������
//if Sunflowers[0]<>nil then Sunflowers[0].Free;
//������� �� ������ ������ ������� � ���
if Length(Worms) > 0 then
  begin
  for i := 0 to MaxWorm - 1 do
    begin
    if Worms[i] <> nil then FreeAndNil(Worms[i]);
    end;
  end;

if Length(Flyes) > 0 then
  begin
  for i := 0 to MaxFly - 1 do
    begin
    if Flyes[i] <> nil then FreeAndNil(Flyes[i]);
    end;
  end;

if Length(Bullets) > 0 then
  begin
  for i := 0 to MaxBullet - 1 do
    begin
    if Bullets[i] <> nil then FreeAndNil(Bullets[i]);
    end;
  end;

if Length(Weapons) > 0 then
  begin
  for i := 0 to MaxSpray - 1 do
    begin
    if  Weapons[i] <> nil then FreeAndNil(Weapons[i]);
    end;
  end;
end;

//��������� ���������, �������, ��� �� ������
procedure TForm1.FormDestroy(Sender: TObject);
var
i: byte;
tmpBitmap: TBitmap;
begin
//�������� ���������, ������� ���������� ������� �������� ������������
DestroyLevel;

//����� �� ������� �� ������ ���
For i := 0 to  MaxImageFly - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if FlySpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(FlySpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to  MaxImageFly - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if FlySpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(FlySpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;

For i := 0 to  MaxImageHitLeftFly - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if FlySpritesArrHitLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(FlySpritesArrHitLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to  MaxImageHitRightFly - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
  if WormSpritesArrHitRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(FlySpritesArrHitRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
    end;

For i := 0 to MaxImageWorm - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if WormSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(WormSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to MaxImageWorm - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if WormSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(WormSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to MaxImageHitLeftWorm - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if WormSpritesArrHitLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(WormSpritesArrHitLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to MaxImageHitRightWorm - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if WormSpritesArrHitRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(WormSpritesArrHitRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
  end;
//������� �� ������ ������ ����� ����
For i := 0 to MaxImageLeftOwl Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if OwlSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(OwlSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
//� ������
For i := 0 to MaxImageRightOwl Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if OwlSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(OwlSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
//
//������� �� ������ ����������� ������ ����� ����
For i := 0 to MaxImageLeftDieOwl - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if OwlSpritesArrHitLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(OwlSpritesArrHitLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
//� ������
For i := 0 to MaxImageRightDieOwl - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if OwlSpritesArrHitRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(OwlSpritesArrHitRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;


For i := 0 to MaxImageBullet - 1 Do
  begin
  //���� ������ ���������� � ������, �� �� ��� �������
  if BulletSpritesArrLeft[i] <> nil then
    begin
    tmpBitmap := TBitmap(BulletSpritesArrLeft.Items[i]);
    Freeandnil(tmpBitmap);
    end;
  end;
//
For i := 0 to MaxImageBullet - 1 Do
  begin
  //���� ������ ���������� � ������, �� �� ��� �������
  if BulletSpritesArrRight[i] <> nil then
    begin
    tmpBitmap := TBitmap(BulletSpritesArrRight.Items[i]);
    Freeandnil(tmpBitmap);
    end;
  end;

//
For i := 0 to MaxImageStem - 1 Do
  begin
  if StemSpritesArr[i] <> nil then
    begin
    tmpBitmap := TBitmap(StemSpritesArr.Items[i]);
    Freeandnil(tmpBitmap);
    end;
  end;

//
For i := 0 to MaxImageHead - 1 Do
  begin
  if HeadSpritesArr[i] <> nil then
    begin
    tmpBitmap := TBitmap(HeadSpritesArr.Items[i]);
    Freeandnil(tmpBitmap);
    end;
  end;

//��������� �� ������ ��������
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if WeaponPssstSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(WeaponPssstSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if WeaponPssstSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(WeaponPssstSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;

   //��������� �� ������ �����������
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if WeaponLightSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(WeaponLightSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if WeaponLightSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(WeaponLightSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;

   //��������� �� ������ ������
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if LightSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(LightSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if LightSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(LightSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;

//��������� ����������� ������
VirtBitmap.Free;
end;


procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
i:integer;
res,newtick: Longint;
begin
   //Form1.Caption := IntToStr(Key);
   case key of
   vk_space:
         begin
        if (Owl[0].Weapon <> nil) and (Owl[0].OwlState = StLive) then
          begin
          if Owl[0].ThereMove = OwldirectionLeft then
            begin
            Owl[0].sprindex := 0;
            end
              else
              begin
              Owl[0].sprindex := 1;
              end;
          newtick := gettickcount();
          res := newtick - self.BulletTick;
          if res > 100 then
            begin
            //��������� ����� �������� tick
            self.BulletTick := newtick;
            for i := 0 to MaxBullet-1 do
              begin
              if Bullets[i] = nil then
                begin
                if Owl[0].ThereMove = OwldirectionLeft then
                  begin
//                  Bullet[i] := TBullet.CreateBullet(Weapon[0].XWeapon-20, Weapon[0].YWeapon, Form1, BulletSpritesArrLeft,
//                                                   BulletSpritesArrRight);
                  if Owl[0].Weapon <> nil then
                    begin
                      case Owl[0].Weapon.WeaponType of
                        wtPssst: Bullets[i] := TBullet.CreateBullet(Owl[0].Weapon.XWeapon-20, Owl[0].Weapon.YWeapon,
                                                      Form1, BulletSpritesArrLeft, BulletSpritesArrRight,
                                                      Owl[0].Weapon.WeaponType);
                        wtLight: Bullets[i] := TBullet.CreateBullet(Owl[0].Weapon.XWeapon-20, Owl[0].Weapon.YWeapon,
                                                      Form1, LightSpritesArrLeft, LightSpritesArrRight,
                                                      Owl[0].Weapon.WeaponType);
                      end;
                    end;

                  break;
                  end
                else
                  begin
                  if Owl[0].Weapon <> nil then
                    begin
                    case Owl[0].Weapon.WeaponType of
                    wtPssst: Bullets[i] := TBullet.CreateBullet(Owl[0].Weapon.XWeapon + Owl[0].Weapon.ImgMassRight[0].Width,
                                                      Owl[0].Weapon.YWeapon, Form1, BulletSpritesArrLeft,
                                                      BulletSpritesArrRight, Owl[0].Weapon.WeaponType);
                    wtLight: Bullets[i] := TBullet.CreateBullet(Owl[0].Weapon.XWeapon+ Owl[0].Weapon.ImgMassRight[0].Width, Owl[0].Weapon.YWeapon,
                                                      Form1, LightSpritesArrLeft, LightSpritesArrRight,
                                                      Owl[0].Weapon.WeaponType);
                      end;
                    end;
                  break;
                  end;
                end;
              end;
            end;
          end;
        end;
   vk_up:
         begin
         Owl[0].shagy := -5;
         Owl[0].AnimationShag := 1;
         end;
   vk_left:
         begin
            //������������� ������ ���� ����� � ��������� 0 � 1
            Owl[0].ThereMove := OwldirectionLeft;
            Owl[0].AnimationShag := 1;

            Owl[0].shagx := -5;
            if Owl[0].Weapon <> nil then
              begin
              Owl[0].Weapon.Direction := directionleft;
              end;
         end;

   vk_right:
         begin
           //������������� ������ ���� ������ � ��������� 2 � 3

            Owl[0].ThereMove:=OwldirectionRight;
            Owl[0].AnimationShag := 1;

            Owl[0].shagx:=5;
            if Owl[0].Weapon <> nil then
              begin
              Owl[0].Weapon.Direction := directionRight;
              end;
         end;

   vk_down:
         begin
         Owl[0].AnimationShag := 1;
         Owl[0].shagy:=5;
         end;
   end;
end;

//����� ������� ��������� ������ ����������
procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case key of
//���������� ������� ������� �����
   vk_up:
         begin
         Owl[0].shagy:=0;
         Owl[0].AnimationShag:=0;
//         VirtBitmap.Canvas.Draw(Owl[0].XOwl, Owl[0].YOwl, Owl[0].ImgMass[1])
         end;
//���������� ������� ������� �����
   vk_left:
         begin
         Owl[0].shagx:=0;
         Owl[0].AnimationShag:=0;
//         VirtBitmap.Canvas.Draw(Owl[0].XOwl, Owl[0].YOwl, Owl[0].ImgMass[1])
         end;
//���������� ������� ������� ������
   vk_right:
         begin
         Owl[0].shagx:=0;
         Owl[0].AnimationShag:=0;
//         VirtBitmap.Canvas.Draw(Owl[0].XOwl, Owl[0].YOwl, Owl[0].ImgMass[1])
         end;
//���������� ������� ������� ����
   vk_down:
         begin
         Owl[0].shagy:=0;
         Owl[0].AnimationShag:=0;
//         VirtBitmap.Canvas.Draw(Owl[0].XOwl, Owl[0].YOwl, Owl[0].ImgMass[1])
         end;
    end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

//������� ��������� ��������� ���� ��������������� ���� �� �����
Function TForm1.FindCollision(RectBullet,
                              RectBox: TRect
                              ): Boolean;
begin
//�������� !!! ������ ������ - ��� ����, � ������ ������ ��� ����
Result := false;
//���� ����� ������ �������� ���� ������� ������ �������������� � ����������, ������ �� ��� ������ ������� ���������������
//                                                  width
//   (RectBox.Left, RectBox.Top) +----------------------------------------+
//                               |     +-----------                       |
//                               |     | (RectObj2.Left, RectObj2.Top)    | height
//                               |     |                                  |
//                               |     |                                  |
//                               +----------------------------------------+ (RectObj1.Right, RectObj1.Bottom)

If (RectBullet.Left >= RectBox.Left) and (RectBullet.Left <= RectBox.Right) and
   (RectBullet.Top >= RectBox.Top) and (RectBullet.Top <= RectBox.Bottom) then
  begin
  Result := true;
  exit;
  end;
//���� ����� ������� �������� ���� ������� ������ �������������� � ����������, ������ �� ��� ������ ������� ���������������
//                                                  width
// (RectObj1.Left, RectObj1.Top) +-----------------------------------------+
//                               |                            --------+    |
//                               |      (RectObj2.Right, RectObj2.Top)|    | height
//                               |                                    |    |
//                               |                                    |    |
//                               +-----------------------------------------+ (RectObj1.Right, RectObj1.Bottom)
If (RectBullet.Right >= RectBox.Left) and (RectBullet.Right <= RectBox.Right) and
   (RectBullet.Top >= RectBox.Top) and (RectBullet.Top <= RectBox.Bottom) then
  begin
   Result := true;
  exit;
  end;
//���� ����� ������� ������� ���� ������� ������ �������������� � ����������, ������ �� ��� ������ ������� ���������������
//                                                  width
// (RectObj1.Left, RectObj1.Top) +-----------------------------------------+
//                               |                                    |    |
//                               |                                    |    |
//                               |   (RectObj2.Right, RectObj2.Bottom)|    | height
//                               |                            --------+    |
//                               +-----------------------------------------+ (RectObj1.Right, RectObj1.Bottom)
If (RectBullet.Right >= RectBox.Left) and (RectBullet.Right <= RectBox.Right) and
   (RectBullet.Bottom >= RectBox.Top) and (RectBullet.Bottom <= RectBox.Bottom) then
  begin
  Result := true;
  exit;
  end;
//���� ����� ������ ������� ���� ������� ������ �������������� � ����������, ������ �� ��� ������ ������� ���������������
//                                                  width
// (RectObj1.Left, RectObj1.Top) +-----------------------------------------+
//                               |  |                                      |
//                               |  |                                      |
//                               |  | (RectObj2.Left, RectObj2.Bottom)     | height
//                               |  +---------                             |
//                               +-----------------------------------------+ (RectObj1.Right, RectObj1.Bottom)
If (RectBullet.Left >= RectBox.Left) and (RectBullet.Left <= RectBox.Right) and
   (RectBullet.Bottom >= RectBox.Top) and (RectBullet.Bottom <= RectBox.Bottom) then
  begin
  Result := true;
  exit;
  end;
//���� ������, ��� ������ � ��������� ��������� ���
//                                                            width2
// (RectObj2.Left, RectObj2.Top) +-------------------------------------------------------------+
//                               |  +-----------------------------------------------------+    |
//                               |  |(RectObj1.Left, RectObj1.Top)                        |    | height2
//                               |  |                                                     |    |
//                               |  |                                                     |    |
//                               |  |                    (RectObj1.Right, RectObj1.Bottom)| height1
//                               |  +-----------------------------------------------------+    |
//                               +-------------------------------------------------------------+ (RectObj2.Right, RectObj2.Bottom)
If (RectBox.Left >= RectBullet.Left) and (RectBox.Right <= RectBullet.Right) and
   (RectBox.Top >= RectBullet.Top) and (RectBox.Bottom <= RectBullet.Bottom) then
  begin
  Result := true;
  exit;
  end;
end;


//������� ��������� ��������� ���� ��������������� ���� �� �����
{
Function TForm1.FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
                       Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer
                       ):Boolean;
begin
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3

//���� ����� ������ �������� ���� ������� ������ �������������� � ����������, ������ �� ��� ������ ������� ���������������
//(Obj2X1, Obj2Y1)
Result:=false;
If (Obj2X1>=Obj1X1) and (Obj2X1<=Obj1X2) and (Obj2Y1>=Obj1Y1) and (Obj2Y1<=Obj1Y3) then
  begin
  Result:=true;
  exit;
  end;
//���� ����� ������� �������� ���� ������� ������ �������������� � ����������, ������ �� ��� ������ ������� ���������������
//(Obj2X2, Obj2Y2)
If (Obj2X2<=Obj1X3) and (Obj2X2>=Obj1X4) and (Obj2Y2>=Obj1Y1) and (Obj2Y2<=Obj1Y4) then
  begin
  Result:=true;
  exit;
  end;
//���� ����� ������� ������� ���� ������� ������ �������������� � ����������, ������ �� ��� ������ ������� ���������������
If (Obj2X3>=Obj1X1) and (Obj2X3<=Obj1X2) and (Obj2Y3>=Obj1Y1) and (Obj2Y3<=Obj1Y4) then
  begin
  Result:=true;
  exit;
  end;
//���� ����� ������ ������� ���� ������� ������ �������������� � ����������, ������ �� ��� ������ ������� ���������������
If (Obj2X4<=Obj1X2) and (Obj2X4>=Obj1X1) and (Obj2Y4>=Obj1Y1) and (Obj2Y4<=Obj1Y4) then
  begin
  Result:=true;
  exit;
  end;
end;
}

Function TForm1.CheckCollisionWeaponBrick():boolean;
var
i, n: integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
begin
//���� ������ ��� ���������� � �����, �� �� ���� ��������� ��������������� � ���� �������

if Owl[0].Weapon <> nil then

//if Weapon[0] = Owl[0].Weapon then
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3

  begin
  for i := 0 to MaxSpray - 1 do
    begin
    for n := 0 to MaxBrick - 1 do
      begin
      if Bricks[n].Direction = directionBrickLeft then
       begin
       Obj1X1 := Bricks[n].XBrick;//������� ����� ����
       Obj1Y1 := Bricks[n].YBrick;//������� ����� ����
       Obj1X2 := Obj1X1 + Bricks[n].ImgMassLeftBrick[0].Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + Bricks[n].ImgMassLeftBrick[0].Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end
     else
       begin
       Obj1X2 := Obj1X1 + Bricks[n].ImgMassRightBrick[0].Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + Bricks[n].ImgMassRightBrick[0].Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;

     if Owl[0].ThereMove = OwldirectionLeft then
       begin
       Obj2X1 := Weapons[i].XWeapon;
       Obj2Y1 := Weapons[i].YWeapon;
       Obj2X2 := Obj2X1 + Weapons[i].ImgMassLeft[0].Width;
       Obj2Y2 := Obj2Y1;
       Obj2X3 := Obj2X2;
       Obj2Y3 := Obj2Y1 + Weapons[i].ImgMassLeft[0].Height;
       Obj2X4 := Obj2X1;
       Obj2Y4 := Obj2Y3;
       end
     else
       begin
       Obj2X1 := Weapons[i].XWeapon;
       Obj2Y1 := Weapons[i].YWeapon;
       Obj2X2 := Obj2X1 + Weapons[i].ImgMassRight[0].Width;
       Obj2Y2 := Obj2Y1;
       Obj2X3 := Obj2X2;
       Obj2Y3 := Obj2Y1 + Weapons[i].ImgMassRight[0].Height;
       Obj2X4 := Obj2X1;
       Obj2Y4 := Obj2Y3;
       end;

     //����� ���������� �� ������
     result:= FindCollision(Rect( Obj1X1, Obj1Y1, Obj1X3, Obj1Y3),
                           Rect( Obj2X1, Obj2Y1, Obj2X3, Obj2Y3));
     if Result = true then
       begin
       If Weapons[i].WeaponinBox = false then
         begin
         //����� ��������
         if Bricks[n].Weapon = nil then
           begin
           Weapons[i].WeaponDown(Owl[0], Bricks[n]);
           Weapons[i].WeaponinBox := true;
           end
         else
           begin
           //����� ������
           if Owl[0].Weapon = nil then
             begin
             //��� ���� � ���� ������ ���
             Weapons[i].WeaponTouch(Owl[0], Bricks[n]);
             Weapons[i].WeaponinBox := true;
             end;
           end;
         end;
       end
     else
       begin
       Weapons[i].WeaponinBox := false;
       end;
       end;
     end;
   end;
end;

Function TForm1.CheckCollisionOwlWeapon;
var
i, n, weap: integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
begin
//���� ������ ��� ���������� � �����, �� �� ���� ��������� ��������������� � ���� �������
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3
for weap := 0 to MaxSpray - 1 do
  begin
  if (Owl[0].Weapon <> nil) then exit;
//����� �� ��������� ������ �� ���� ��� ������
//  if (Weapon[weap] = Owl[0].Weapon) then exit;

   if Weapons[weap].Direction = directionLeft then
     begin
     Obj1X1:= Weapons[weap].XWeapon;
     Obj1Y1:= Weapons[weap].YWeapon;
     Obj1X2:= Obj1X1 + Weapons[weap].ImgMassLeft[0].Width;
     Obj1Y2:= Obj1Y1;
     Obj1X3:= Obj1X2;
     Obj1Y3:= Obj1Y1 + Weapons[weap].ImgMassLeft[0].Height;
     Obj1X4:= Obj1X1;
     Obj1Y4:= Obj1Y3;
     end
   else
     begin
     Obj1X1:= Weapons[weap].XWeapon;
     Obj1Y1:= Weapons[weap].YWeapon;
     Obj1X2:= Obj1X1 + Weapons[weap].ImgMassRight[0].Width;
     Obj1Y2:= Obj1Y1;
     Obj1X3:= Obj1X2;
     Obj1Y3:= Obj1Y1 + Weapons[weap].ImgMassRight[0].Height;
     Obj1X4:= Obj1X1;
     Obj1Y4:= Obj1Y3;
     end;

   if Owl[0].ThereMove = OwldirectionLeft then
     begin
     Obj2X1:= Owl[0].XOwl;
     Obj2Y1:= Owl[0].YOwl;
     Obj2X2:= Obj2X1 + TBitMap(Owl[0].ImgMassLeft.Items[Owl[0].sprindex]).Width;
     Obj2Y2:= Obj2Y1;
     Obj2X3:= Obj2X2;
     Obj2Y3:= Obj2Y1 + TBitMap(Owl[0].ImgMassLeft.Items[Owl[0].sprindex]).Height;
     Obj2X4:= Obj2X1;
     Obj2Y4:= Obj2Y3;
     end
   else
     begin
     Obj2X1:= Owl[0].XOwl;
     Obj2Y1:= Owl[0].YOwl;
     Obj2X2:= Obj2X1 + TBitMap(Owl[0].ImgMassRight.Items[Owl[0].sprindex]).Width;
     Obj2Y2:= Obj2Y1;
     Obj2X3:= Obj2X2;
     Obj2Y3:= Obj2Y1 + TBitMap(Owl[0].ImgMassRight.Items[Owl[0].sprindex]).Height;
     Obj2X4:= Obj2X1;
     Obj2Y4:= Obj2Y3;
     end;

   //result := FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
   //                        Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4
   //                        );
   result:= FindCollision(Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3),
                          Rect(Obj2X1, Obj2Y1, Obj2X3, Obj2Y3));

   if Result = true then
     begin
     Weapons[weap].WeaponTouch(Owl[0], Weapons[weap].WeaponOwner);
     end;
  end;
end;

//������� ������������ ��� ����� �����
Function TForm1.CheckCollisionsFlyes():boolean;
var
i,n:integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
Fly1, Fly2: TMyFly;
begin
//������� �������� �����������, �.�. ���� ������ ������ �� ������� � ���������� ��� �� ������ �������� �� �������, � ������� � �.�. �� ����������
//����� ���� ������ ������ �� ������� � ���������� � ������� �������� �� �������, ��������, ����� � �.�.
//����� ���� ������ ������ ��������� � ���������� ��� � �������� �������� �� �������, ����� � �.�.
For n := 0 to MaxFly - 1 do
begin
Fly1 := Flyes[n];
if (Fly1 <> nil) and
   (Fly1.FlyState = stLive) and
   (Fly1.ImgMassLeft.Count > 0) and
   (Fly1.ImgMassRight.Count > 0)
   then
   begin
   //
   Obj1X1 := Fly1.XFly;
   Obj1Y1 := Fly1.YFly;
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3

   //���� ����� �����
   If (Fly1.ThereMove = directionLeft) then
      begin
      Obj1X2 := Obj1X1 + TBitMap(Fly1.ImgMassLeft.Items[Fly1.sprleftindex]).Width;
      Obj1Y2 := Obj1Y1;
      Obj1X3 := Obj1X2;
      Obj1Y3 := Obj1Y1 + TBitMap(Fly1.ImgMassLeft.Items[Fly1.sprleftindex]).Height;
      Obj1X4 := Obj1X1;
      Obj1Y4 := Obj1Y3;

      end;
   //���� ����� ������
   If (Fly1.ThereMove = directionRight) then
      begin
      Obj1X2 := Obj1X1 + TBitMap(Fly1.ImgMassRight.Items[Fly1.sprrightindex]).Width;
      Obj1Y2 := Obj1Y1;
      Obj1X3 := Obj1X2;
      Obj1Y3 := Obj1Y1 + TBitMap(Fly1.ImgMassRight.Items[Fly1.sprrightindex]).Height;
      Obj1X4 := Obj1X1;
      Obj1Y4 := Obj1Y3;
      end;

for i := n to MaxFly-1 do
   begin
   Fly2 := Flyes[i];
     //������ ��� � ������������� ������������ ���������� �� X � ��������� �� Y
   if (Fly2 <> nil) and
      (Fly2.FlyState = stLive) then
     begin
     if Fly1<>Fly2 then
   begin
   Obj2X1 := Fly2.XFly;
   Obj2Y1 := Fly2.YFly;
   //���� ����� �����
   If (Fly2.ThereMove = directionLeft) then
      begin
      Obj2X2 := Obj2X1+TBitMap(Fly2.ImgMassLeft.Items[Fly2.sprleftindex]).Width;
      Obj2Y2 := Obj2Y1;
      Obj2X3 := Obj2X2;
      Obj2Y3 := Obj2Y1+TBitMap(Fly2.ImgMassLeft.Items[Fly2.sprleftindex]).Height;
      Obj2X4 := Obj2X1;
      Obj2Y4 := Obj2Y3;
      end;
   //���� ����� ������
   If (Fly2.ThereMove = directionRight) then
      begin
      Obj2X2 := Obj2X1+TBitMap(Fly2.ImgMassRight.Items[Fly2.sprrightindex]).Width;
      Obj2Y2 := Obj2Y1;
      Obj2X3 := Obj2X2;
      Obj2Y3 := Obj2Y1+TBitMap(Fly2.ImgMassRight.Items[Fly2.sprrightindex]).Height;
      Obj2X4 := Obj2X1;
      Obj2Y4 := Obj2Y3;
      end;

   //result := FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
   //                        Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4
   //                        );
   result := FindCollision( Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3),
                            Rect(Obj2X1, Obj2Y1, Obj2X3, Obj2Y3));

              if Result=true then
              begin
              Fly1.HitByObject(Fly2);
             // Fly2.HitByObject(Fly1);
              //Worm.shagx1:=0;
              //Worm.shagx2:=0;
              //Worm.shagy2:=0;
              end;

   end;
   end;
   end;
   end;
   end;
end;

//������� ������������ ������� ���������� � �������
Function TForm1.CheckCollisionsFlowerWorm():boolean;
var
i,n,k:integer;
StemX1, StemY1, StemX2, StemY2, StemX3, StemY3, StemX4, StemY4,
WormX1, WormY1, WormX2, WormY2, WormX3, WormY3, WormX4, WormY4:integer;
Worm: TMyWorm;
Stem: TStem;
sprindex:integer;
tmpSunflowers: TSunflower;
begin
k:=0;
n:=0;
i:=0;
//������� �������� ������������, �.�. ���� ������ ������ �� ������� ������ ���������� � ���������� ��� � ������ �������� �� ������� ���, �� ������, � ������� � �.�. �� ����������
//����� ���� ������ ������ �� ������� ������ � ���������� � ������, ������, ������� �������� �� ������� ���, ��������, ����� � �.�.
//��� ������ �� ����� ���������� ����������, ��� ���� ������ ��������� ����.
//For n:=0 to MaxSunflower-1 do
for k := 0 to MaxWorm-1 do
  begin
  Worm := Worms[k];
   //
  If (Worm <> nil) and
    (Worm.WormState = stLive)
    then
    begin
    WormX1:= Worm.XWorm;
    WormY1:= Worm.YWorm;
   //�������� ����� �����
  If (Worm.ThereMove=DirectionLeft) then
    begin
    sprindex := Worm.sprleftindex;
    end;
   //�������� ����� ������
  If (Worm.ThereMove=DirectionRight) then
    begin
    sprindex := Worm.sprrightindex;
    end;
  for n:=0 to length(Sunflowers)-1 do
    begin
    If Sunflowers[n] <> nil then
      begin
      tmpSunflowers := Sunflowers[n];
//      for i := 0 to MaxSunflowerStem-1 do
      for i := 0 to tmpSunflowers.Sunflowerstem.Count - 1 do
        begin
        Stem := TStem(tmpSunflowers.Sunflowerstem.Items[i]);
        //            width
        // x1, y1 +--------------+ x2, y2
        //        |              |
        //        |              | height
        //        |              |
        // x4, y4 +--------------+ x3, y3
         if Stem <> nil then
//       If Stem <> nil then
          begin
          if Stem.Leaf <> nil then

//          If Stem.Leaf <> nil then
            begin

            WormX1 := Worm.XWorm;
            WormY1 := Worm.YWorm;
            If (Worm.ThereMove = directionLeft) then
              begin
              WormX2 := WormX1 + TBitmap(Worm.ImgMassLeft.items[Worm.sprleftindex]).Width;
              end;
            If (Worm.ThereMove = directionRight) then
              begin
              WormX2 := WormX1 + TBitmap(Worm.ImgMassRight.items[Worm.sprrightindex]).Width;
              end;
            WormY2 := WormY1;
            WormX3 := WormX2;
            If (Worm.ThereMove = directionLeft) then
              begin
              WormY3 := WormY1 + TBitmap(Worm.ImgMassLeft.items[Worm.sprleftindex]).Height;
              end;
            If (Worm.ThereMove = directionRight) then
              begin
              WormY3 := WormY1 + TBitmap(Worm.ImgMassRight.items[Worm.sprrightindex]).Height;
              end;
              WormX4 := WormX1;
              WormY4 := WormY3;

              StemX1 := Stem.Leaf.XLeaf;
              StemY1 := Stem.Leaf.YLeaf;
              if Stem.Leaf.ShowIndex < 3 then
                begin
                StemX2 := StemX1 + Stem.Leaf.ImageMassLeaf[Stem.Leaf.ShowIndex].Width; //Stem.Leaf.ShowIndex
                StemY2 := StemY1;
                StemX3 := StemX2;
                StemY3 := StemY1 + Stem.Leaf.ImageMassLeaf[Stem.Leaf.ShowIndex].Height;
                StemX4 := StemX1;
                StemY4 := StemY3;
                end
              else
                begin
                StemX1 := 0;
                StemY1 := 0;
                StemX2 := 0;
                StemY2 := 0;
                StemX3 := 0;
                StemY3 := 0;
                StemX4 := 0;
                StemY4 := 0;
                end;

              //result := FindCollision(WormX1, WormY1, WormX2, WormY2, WormX3, WormY3, WormX4, WormY4,
              //                        StemX1, StemY1, StemX2, StemY2, StemX3, StemY3, StemX4, StemY4
              //                        );
              result := FindCollision( Rect(WormX1, WormY1, WormX3, WormY3),
                                     Rect(StemX1, StemY1, StemX3, StemY3));

              if Result = true then
                begin
                Worm.HitByObject(Stem.Leaf);
                //Worm.shagx1:=0;
                //Worm.shagx2:=0;
                //Worm.shagy2:=0;
                end;
              end;
            end
          end;
        end;
      end;
    end;
  end;
end;

//������� ������������ ������ ���������� � ���
Function TForm1.CheckCollisionsFlowerFly(): boolean;
var
i,n,k:integer;
StemX1, StemY1, StemX2, StemY2, StemX3, StemY3, StemX4, StemY4,
FlyX1, FlyY1, FlyX2, FlyY2, FlyX3, FlyY3, FlyX4, FlyY4:integer;
Fly: TMyFly;
Stem: TStem;
sprindex:integer;
tmpSunflowers: TSunflower;
begin
result := false;
n:=0;
i:=0;
//������� �������� ������������, �.�. ���� ������ ������ �� ������� ������ ���������� � ���������� ��� � ������ �������� �� ������� ���, �� ������, � ������� � �.�. �� ����������
//����� ���� ������ ������ �� ������� ������ � ���������� � ������, ������, ������� �������� �� ������� ���, ��������, ����� � �.�.
//��� ������ �� ����� ���������� ����������, ��� ���� ������ ��������� ����.
//For n:=0 to MaxSunflower-1 do
for k := 0 to MaxFly - 1 do
  begin
  Fly := Flyes[k];
   //
   if (Fly <> nil) and
      (Fly.FlyState = stLive)
     then
     begin
     FlyX1:= Fly.XFly;
     FlyY1:= Fly.YFly;
     //���� ����� �����
     If (Fly.ThereMove = directionLeft) then
       begin
       sprindex:=Fly.sprleftindex;
       end;
     //���� ����� ������
     If (Fly.ThereMove = directionRight) then
       begin
       sprindex := Fly.sprrightindex;
       end;

     For n := 0 to length(Sunflowers) - 1 do
       begin
       If Sunflowers[n] <> nil then
         begin
         tmpSunflowers := Sunflowers[n];
//      for i := 0 to MaxSunflowerStem-1 do
         for i := 0 to tmpSunflowers.Sunflowerstem.Count - 1 do
           begin
           Stem := TStem(tmpSunflowers.Sunflowerstem.Items[i]);
           If Stem <> nil then
             begin
             //            width
             // x1, y1 +--------------+ x2, y2
             //        |              |
             //        |              | height
             //        |              |
             // x4, y4 +--------------+ x3, y3

             FlyX1 := Fly.XFly;
             FlyY1 := Fly.YFly;
             If (Fly.ThereMove = directionLeft) then
               begin
               FlyX2:= FlyX1 + TBitMap(Fly.ImgMassLeft.Items[sprindex]).Width;
               end;
             If (Fly.ThereMove = directionRight) then
               begin
               FlyX2:= FlyX1 + TBitMap(Fly.ImgMassRight.Items[sprindex]).Width;
               end;
             FlyY2:= FlyY1;
             FlyX3:= FlyX2;
             If (Fly.ThereMove = directionLeft) then
               begin
               FlyY3:= FlyY1 + TBitMap(Fly.ImgMassLeft.Items[sprindex]).Height;
               end;
             If (Fly.ThereMove = directionRight) then
               begin
               FlyY3:= FlyY1 + TBitMap(Fly.ImgMassRight.Items[sprindex]).Height;
               end;
             FlyX4:= FlyX1;
             FlyY4:= FlyY3;
             StemX1 := Stem.XStem;
             StemY1 := Stem.YStem;
             StemX2:= StemX1 + Stem.ImageMassStem[0].Width;
             StemY2:= StemY1;
             StemX3:= StemX2;
             StemY3:= StemY1 + Stem.ImageMassStem[0].Height;
             StemX4:= StemX1;
             StemY4:= StemY3;



             //result:= FindCollision(FlyX1, FlyY1, FlyX2, FlyY2, FlyX3, FlyY3, FlyX4, FlyY4,
             //                       StemX1, StemY1, StemX2, StemY2, StemX3, StemY3, StemX4, StemY4
             //                       );
             result := FindCollision(Rect(FlyX1, FlyY1, FlyX3, FlyY3),
                                     Rect(StemX1, StemY1, StemX3, StemY3));


         if Result = true then
            begin
            //self.Owl[0].HitByBullet(Worm1);
            //Bullet1.BulletWasHitToSomeObject((Worm1));
            //FreeAndNil(Worm[n]);
//            FreeAndNil(Bullet1);
            //�.�. ���� ����������, �� ��������� �� ������������ � ����������� ��������� � ����� �� �����
            //��������� ����
            Fly.HitByObject(Stem);
            end;
         end;
       end;
      end;
    end;
  end;
end;
end;

Function TForm1.CheckCollisionsOwlWorms(): boolean;
var
i,n:integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
//tmpWorm: TMyWorm;
//tmpOwl: TMyOwl;
begin
//tmpOwl := self.Owl[0];
For n := 0 to MaxWorm - 1 do
  begin
  //tmpWorm := Worms[n];
  if (Worms[n] <> nil) and
     (Worms[n].WormState = stLive) and
     (Worms[n].ImgMassLeft.Count > 0) and
     (Worms[n].ImgMassRight.Count > 0)
     then
     begin
     //
     Obj1X1 := Worms[n].XWorm;
     Obj1Y1 := Worms[n].YWorm;
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3
     //�������� ����� �����
     If (Worms[n].ThereMove = directionLeft) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Worms[n].ImgMassLeft.items[Worms[n].sprleftindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Worms[n].ImgMassLeft.items[Worms[n].sprleftindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
   //�������� ����� ������
     If (Worms[n].ThereMove = directionRight) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Worms[n].ImgMassRight.items[Worms[n].sprrightindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Worms[n].ImgMassRight.items[Worms[n].sprrightindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
     //���������� ���������� �������� � ������� � ������ ��� ����� ������ �����
       if (Owl[0] <> nil) and
          (Owl[0].OwlState = stLive) and
          (Owl[0].ImgHitMassLeft <> nil) and
          (Owl[0].ImgHitMassRight <> nil)
          then
         begin
//         if Worm1 <> Owl[0] then
  //         begin
           Obj2X1 := Owl[0].XOwl;
           Obj2Y1 := Owl[0].YOwl;
       //
           If (Owl[0].ThereMove = OwldirectionLeft) then
             begin
             Obj2X2:= Obj2X1 + TBitmap(Owl[0].ImgHitMassLeft.items[2]).Width;
             Obj2Y2:= Obj2Y1;
             Obj2X3:= Obj2X2;
             Obj2Y3:= Obj2Y1 + TBitmap(Owl[0].ImgHitMassLeft.items[2]).Height;
             Obj2X4:= Obj2X1;
             Obj2Y4:= Obj2Y3;
             end;
      //
           If (Owl[0].ThereMove = OwldirectionRight) then
             begin
             Obj2X2:= Obj2X1 + TBitmap(Owl[0].ImgHitMassRight.items[2]).Width;
             Obj2Y2:= Obj2Y1;
             Obj2X3:= Obj2X2;
             Obj2Y3:= Obj2Y1 + TBitmap(Owl[0].ImgHitMassRight.items[2]).Height;
             Obj2X4:= Obj2X1;
             Obj2Y4:= Obj2Y3;
             end;
            //result:= FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
            //                       Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4
            //                       );
            result := FindCollision(Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3),
                                    Rect(Obj2X1, Obj2Y1, Obj2X3, Obj2Y3));
            If result = true then
              begin
              Owl[0].HitByWorm(Worms[n]);
              FreeAndNil(Worms[n]);
              end;
            //Bullet1.BulletWasHitToSomeObject(Fly1);
      end;
    end;
  end;
end;

Function TForm1.CheckCollisionsOwlFlyes(): boolean;
var
i,n:integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
//tmpWorm: TMyWorm;
//tmpOwl: TMyOwl;
begin
//tmpOwl := self.Owl[0];
For n := 0 to MaxFly - 1 do
  begin
  //tmpWorm := Worms[n];
  if (Flyes[n] <> nil) and
     (Flyes[n].FlyState = stLive) and
     (Flyes[n].ImgMassLeft.Count > 0) and
     (Flyes[n].ImgMassRight.Count > 0)
     then
     begin
     //
     Obj1X1 := Flyes[n].XFly;
     Obj1Y1 := Flyes[n].YFly;
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3
     //�������� ����� �����
     If (Flyes[n].ThereMove = directionLeft) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Flyes[n].ImgMassLeft.items[Flyes[n].sprleftindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Flyes[n].ImgMassLeft.items[Flyes[n].sprleftindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
   //�������� ����� ������
     If (Flyes[n].ThereMove = directionRight) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Flyes[n].ImgMassRight.items[Flyes[n].sprrightindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Flyes[n].ImgMassRight.items[Flyes[n].sprrightindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
     //���������� ���������� �������� � ������� � ������ ��� ����� ������ �����
       if (Owl[0] <> nil) and
          (Owl[0].OwlState = stLive) and
          (Owl[0].ImgHitMassLeft <> nil) and
          (Owl[0].ImgHitMassRight <> nil)
          then
         begin
//         if Worm1 <> Owl[0] then
  //         begin
           Obj2X1 := Owl[0].XOwl;
           Obj2Y1 := Owl[0].YOwl;
       //
           If (Owl[0].ThereMove = OwldirectionLeft) then
             begin
             Obj2X2:= Obj2X1 + TBitmap(Owl[0].ImgHitMassLeft.items[2]).Width;
             Obj2Y2:= Obj2Y1;
             Obj2X3:= Obj2X2;
             Obj2Y3:= Obj2Y1 + TBitmap(Owl[0].ImgHitMassLeft.items[2]).Height;
             Obj2X4:= Obj2X1;
             Obj2Y4:= Obj2Y3;
             end;
      //
           If (Owl[0].ThereMove = OwldirectionRight) then
             begin
             Obj2X2:= Obj2X1 + TBitmap(Owl[0].ImgHitMassRight.items[2]).Width;
             Obj2Y2:= Obj2Y1;
             Obj2X3:= Obj2X2;
             Obj2Y3:= Obj2Y1 + TBitmap(Owl[0].ImgHitMassRight.items[2]).Height;
             Obj2X4:= Obj2X1;
             Obj2Y4:= Obj2Y3;
             end;
            //result:= FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
            //                       Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4
            //                       );
            result := FindCollision(Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3),
                                    Rect(Obj2X1, Obj2Y1, Obj2X3, Obj2Y3));
            If result = true then
              begin
              Owl[0].HitByFly(Flyes[n]);
              FreeAndNil(Flyes[n]);
              end;
            //Bullet1.BulletWasHitToSomeObject(Fly1);
      end;
    end;
  end;
end;


//������� ������������ �������
Function TForm1.CheckCollisionsWorms():boolean;
var
i,n:integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
Worm1, Worm2: TMyWorm;
begin
//������� �������� �����������, �.�. ���� ������ ������ �� ������� � ���������� ��� �� ������ �������� �� �������, � ������� � �.�. �� ����������
//����� ���� ������ ������ �� ������� � ���������� � ������� �������� �� �������, ��������, ����� � �.�.
//����� ���� ������ ������ ��������� � ���������� ��� � �������� �������� �� �������, ����� � �.�.
For n := 0 to MaxWorm - 1 do
  begin
  Worm1 := Worms[n];
  if (Worm1 <> nil) and
     (Worm1.WormState = stLive) and
     (Worm1.ImgMassLeft.Count > 0) and
     (Worm1.ImgMassRight.Count > 0)
     then
     begin
     //
     Obj1X1 := Worm1.XWorm;
     Obj1Y1 := Worm1.YWorm;
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3

     //�������� ����� �����
     If (Worm1.ThereMove = directionLeft) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Worm1.ImgMassLeft.items[Worm1.sprleftindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Worm1.ImgMassLeft.items[Worm1.sprleftindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
   //�������� ����� ������
     If (Worm1.ThereMove = directionRight) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Worm1.ImgMassRight.items[Worm1.sprrightindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Worm1.ImgMassRight.items[Worm1.sprrightindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;

     for i := n to MaxWorm - 1 do
       begin
       Worm2 := Worms[i];
     //������ ������� � ������������� ������������ ���������� �� X � ��������� �� Y
       if (Worm2 <> nil) and
          (Worm2.WormState = stLive) and
          (Worm2.ImgMassLeft <> nil) and
          (Worm2.ImgMassRight <> nil)
          then
         begin
         if Worm1 <> Worm2 then
           begin
           Obj2X1 := Worm2.XWorm;
           Obj2Y1 := Worm2.YWorm;
       //�������� ����� �����
           If (Worm2.ThereMove = directionLeft) then
             begin
             Obj2X2:= Obj2X1 + TBitmap(Worm2.ImgMassLeft.items[Worm1.sprleftindex]).Width;
             Obj2Y2:= Obj2Y1;
             Obj2X3:= Obj2X2;
             Obj2Y3:= Obj2Y1 + TBitmap(Worm2.ImgMassLeft.items[Worm1.sprleftindex]).Height;
             Obj2X4:= Obj2X1;
             Obj2Y4:= Obj2Y3;
             end;
      //�������� ����� ������
           If (Worm2.ThereMove = directionRight) then
             begin
             Obj2X2:= Obj2X1 + TBitmap(Worm2.ImgMassRight.items[Worm1.sprrightindex]).Width;
             Obj2Y2:= Obj2Y1;
             Obj2X3:= Obj2X2;
             Obj2Y3:= Obj2Y1 + TBitmap(Worm2.ImgMassRight.items[Worm1.sprrightindex]).Height;
             Obj2X4:= Obj2X1;
             Obj2Y4:= Obj2Y3;
             end;
            //result:= FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
            //                       Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4
            //                       );
            result := FindCollision(Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3),
                                    Rect(Obj2X1, Obj2Y1, Obj2X3, Obj2Y3));

      if Result = true then
        begin
        //���� ����� �����
        If Worm1.ThereMove =directionLeft then
          begin
          Worm1.ThereMove:=directionRight;
          Worm1.shagx1:=4;
          end
        else
          //���� ����� ������
          begin
          Worm1.ThereMove:=directionLeft;
          Worm1.shagx1:=-4;
          end;
        If Worm2.ThereMove =directionLeft then
          begin
          Worm2.ThereMove:=directionRight;
          Worm2.shagx1:=4;
          end
        else
          //����� ���� ����� �����
          begin
          Worm2.ThereMove:=directionLeft;
          Worm2.shagx1:=-4;
          end;
        end;
      end;
    end;
  end;
 end;
end;

end;

Function TForm1.CheckEndGame():boolean;
var
i: integer;
begin
result := true;
for i := 0 to Length(Worms)-1 do
  begin
  if (Worms[i] <> nil) then
    begin
    result := false;
    break;
    end;
  end;
for i := 0 to Length(Flyes)-1 do
  begin
  if (Flyes[i] <> nil) then
    begin
    result := false;
    break;
    end;
  end;
if self.Sunflowers[0].ShowHeadOn = 1 then
  begin
  result := true;
  end;

end;

//������� ������������ ������� c ������
Function TForm1.CheckCollisionsBulletWorm():boolean;
var
i,n:integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
Worm1: TMyWorm;
Bullet1: TBullet;
Bulletsprindex: integer;
//sprindex:integer;
begin
//������� ���� ������ ���� � ��������� � �� ����� ������� �������, ��������� ����������. ����� ���� ��������� ����
// � ��������� � �� ������� � ���������� � �.�, ���� �� �������� �� ����� ������� �������.
For n := 0 to MaxBullet - 1 do
  begin
  Bullet1 := Bullets[n];
  if (Bullet1 <> nil) and
     (Bullet1.WeaponType = wtPssst) then
    begin
    for i := 0 to MaxWorm - 1 do
      begin
      Bullet1 := Bullets[n];
      if Bullet1 = nil then exit;
      Worm1 := Worms[i];
      if Worm1 <> nil then
        begin
        if Worm1.WormState = stLive then
          begin

// �������� ���������� ��������
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3

//TODO: ��������: ��� �������� � ����
          //����� ������ ���� � �������� � ����������
          If (Bullet1.BulletDirection = blDirRight) then
            begin
            //���� ����� ������, ������ OldXBullet ������� (������) �� XBullet
            Bulletsprindex := 0;
            Obj1X1 := Bullet1.OldXBullet;
            Obj1Y1 := Bullet1.OldYBullet;
            Obj1X2 := Bullet1.XBullet + TBitmap(Bullet1.ImgMassBulletRight. Items[Bulletsprindex]).Width;
            Obj1Y2 := Bullet1.YBullet;
            Obj1X3 := Obj1X2;
            Obj1Y3 := Obj1Y1 + TBitmap(Bullet1.ImgMassBulletRight.Items[Bulletsprindex]).Height;
            Obj1X4 := Obj1X1;
            Obj1Y4 := Obj1Y1;
            end
          else
            begin
            Bulletsprindex := 0;
            //���� ����� �����, ������ OldXBullet ������, ��� XBullet
            Obj1X1 := Bullet1.XBullet;
            Obj1Y1 := Bullet1.YBullet;
            Obj1X2 := Bullet1.OldXBullet + TBitmap(Bullet1.ImgMassBulletLeft.Items[Bulletsprindex]).Width;
            Obj1Y2 := Bullet1.OldYBullet;
            Obj1X3 := Obj1X2;
            Obj1Y3 := Obj1Y1 + TBitmap(Bullet1.ImgMassBulletLeft.Items[Bulletsprindex]).Height;
            Obj1X4 := Obj1X1;
            Obj1Y4 := Obj1Y1;
            end;
          Obj2X1:= Worm1.Xworm;
          Obj2Y1:= Worm1.Yworm;

          If (Worm1.ThereMove = directionLeft) then
            begin
            //�������� ����� �����
            Obj2X2 := Obj2X1 + TBitmap(Worm1.ImgMassLeft.items[Worm1.sprleftindex]).Width;
            end
          else
            begin
            //ø������ ����� ������
            Obj2X2 := Obj2X1 + TBitmap(Worm1.ImgMassRight.items[Worm1.sprRightindex]).Width;
            end;
          Obj2Y2 := Obj2Y1;
          Obj2X3 := Obj2X2;
          If (Worm1.ThereMove = directionLeft) then
            begin
            Obj2Y3 := Obj2Y1 + TBitmap(Worm1.ImgMassLeft.items[Worm1.sprleftindex]).Height;
            end
          else
            begin
            Obj2Y3 := Obj2Y1 + TBitmap(Worm1.ImgMassRight.items[Worm1.sprRightindex]).Height;
            end;

          Obj2X4 := Obj2X1;
          Obj2Y4 := Obj2Y3;

//�������� ����� ��������
//VirtBitmap.Canvas.Rectangle(Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3));
//VirtBitmap.Canvas.Rectangle(Rect(Obj2X1, Obj2Y2, Obj2X3, Obj2Y3));

          //��������� ������������ ���� � �����
          //result := FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
          //                        Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4
          //                        );
          result := FindCollision( Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3), //� ��� ���� !!!
                                   Rect(Obj2X1, Obj2Y2, Obj2X3, Obj2Y3)); // ��� � ��� ��������,
          if Result = true then
            begin
//            if Bullet1.WeaponType = wtPssst then
//              begin
              Worm1.HitByBullet(Bullet1);
              Bullet1.BulletWasHitToSomeObject((Worm1));
              FreeAndNil(Bullets[n]);
//
//            end;
//            FreeAndNil(Bullet1);
            //�.�. ���� ����������, �� ��������� �� ������������ � ����������� ��������� � ����� �� �����
            //��������� ����
            break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

//������� ������������ ����� c ������
Function TForm1.CheckCollisionsBulletFly():boolean;
var
i,n:integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
Fly1: TMyFly;
Bullet1: TBullet;
Bulletsprindex: integer;
sprindex: integer;
begin
//������� ���� ������ ���� � ��������� � �� ����� ������� �������, ��������� ����������. ����� ���� ��������� ����
// � ��������� � �� ������� � ���������� � �.�, ���� �� �������� �� ����� ������� �������.
For n := 0 to MaxBullet - 1 do
begin
Bullet1 := Bullets[n];
if (Bullet1 <> nil) and
  (Bullet1.WeaponType = wtLight) then
  begin
  for i := 0 to MaxFly - 1 do
    begin
    Bullet1 := Bullets[n];
    if Bullet1 = nil then exit;
    Fly1 := Flyes[i];
    if Fly1 <> nil then
      begin
      if Fly1.FlyState = stLive then
        begin
        //���� ����� �����
        If (Fly1.ThereMove = directionLeft) then
          begin
          sprindex := Fly1.sprleftindex;
          end;
        //���� ����� ������
        If (Fly1.ThereMove = directionRight) then
          begin
          sprindex := Fly1.sprrightindex;
          end;
        // �������� ���������� ��������
        //            width
        // x1, y1 +--------------+ x2, y2
        //        |              |
        //        |              | height
        //        |              |
        // x4, y4 +--------------+ x3, y3
//TODO: ��������: ��� �������� � ����
        //����� ������ ���� � �������� � ����������
        If (Bullet1.BulletDirection = blDirRight) then
          begin
          //���� ����� ������, ������ OldXBullet ������� (������) �� XBullet
          Bulletsprindex := 0;
          Obj1X1 := Bullet1.OldXBullet;
          Obj1Y1 := Bullet1.OldYBullet;
          Obj1X2 := Bullet1.XBullet + TBitmap(Bullet1.ImgMassBulletRight.Items[Bulletsprindex]).Width;
          Obj1Y2 := Obj1Y1;
          Obj1X3 := Obj1X2;
          Obj1Y3 := Bullet1.YBullet + TBitmap(Bullet1.ImgMassBulletRight.Items[Bulletsprindex]).Height;
          Obj1X4 := Obj1X1;
          Obj1Y4 := Obj1Y1;
          end
        else
          begin
          Bulletsprindex := 0;
          //���� ����� �����, ������ OldXBullet ������, ��� XBullet
          Obj1X1 := Bullet1.XBullet;
          Obj1Y1 := Bullet1.YBullet;
          Obj1X2 := Bullet1.OldXBullet + TBitmap(Bullet1.ImgMassBulletLeft.Items[Bulletsprindex]).Width;
          Obj1Y2 := Obj1Y1;
          Obj1X3 := Obj1X2;
          Obj1Y3 := Bullet1.YBullet + TBitmap(Bullet1.ImgMassBulletLeft.Items[Bulletsprindex]).Height;
          Obj1X4 := Obj1X1;
          Obj1Y4 := Obj1Y1;
          end;

    Obj2X1 := Fly1.XFly;
    Obj2Y1 := Fly1.YFly;
         If (Fly1.ThereMove = directionLeft) then
            begin
            //�������� ����� �����
            Obj2X2 := Obj2X1 + TBitmap(Fly1.ImgMassLeft.items[Fly1.sprleftindex]).Width;
            end
          else
            begin
            //ø������ ����� ������
            Obj2X2 := Obj2X1 + TBitmap(Fly1.ImgMassRight.items[Fly1.sprRightindex]).Width;
            end;
          Obj2Y2 := Obj2Y1;
          Obj2X3 := Obj2X2;
          If (Fly1.ThereMove = directionLeft) then
            begin
            Obj2Y3 := Obj2Y1 + TBitmap(Fly1.ImgMassLeft.items[Fly1.sprleftindex]).Height;
            end
          else
            begin
            Obj2Y3 := Obj2Y1 + TBitmap(Fly1.ImgMassRight.items[Fly1.sprRightindex]).Height;
            end;
    Obj2X4 := Obj2X1;
    Obj2Y4 := Obj2Y3;

    end;


//   If (Worm1.ThereMove=WdirectionLeft) then
//      begin
//      sprindex:=Worm1.sprleftindex;
//      end;
   //ø������ ����� ������
//   If (Worm1.ThereMove=WdirectionRight) then
//      begin
//      sprindex:=Worm1.sprrightindex;
//      end;


     //
//   if Worm1<>Bullet1 then
//   begin
   //
//   If (Bullet1.BulletPosition=PozLeft) then
//      begin
//      sprindex:=0;
//      end;
   //
//   If (Bullet1.BulletPosition=PozRight) then
//      begin
//      sprindex:=0;
//      end;

   //result := FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
   //                       Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4
   //                       );
   result := FindCollision(Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3),
                           Rect(Obj2X1, Obj2Y1, Obj2X3, Obj2Y3));

   if Result=true then
      begin
      Fly1.HitByBullet(Bullet1);
      Bullet1.BulletWasHitToSomeObject(Fly1);
      FreeAndNil(Bullets[n]);
      //�.�. ���� ����������, �� ��������� �� ������������ � ����������� ��������� � ����� �� �����
      //��������� ����
      break;
//      FreeAndNil(Bullet1);

//      Worm1.shagx1:=0;
//      Worm1.shagx2:=0;
//      Worm1.shagy2:=4;
      //���� ����� �����
//      If Worm1.ThereMove =WdirectionLeft then
//         begin
//         Worm1.ThereMove:=WdirectionRight;
//         Worm1.shagx1:=4;
//         end
//      else
      //���� ����� ������
//         begin
//         Worm1.ThereMove:=WdirectionLeft;
//         Worm1.shagy2:=-4;
//         end;
//      If Bullet1.BulletPosition = PozLeft then
//         begin
//         Bullet1.BulletPosition:=PozRight;
//         Bullet1.shagx1:=4;
//         end
//      else
      //����� ���� ����� �����
//         begin
//         Obj2.ThereMove:=WdirectionLeft;
//         Obj2.shagx1:=-4;
//         end;
//      end;
      end;
   end;
   end;
   end;
   end;
end;

//������ ����
procedure TForm1.TimerBulletsTimer(Sender: TObject);
begin
ProcessingBullets;
end;

//������ ������
procedure TForm1.TimerFPSTimer(Sender: TObject);
var
i,j:byte;
begin
VirtBitmap.Width := XScreenMax;
VirtBitmap.Height := YScreenMax;
Form1.Width := VirtBitmap.Width;
Form1.Height := VirtBitmap.Height;

//��������� ����������� ����� ������ ������
//(���� ��� ������� �����, � ������ ���� �� ������ ����)
//VirtBitmap.Canvas.Brush.Color:=clBlack;
//VirtBitmap.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));

//�������� �� ����������� ����� ������ ����
//VirtBitmap.Canvas.Draw(0, 0, BackGroundBitmap);
//�������� ������ ��� �� ����������� �����
VirtBitmap.Canvas.FillRect(Rect(0, 0, VirtBitmap.Width, VirtBitmap.Height));

//�������� �������� ����� ������������, ����� ��������� ���� �� �������������
//���������� ��� ������� �� �������
CheckCollisionsFlyes();
CheckCollisionsWorms();
CheckCollisionsFlowerFly();
CheckCollisionsFlowerWorm();
CheckCollisionsBulletWorm();
CheckCollisionsBulletFly();
CheckCollisionOwlWeapon();
CheckCollisionWeaponBrick();
CheckCollisionsOwlWorms();
CheckCollisionsOwlFlyes();

//������ ������ ������������ �� ����������� ������
//�������
for i := 0 to MaxWorm - 1 do
   begin
   If Worms[i] <> nil then
     begin
     if Worms[i].WormState = stReadyForDestroy then
       begin
       Freeandnil(Worms[i]);
       Form1.TableWormsScore := Form1.TableWormsScore + 1;
       If CheckEndGame() = true then
         begin
         //������������� ���� ������
         TheVictory := true;
         end;
       end
     else
       begin
       Worms[i].Show();
       end;
     end;
   end;
//� ���
for i := 0 to MaxFly - 1 do
   begin
   If Flyes[i] <> nil then
     begin
     if Flyes[i].FlyState = stReadyForDestroy then
       begin
       Freeandnil(Flyes[i]);
       Form1.TableFlyesScore := Form1.TableFlyesScore + 1;
       If CheckEndGame() = true then
         begin
         //������������� ���� ������
         TheVictory := true;
         end;
       end
     else
     Flyes[i].Show;
     end;
   end;

//������� �� ������ ������
for i := 0 to MaxInGameClouds - 1 do
  begin
  Clouds[i].Show;
  end;

//������� �� ������ ����������
for i := 0 to MaxSunflower - 1 do
  begin
  Sunflowers[i].Show;
  end;
//������� �� ������ ������
Owl[0].Show;
for i := 0 to 1 do
  begin
  Weapons[i].Show;
  end;
  i := 0;
for j := 0 to MaxBullet - 1 do
  begin
  If Bullets[j] <> nil then
    begin
    Bullets[j].Show;
    end;
  if Bullets[j] <> nil then
    begin
    if (Bullets[j].XBullet <= xmin) OR
    (Bullets[j].XBullet >= xmax) then
    begin
    Freeandnil(Bullets[j]);
    end;
   end;
  end;
for i := 0 to MaxBrick - 1 do
  begin
  Bricks[i].Show;
  end;
  //Brick[1].Show;
If TheVictory = true then TheVictoryInGame;
If Owl[0].TheLoseOwl = true then
  begin
  TheLoseGame;
  end;
if Sunflowers[0].SunFlowerLose = true then
  begin
  VirtBitmap.Canvas.Font.Size := 18;
  VirtBitmap.Canvas.Font.Color:=clWhite;
  VirtBitmap.Canvas.TextOut(200,30,'���� ! ��������� ������. �� ��������� ...');
  end;
 //�������� ����������� ������
Form1.Image1.Canvas.Draw(0, 0, VirtBitmap);
end;

Procedure TForm1.ProcessingBullets;
var
j:byte;
begin
//������ ����� ����
//����� ����� ������ ����
for j := 0 to MaxBullet-1 do
  begin
  If Bullets[j]<> nil then
    begin
    Bullets[j].TimerBulletProcessing(nil);
    end;
  if Bullets[j]<>nil then
    begin
    if (Bullets[j].XBullet<=xmin) OR
    (Bullets[j].XBullet>=xmax) then
    begin
    Freeandnil(Bullets[j]);
    end;
   end;
  end;
end;

end.
