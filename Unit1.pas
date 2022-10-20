//Основной листинг. Ядро.
unit Unit1;

interface

//Используемые модули
//Use modules
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ComCtrls,
  Dialogs, ExtCtrls, USunflower, UFlyes, UWorms, ULeaf, UOwl, UBullets, UWeapon, UBrick, UClouds, uConstant,
  jpeg, Menus, USettings, ULoading;

//Основные константы
//Basic constants
Const
//Шаг совы в передвижении с помощью клавиш
//Owl's step in moving with the keys
OwlXStep = 5;
OwlYStep = 5;
//MyCanvasMax = 1;
//Количество стен
//Number of walls
MaxBrick = 2;
//Количество сов
//Number of owls
MaxOwl = 1;
//Количество гусениц
//Number of worms
//MaxWorm = 10; //20
//Количество мух
//Number of flyes
//MaxFly = 10; //20
//Количество подсолнухов
//Number of Sunflowers
MaxSunflower = 1;
//Количество члеников подсолнуха
//Number of sunflower segments
//MaxSunflowerStem = 150;
//Амплитуда движения мух
//Movement amplitude flyes
SinFlyMax = 8; //50
//Максимальное количество пуль
//Max bullets
MaxBullet = 10;
//Количество спрэйев
//Number of sprays
MaxSpray = 2;
//Максимальное значение спрайтов оружия
//Max weapon sprite value
MaxImageWeapon = 1;
//Для молний Теслаагрегата
//For lightning Tesla aggregate
MaxImageSpriteWeapon = 1;
//Количество облаков в игре
//Number of clouds in the game
MaxInGameClouds = 1;
//Размер приложения
// Application size
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
        //Очки для таблицы рекордов
        //Points for highscore table
    //Гусеницы
    //Worms
    TableWormsScore: integer;
    //Мухи
    //Flyes
    TableFlyesScore: integer;
    //Шаг совы в передвижении с помощью клавиш
    //Owl's step in moving with the keys
    OwlXStep, OwlYStep: integer;
    TheVictory: boolean;
    //Массив гусениц
//    Worms:  array[0..MaxWorm - 1] of TMyWorm;
    Worms:  array of TMyWorm;
    //Массив мух
    //Array of flyes
    Flyes:  array of TMyFly;
    //Массив сов
    //Array of owls
    Owl:    array[0..MaxOwl - 1] of TMyOwl;
    //Массив подсолнухов
    //Array of Sunflowers
    Sunflowers: array[0..MaxSunflower - 1] of TSunflower;
    //Массив пуль
    //Array of bullets
    Bullets: array[0..MaxBullet - 1] of TBullet;
    //Спрэи
    //Sprays
    Weapons: array[0..MaxSpray - 1] of TWeapon;
    //Массив стен
    //Array of Bricks
    Bricks:  array[0..MaxBrick - 1] of TBrick;
    //Массив облаков
    //Array of Clouds
    Clouds: array[0..MaxInGameClouds - 1] of TCloud;
    //    SunflowersHead:TMySunflower;
    BulletTick: Longint;
    //Декларация основных функция
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
  //Заводим виртуальный Canvas
  //Create a virtual Canvas
  
  VirtBitmap: TBitmap;
  BackGroundBitmap: TBitmap;

  //Декларация списков спрайтов
  //Мух
  FlySpritesArrLeft: TList;
  FlySpritesArrRight: TList;
  FlySpritesArrHitLeft: TList;
  FlySpritesArrHitRight: TList;
  
  //Гусениц
  WormSpritesArrLeft: TList;
  WormSpritesArrRight: TList;
  WormSpritesArrHitLeft: TList;
  WormSpritesArrHitRight: TList;
  
  //Совы
  OwlSpritesArrLeft: TList;
  OwlSpritesArrRight: TList;
  OwlSpritesArrHitLeft: TList;
  OwlSpritesArrHitRight: TList;

  //Выстрелов из флакончика
  BulletSpritesArrLeft: TList;
  BulletSpritesArrRight: TList;

  StemSpritesArr: TList;
  HeadSpritesArr: TList;
  
  //
  WeaponPssstSpritesArrLeft: TList;
  WeaponPssstSpritesArrRight: TList;
  WeaponLightSpritesArrLeft: TList;
  WeaponLightSpritesArrRight: TList;
  
  //Молнии теслаагрегат
  LightSpritesArrLeft: TList;
  LightSpritesArrRight: TList;

  //Воронёнка
  CrowSpritesArrLeft: TList;
  CrowSpritesArrRight: TList;
  CrowSpritesArrHitLeft: TList;
  CrowSpritesArrHitRight: TList;
  
  //Облачко
  CloudsSpritesArr: TList;
//  CloudSpritesArrSmall: TList;
  
  //Молнии из туч
  LightSpritesArr: TList;
  //Дождя из туч
  RainSpritesArr: TList;

implementation

{$R *.dfm}
Procedure TForm1.TheLoseGame;
begin
  begin
  VirtBitmap.Canvas.Font.Size := 18;
  VirtBitmap.Canvas.Font.Color:=clWhite;
  VirtBitmap.Canvas.TextOut(200,30,'Жаль ! Вы проиграли ...');
  VirtBitmap.Canvas.TextOut(200,60,'Вы убили: '+IntToStr({Form1.}TableWormsScore)+' Гусениц');
  VirtBitmap.Canvas.TextOut(200,90,'Вы убили: '+IntToStr({Form1.}TableFlyesScore)+' Мух');
  end;
end;

Procedure TForm1.TheVictoryinGame;
begin
self.Sunflowers[0].TimerGrown.Interval := 1;
if self.Sunflowers[0].ShowHeadOn <> 0 then
  begin
  VirtBitmap.Canvas.Font.Size := 18;
  VirtBitmap.Canvas.Font.Color:=clWhite;
  VirtBitmap.Canvas.TextOut(200,30,'Ура ! Вы победили всех мух и гусениц');
  //SettingsForm.EditPlayerName
  end;
end;

//Procedure TForm1.TheLoseGame;
//begin
//VirtBitmap.Canvas.Font.Size := 18;
//VirtBitmap.Canvas.Font.Color:=clWhite;
//VirtBitmap.Canvas.TextOut(200,30,'Жаль ! Вы проиграли ...');
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
//Заполняем Canvas чёрным цветом
//Fill the canvas with black
//Form1.Image1.Canvas.Brush.Color:=clBlack;
//Form1.Image1.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));
Form1.Image1.Width := XScreenMax;
Form1.Image1.Height := YScreenMax;
//Создаём виртуальный Bitmap
//Create a virtual Bitmap
VirtBitmap := TBitmap.Create;
VirtBitmap.Canvas.Brush.Color := clBlack;
VirtBitmap.Width := XScreenMax;//Image1.Width;
VirtBitmap.Height := YScreenMax;//Image1.Height;
Form1.Image1.Width := XScreenMax;
Form1.Image1.Height := YScreenMax;

BackGroundBitmap := TBitmap.Create;
//BackGroundBitmap.LoadFromFile('Field.bmp');

Randomize;

 //Создаём форму с загрузкой компонентов
 //Create a form with loading components

//FormLoading := TFormLoading.Create(self);

//procedure TFormLoading.FormCreate(Sender: TObject);
//begin

//end;

//Загружаем все спрайты мух лево
//Load all fly sprites to the left
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
//Загружаем все спрайты мух правосторонние
//Load all right side flies sprites
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

//Загружаем все спрайты смерти мух левосторонние
//Load all left side fly death sprites
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
//Загружаем все спрайты смерти мух правосторонние
//Load all right side fly death sprites
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

//Загружаем все спрайты гусениц направленные влево
//Load all caterpillar sprites pointing left
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
//Загружаем все спрайты гусениц направленные вправо
//Load all caterpillar sprites pointing right
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


//Загружаем все спрайты разрушения гусениц влево
//Load all caterpillar sprites pointing left
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
//Загружаем все спрайты разрушения гусениц вправо

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
//Загружаем в спрайты совы смотрящей влево

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
//Загружаем в спрайты совы смотрящей вправо
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
//Загружаем в спрайты совы погибающей влево
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
//Загружаем в спрайты совы погибающей вправо
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

//Загружаем все спрайты спрэя облачка влево
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
//Загружаем все спрайты спрэя облачка вправо
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
//Загружаем спрайты оружия дихлофоса слева
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
//Загружаем спрайты оружия дихлофоса справа
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

//Загружаем спрайты оружия Тесламашины слева
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
//Загружаем спрайты оружия Тесламашины справа
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

//Загружаем спрайты оружия Тесламашины слева
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
//Загружаем спрайты оружия Тесламашины справа
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

//Загружаем спрайты ворона смотрящего влево
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
//Загружаем спрайты совы смотрящей вправо
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
//Загружаем спрайты совы погибающей влево
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
//Загружаем спрайты совы погибающей вправо
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
//Загружаем спрайты двух облаков
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

//Обнуляем количество уничтоженых гусениц и мух
SettingsForm := TSettingsForm.Create(self);
mresult := SettingsForm.ShowModal;
LevelNumber:= SettingsForm.TrackBarLevels.Position;
//Form1.Caption := 'Играет: ' + SettingsForm.EditPlayerName.Text;
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
Form1.Caption := 'Играет игрок по имени: ' + (SettingsForm.EditPlayerName.Text);
MaxWorm := SettingsForm.TrackBarWorms.Position;
SetLength(Worms, MaxWorm);

MaxFly := SettingsForm.TrackBarFlyes.Position;
SetLength(Flyes, MaxFly);

//Если счётчик уровня равен 1 то создаём на данном уровне только гусениц
if LevelNumber = 1 then
   begin
   //Form1.Caption := IntToStr(LevelNumber);
   if length(Worms) > 0 then
      begin
      for i := 0 to MaxWorm - 1 do
         begin
         //Создаём гусениц и устанавливаем максимальную координату по X и случайную по Y
         Worms[i] := TMyWorm.CreateWorm( Form1, WormSpritesArrLeft, WormSpritesArrRight,
                                  WormSpritesArrHitLeft, WormSpritesArrHitRight);
   //Только для отладки
//   Worms[i].Xworm := 400;
//   Worms[i].Yworm := 250;
         end;
      end;
   end;

//Если счётчик уровня равен 2 то создаём на данном уровне только мух
if LevelNumber = 2 then
   begin
   //Создаём мух
   if length(Flyes) > 0 then
      begin
      for i := 0 to MaxFly - 1 do
         begin
         //Создаём мух и устанавливаем максимальную координату по X и случайную по Y
         Flyes[i] := TMyFly.CreateFly( Form1, FlySpritesArrLeft, FlySpritesArrRight,
                                  FlySpritesArrHitLeft, FlySpritesArrHitRight);
         end;
      end;
   end;

//Если счётчик уровня равен 3 то создаём на данном уровне гусениц и мух

if LevelNumber = 3 then
   begin
   //Form1.Caption := IntToStr(LevelNumber);
   if length(Worms) > 0 then
      begin
      for i := 0 to MaxWorm - 1 do
         begin
         //Создаём гусениц и устанавливаем максимальную координату по X и случайную по Y
         Worms[i] := TMyWorm.CreateWorm( Form1, WormSpritesArrLeft, WormSpritesArrRight,
                                  WormSpritesArrHitLeft, WormSpritesArrHitRight);
   //Только для отладки
//   Worms[i].Xworm := 400;
//   Worms[i].Yworm := 250;
         end;
      end;

   //Создаём мух
   if length(Flyes) > 0 then
      begin
      for i := 0 to MaxFly - 1 do
         begin
         //Создаём мух и устанавливаем максимальную координату по X и случайную по Y
         Flyes[i] := TMyFly.CreateFly( Form1, FlySpritesArrLeft, FlySpritesArrRight,
                                  FlySpritesArrHitLeft, FlySpritesArrHitRight);
         end;
      end;
   end;



//Создаём сову
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

//Создаём оружие-спрэйи
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
//Создаём подсолнух

if length(Clouds) > 0 then
  begin
  for i := 0 to MaxInGameClouds-1 do
    begin
    Clouds[i]:=TCloud.CreateCloud(50,50, Form1, CloudsSpritesArr); // CreateSunflower(round(VirtBitmap.Width/2),VirtBitmap.Height-50, Form1);
//    Sunflowers[i]:=TSunflower.CreateSunflower(Random(xmax)-60,Random(ymax)-20,Form1);
//Вызываем процедуру вывода облака
    Clouds[i].Show;
    end;
  end;


if length(Sunflowers) > 0 then
  begin
  for i := 0 to MaxSunflower-1 do
    begin
    Sunflowers[i]:=TSunflower.CreateSunflower(round(VirtBitmap.Width/2),VirtBitmap.Height-50, Form1);
//    Sunflowers[i]:=TSunflower.CreateSunflower(Random(xmax)-60,Random(ymax)-20,Form1);
//Рост подсолнуха на 1 членик
    Sunflowers[i].Grown(1);
//Вызываем процедуру вывода подсолнуха
    Sunflowers[i].Show;
    end;
  end;

//Инициализируем массив пуль, т.е, заполняем его nil
if length(Bullets) > 0 then
  begin
  for i := 0 to MaxBullet-1 do
    begin
    //Создаём гусениц и устанавливаем максимальную координату по X и случайную по Y
    Bullets[i] := nil;
    end;
  end;
//Шаг по Икс и по Игрэк Совёнка
OwlXStep := 5;
OwlYStep := 5;
//Отрисовываем Совёнка
Owl[0].Show;
//Левая стена
if length(Bricks) > 0 then
  begin
  for i := 0 to MaxBrick-1 do
    begin
    Bricks[i] := TBrick.CreateBrick(round(0),round(VirtBitmap.Height - 190-i*130),directionBrickLeft,nil);
    Bricks[i].Show;
    //Левая стена
    //Brick[1]:=TBrick.CreateBrick(250,30,directionBrickRight,nil);
    //Brick[1].Show;
    end;
  end;

//Проверяем кто играет CheatMode
if Form1.Caption = 'Играет игрок по имени: Билл Гейтс' then TheVictory := true;
if Form1.Caption = 'Играет игрок по имени: Стив Балмер' then
   begin
   if LevelNumber = 1 then
       begin
       for i:= 1 to MaxWorm-1 do
          begin
          Worms[i].WormState := stHit;
          end;
       end;
if Form1.Caption = 'Стив Джобс' then
   begin
   end;

   end;
//

if (mresult = mrClose) then
    begin
    //перезапуск игры
    //Self.Destroy;
    postmessage(self.Handle, WM_CLOSE, 0, 0);
    end;

//Включаем таймер отрисовки
self.TimerFPS.Enabled := true;
end;

Procedure TForm1.DestroyLevel;
var
i: byte;
tmpBitmap: TBitmap;
begin
//Выключаем таймер отрисовки
if BackGroundBitmap <> nil then FreeAndNil(BackGroundBitmap);
self.TimerFPS.Enabled := false;
//Удаляем из памяти подсолнух
//if Sunflowers[0]<>nil then Sunflowers[0].Free;
//Удаляем из памяти массив гусениц и мух
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

//Выгружаем подсолнух, гусениц, мух из памяти
procedure TForm1.FormDestroy(Sender: TObject);
var
i: byte;
tmpBitmap: TBitmap;
begin
//Вызываем процедуру, которая уничтожает объекты игрового пространства
DestroyLevel;

//Здесь мы удаляем из памяти мух
For i := 0 to  MaxImageFly - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if FlySpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(FlySpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to  MaxImageFly - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if FlySpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(FlySpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;

For i := 0 to  MaxImageHitLeftFly - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if FlySpritesArrHitLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(FlySpritesArrHitLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to  MaxImageHitRightFly - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
  if WormSpritesArrHitRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(FlySpritesArrHitRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
    end;

For i := 0 to MaxImageWorm - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if WormSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(WormSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to MaxImageWorm - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if WormSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(WormSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to MaxImageHitLeftWorm - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if WormSpritesArrHitLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(WormSpritesArrHitLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i := 0 to MaxImageHitRightWorm - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if WormSpritesArrHitRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(WormSpritesArrHitRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
  end;
//Удаляем из памяти совёнка левую фазу
For i := 0 to MaxImageLeftOwl Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if OwlSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(OwlSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
//И правую
For i := 0 to MaxImageRightOwl Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if OwlSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(OwlSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
//
//Удаляем из памяти погибающего совёнка левую фазу
For i := 0 to MaxImageLeftDieOwl - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if OwlSpritesArrHitLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(OwlSpritesArrHitLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
//И правую
For i := 0 to MaxImageRightDieOwl - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if OwlSpritesArrHitRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(OwlSpritesArrHitRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;


For i := 0 to MaxImageBullet - 1 Do
  begin
  //Если объект существует в памяти, то мы его удаляем
  if BulletSpritesArrLeft[i] <> nil then
    begin
    tmpBitmap := TBitmap(BulletSpritesArrLeft.Items[i]);
    Freeandnil(tmpBitmap);
    end;
  end;
//
For i := 0 to MaxImageBullet - 1 Do
  begin
  //Если объект существует в памяти, то мы его удаляем
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

//Выгружаем из памяти дихлофос
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if WeaponPssstSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(WeaponPssstSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if WeaponPssstSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(WeaponPssstSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;

   //Выгружаем из памяти Тесламашину
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if WeaponLightSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(WeaponLightSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if WeaponLightSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(WeaponLightSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;

   //Выгружаем из памяти Молнии
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if LightSpritesArrLeft[i] <> nil then
     begin
     tmpBitmap := TBitmap(LightSpritesArrLeft.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;
For i:=0 to MaxImageWeapon - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if LightSpritesArrRight[i] <> nil then
     begin
     tmpBitmap := TBitmap(LightSpritesArrRight.Items[i]);
     Freeandnil(tmpBitmap);
     end;
   end;

//Выгружаем виртуальный канвас
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
            //Сохраняем новое значение tick
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
            //Разворачиваем спрайт совы влево с индексами 0 и 1
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
           //Разворачиваем спрайт совы вправо с индексами 2 и 3

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

//Далее следует процедура опроса клавиатуры
procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case key of
//Опрашиваем клавишу курсора вверх
   vk_up:
         begin
         Owl[0].shagy:=0;
         Owl[0].AnimationShag:=0;
//         VirtBitmap.Canvas.Draw(Owl[0].XOwl, Owl[0].YOwl, Owl[0].ImgMass[1])
         end;
//Опрашиваем клавишу курсора влево
   vk_left:
         begin
         Owl[0].shagx:=0;
         Owl[0].AnimationShag:=0;
//         VirtBitmap.Canvas.Draw(Owl[0].XOwl, Owl[0].YOwl, Owl[0].ImgMass[1])
         end;
//Опрашиваем клавишу курсора вправо
   vk_right:
         begin
         Owl[0].shagx:=0;
         Owl[0].AnimationShag:=0;
//         VirtBitmap.Canvas.Draw(Owl[0].XOwl, Owl[0].YOwl, Owl[0].ImgMass[1])
         end;
//Опрашиваем клавишу курсора вниз
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

//Функция сравнения наложения двух прямоугольников друг на друга
Function TForm1.FindCollision(RectBullet,
                              RectBox: TRect
                              ): Boolean;
begin
//ВНИМАНИЕ !!! ПЕРВЫЙ ОБЪЕКТ - ЭТО ЯЩИК, А ВТОРОЙ ОБЪЕКТ ЭТО ПУЛЯ
Result := false;
//Берём точку левого верхнего угла второго нашего прямоугольника и сравниваем, входит ли она внутрь первого четырёхугольника
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
//Берём точку правого верхнего угла второго нашего прямоугольника и сравниваем, входит ли она внутрь первого четырёхугольника
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
//Берём точку правого нижнего угла второго нашего прямоугольника и сравниваем, входит ли она внутрь первого четырёхугольника
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
//Берём точку левого нижнего угла второго нашего прямоугольника и сравниваем, входит ли она внутрь первого четырёхугольника
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
//Пуля больше, чем объект и полностью накрывает его
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


//Функция сравнения наложения двух прямоугольников друг на друга
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

//Берём точку левого верхнего угла второго нашего прямоугольника и сравниваем, входит ли она внутрь первого четырёхугольника
//(Obj2X1, Obj2Y1)
Result:=false;
If (Obj2X1>=Obj1X1) and (Obj2X1<=Obj1X2) and (Obj2Y1>=Obj1Y1) and (Obj2Y1<=Obj1Y3) then
  begin
  Result:=true;
  exit;
  end;
//Берём точку правого верхнего угла второго нашего прямоугольника и сравниваем, входит ли она внутрь первого четырёхугольника
//(Obj2X2, Obj2Y2)
If (Obj2X2<=Obj1X3) and (Obj2X2>=Obj1X4) and (Obj2Y2>=Obj1Y1) and (Obj2Y2<=Obj1Y4) then
  begin
  Result:=true;
  exit;
  end;
//Берём точку правого нижнего угла второго нашего прямоугольника и сравниваем, входит ли она внутрь первого четырёхугольника
If (Obj2X3>=Obj1X1) and (Obj2X3<=Obj1X2) and (Obj2Y3>=Obj1Y1) and (Obj2Y3<=Obj1Y4) then
  begin
  Result:=true;
  exit;
  end;
//Берём точку левого нижнего угла второго нашего прямоугольника и сравниваем, входит ли она внутрь первого четырёхугольника
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
//если оружие уже находиться в руках, то не надо проверять соприкосновение с этим оружием

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
       Obj1X1 := Bricks[n].XBrick;//верхний левый угол
       Obj1Y1 := Bricks[n].YBrick;//верхний левый угол
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

     //спрэй столкнулся со стеной
     result:= FindCollision(Rect( Obj1X1, Obj1Y1, Obj1X3, Obj1Y3),
                           Rect( Obj2X1, Obj2Y1, Obj2X3, Obj2Y3));
     if Result = true then
       begin
       If Weapons[i].WeaponinBox = false then
         begin
         //полка свободна
         if Bricks[n].Weapon = nil then
           begin
           Weapons[i].WeaponDown(Owl[0], Bricks[n]);
           Weapons[i].WeaponinBox := true;
           end
         else
           begin
           //полка занята
           if Owl[0].Weapon = nil then
             begin
             //при этом у совы ничего нет
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
//если оружие уже находиться в руках, то не надо проверять соприкосновение с этим оружием
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3
for weap := 0 to MaxSpray - 1 do
  begin
  if (Owl[0].Weapon <> nil) then exit;
//Здесь мы проверяем только на один вид оружия
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

//Функция столкновения мух между собой
Function TForm1.CheckCollisionsFlyes():boolean;
var
i,n:integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
Fly1, Fly2: TMyFly;
begin
//Сначала проверим столкновени, т.е. берём первый объект из массива и сравниваем его со вторым объектом из массива, с третьим и т.д. до последнего
//потом берём второй объект из массива и сравниваем с третьим объектом из массива, четвёртым, пятым и т.д.
//потом берём третий объект измассива и сравниваем его с четвёртым объектом из массива, пятым и т.д.
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

   //Муха летит влево
   If (Fly1.ThereMove = directionLeft) then
      begin
      Obj1X2 := Obj1X1 + TBitMap(Fly1.ImgMassLeft.Items[Fly1.sprleftindex]).Width;
      Obj1Y2 := Obj1Y1;
      Obj1X3 := Obj1X2;
      Obj1Y3 := Obj1Y1 + TBitMap(Fly1.ImgMassLeft.Items[Fly1.sprleftindex]).Height;
      Obj1X4 := Obj1X1;
      Obj1Y4 := Obj1Y3;

      end;
   //Муха летит вправо
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
     //Создаём мух и устанавливаем максимальную координату по X и случайную по Y
   if (Fly2 <> nil) and
      (Fly2.FlyState = stLive) then
     begin
     if Fly1<>Fly2 then
   begin
   Obj2X1 := Fly2.XFly;
   Obj2Y1 := Fly2.YFly;
   //Муха летит влево
   If (Fly2.ThereMove = directionLeft) then
      begin
      Obj2X2 := Obj2X1+TBitMap(Fly2.ImgMassLeft.Items[Fly2.sprleftindex]).Width;
      Obj2Y2 := Obj2Y1;
      Obj2X3 := Obj2X2;
      Obj2Y3 := Obj2Y1+TBitMap(Fly2.ImgMassLeft.Items[Fly2.sprleftindex]).Height;
      Obj2X4 := Obj2X1;
      Obj2Y4 := Obj2Y3;
      end;
   //Муха летит вправо
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

//Функция столкновения листьев подсолнуха и гусениц
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
//Ñíà÷àëà ïðîâåðèì ñòîëêíîâåíèå, ò.å. áåð¸ì ïåðâûé îáúåêò èç ìàññèâà ñòâîëà ïîäñîëíóõà è ñðàâíèâàåì åãî ñ ïåðâûì îáúåêòîì èç ìàññèâà ìóõ, ñî âòîðûì, ñ òðåòüèì è ò.ä. äî ïîñëåäíåãî
//ïîòîì áåð¸ì âòîðîé îáúåêò èç ìàññèâà ñòâîëà è ñðàâíèâàåì ñ ïåðâûì, âòîðûì, òðåòüèì îáúåêòîì èç ìàññèâà ìóõ, ÷åòâ¸ðòûì, ïÿòûì è ò.ä.
//Êàê òîëüêî ìû íàøëè îäèíàêîâûå êîîðäèíàòû, øàã ìóõè äîëæåí ðàâíÿòüñÿ íóëþ.
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
   //Ãóñåíèöà ïîëç¸ò âëåâî
  If (Worm.ThereMove=DirectionLeft) then
    begin
    sprindex := Worm.sprleftindex;
    end;
   //Ãóñåíèöà ïîëç¸ò âïðàâî
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

//Ôóíêöèÿ ñòîëêíîâåíèÿ ñòâîëà ïîäñîëíóõà è ìóõ
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
//Ñíà÷àëà ïðîâåðèì ñòîëêíîâåíèå, ò.å. áåð¸ì ïåðâûé îáúåêò èç ìàññèâà ñòâîëà ïîäñîëíóõà è ñðàâíèâàåì åãî ñ ïåðâûì îáúåêòîì èç ìàññèâà ìóõ, ñî âòîðûì, ñ òðåòüèì è ò.ä. äî ïîñëåäíåãî
//ïîòîì áåð¸ì âòîðîé îáúåêò èç ìàññèâà ñòâîëà è ñðàâíèâàåì ñ ïåðâûì, âòîðûì, òðåòüèì îáúåêòîì èç ìàññèâà ìóõ, ÷åòâ¸ðòûì, ïÿòûì è ò.ä.
//Êàê òîëüêî ìû íàøëè îäèíàêîâûå êîîðäèíàòû, øàã ìóõè äîëæåí ðàâíÿòüñÿ íóëþ.
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
     //Ìóõà ëåòèò âëåâî
     If (Fly.ThereMove = directionLeft) then
       begin
       sprindex:=Fly.sprleftindex;
       end;
     //Ìóõà ëåòèò âïðàâî
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
            //ò.ê. ïóëÿ óíè÷òîæåíà, òî ïðîâåðÿòü åå ñòîëêíîâåíèå ñ îñòàâøèìèñÿ îáúåêòàìè â öèêëå íå íóæíî
            //ïðåðûâàåì öèêë
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
     //Ãóñåíèöà ïîëç¸ò âëåâî
     If (Worms[n].ThereMove = directionLeft) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Worms[n].ImgMassLeft.items[Worms[n].sprleftindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Worms[n].ImgMassLeft.items[Worms[n].sprleftindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
   //Ãóñåíèöà ïîëç¸ò âïðàâî
     If (Worms[n].ThereMove = directionRight) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Worms[n].ImgMassRight.items[Worms[n].sprrightindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Worms[n].ImgMassRight.items[Worms[n].sprrightindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
     //Ñðàâíèâàåì êîîðäèíàòû ãóñåíèöû ñ ñîâ¸íêîì è äåëàåì òàê ÷òîáû ñîâ¸íîê ïîãèá
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
     //Ãóñåíèöà ïîëç¸ò âëåâî
     If (Flyes[n].ThereMove = directionLeft) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Flyes[n].ImgMassLeft.items[Flyes[n].sprleftindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Flyes[n].ImgMassLeft.items[Flyes[n].sprleftindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
   //Ãóñåíèöà ïîëç¸ò âïðàâî
     If (Flyes[n].ThereMove = directionRight) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Flyes[n].ImgMassRight.items[Flyes[n].sprrightindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Flyes[n].ImgMassRight.items[Flyes[n].sprrightindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
     //Ñðàâíèâàåì êîîðäèíàòû ãóñåíèöû ñ ñîâ¸íêîì è äåëàåì òàê ÷òîáû ñîâ¸íîê ïîãèá
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


//Ôóíêöèÿ ñòîëêíîâåíèÿ ãóñåíèö
Function TForm1.CheckCollisionsWorms():boolean;
var
i,n:integer;
Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4:integer;
Worm1, Worm2: TMyWorm;
begin
//Ñíà÷àëà ïðîâåðèì ñòîëêíîâåíè, ò.å. áåð¸ì ïåðâûé îáúåêò èç ìàññèâà è ñðàâíèâàåì åãî ñî âòîðûì îáúåêòîì èç ìàññèâà, ñ òðåòüèì è ò.ä. äî ïîñëåäíåãî
//ïîòîì áåð¸ì âòîðîé îáúåêò èç ìàññèâà è ñðàâíèâàåì ñ òðåòüèì îáúåêòîì èç ìàññèâà, ÷åòâ¸ðòûì, ïÿòûì è ò.ä.
//ïîòîì áåð¸ì òðåòèé îáúåêò èçìàññèâà è ñðàâíèâàåì åãî ñ ÷åòâ¸ðòûì îáúåêòîì èç ìàññèâà, ïÿòûì è ò.ä.
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

     //Ãóñåíèöà ïîëç¸ò âëåâî
     If (Worm1.ThereMove = directionLeft) then
       begin
       Obj1X2 := Obj1X1 + TBitmap(Worm1.ImgMassLeft.items[Worm1.sprleftindex]).Width;
       Obj1Y2 := Obj1Y1;
       Obj1X3 := Obj1X2;
       Obj1Y3 := Obj1Y1 + TBitmap(Worm1.ImgMassLeft.items[Worm1.sprleftindex]).Height;
       Obj1X4 := Obj1X1;
       Obj1Y4 := Obj1Y3;
       end;
   //Ãóñåíèöà ïîëç¸ò âïðàâî
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
     //Ñîçäà¸ì ãóñåíèö è óñòàíàâëèâàåì ìàêñèìàëüíóþ êîîðäèíàòó ïî X è ñëó÷àéíóþ ïî Y
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
       //Ãóñåíèöà ïîëç¸ò âëåâî
           If (Worm2.ThereMove = directionLeft) then
             begin
             Obj2X2:= Obj2X1 + TBitmap(Worm2.ImgMassLeft.items[Worm1.sprleftindex]).Width;
             Obj2Y2:= Obj2Y1;
             Obj2X3:= Obj2X2;
             Obj2Y3:= Obj2Y1 + TBitmap(Worm2.ImgMassLeft.items[Worm1.sprleftindex]).Height;
             Obj2X4:= Obj2X1;
             Obj2Y4:= Obj2Y3;
             end;
      //Ãóñåíèöà ïîëç¸ò âïðàâî
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
        //Ìóõà ëåòèò âëåâî
        If Worm1.ThereMove =directionLeft then
          begin
          Worm1.ThereMove:=directionRight;
          Worm1.shagx1:=4;
          end
        else
          //Ìóõà ëåòèò âïðàâî
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
          //Èíà÷å ìóõà ëåòèò âëåâî
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

//Ôóíêöèÿ ñòîëêíîâåíèÿ ãóñåíèö c ïóëÿìè
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
//Ñíà÷àëà áåð¸ì ïåðâóþ ïóëþ è ïðîãîíÿåì å¸ ïî âñåìó ìàññèâó ãóñåíèö, ñðàâíèâàÿ êîîðäèíàòû. Ïîòîì áåð¸ì ñëåäóþùóþ ïóëþ
// è ïðîãîíÿåì å¸ ïî ìàññèâó ñ ãóñåíèöàìè è ò.ä, ïîêà íå ïðîãîíèì ïî âñåìó ìàññèâó ãóñåíèö.
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

// Ïîëó÷àåì êîîðäèíàòû ãóñåíèöû
//            width
// x1, y1 +--------------+ x2, y2
//        |              |
//        |              | height
//        |              |
// x4, y4 +--------------+ x3, y3

//TODO: ÄÎÄÅËÀÒÜ: ÍÅÒ ÀÍÈÌÀÖÈÈ Ó ÏÓËÈ
          //Âçÿëè ïåðâóþ ïóëþ è ïîëó÷èëè å¸ êîîðäèíàòû
          If (Bullet1.BulletDirection = blDirRight) then
            begin
            //ïóëÿ ëåòèò âïðàâî, çíà÷èò OldXBullet îòñòàþò (ìåíüøå) îò XBullet
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
            //ïóëÿ ëåòèò âëåâî, çíà÷èò OldXBullet áîëüøå, ÷åì XBullet
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
            //Ãóñåíèöà ïîëç¸ò âëåâî
            Obj2X2 := Obj2X1 + TBitmap(Worm1.ImgMassLeft.items[Worm1.sprleftindex]).Width;
            end
          else
            begin
            //Ã¸ñåíèöà ïîëç¸ò âïðàâî
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

//Âêëþ÷àåì ñàñêè ñïðàéòîâ
//VirtBitmap.Canvas.Rectangle(Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3));
//VirtBitmap.Canvas.Rectangle(Rect(Obj2X1, Obj2Y2, Obj2X3, Obj2Y3));

          //Проверяем столкновение пули и гусеницы
          //result := FindCollision(Obj1X1, Obj1Y1, Obj1X2, Obj1Y2, Obj1X3, Obj1Y3, Obj1X4, Obj1Y4,
          //                        Obj2X1, Obj2Y1, Obj2X2, Obj2Y2, Obj2X3, Obj2Y3, Obj2X4, Obj2Y4
          //                        );
          result := FindCollision( Rect(Obj1X1, Obj1Y1, Obj1X3, Obj1Y3), //а это пуля !!!
                                   Rect(Obj2X1, Obj2Y2, Obj2X3, Obj2Y3)); // это у нас гусеница
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
             //т.к. пуля уничтожена, то проверять ее столкновение с оставшимися объектами в цикле не нужно
            //прерываем цикл
            break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

//Функция столкновения мушек c пулями
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
//Сначала берём первую пулю и прогоняем её по всему массиву гусениц, сравнивая координаты. Потом берём следующую пулю
// и прогоняем её по массиву с гусеницами и т.д, пока не прогоним по всему массиву гусениц.
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
        //Муха летит влево
        If (Fly1.ThereMove = directionLeft) then
          begin
          sprindex := Fly1.sprleftindex;
          end;
        //Муха летит вправо
        If (Fly1.ThereMove = directionRight) then
          begin
          sprindex := Fly1.sprrightindex;
          end;
        // Получаем координаты гусеницы
        //            width
        // x1, y1 +--------------+ x2, y2
        //        |              |
        //        |              | height
        //        |              |
        // x4, y4 +--------------+ x3, y3
//TODO: ДОДЕЛАТЬ: НЕТ АНИМАЦИИ У ПУЛИ
        //Взяли первую пулю и получили её координаты
        If (Bullet1.BulletDirection = blDirRight) then
          begin
          //пуля летит вправо, значит OldXBullet отстают (меньше) от XBullet
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
          //пуля летит влево, значит OldXBullet больше, чем XBullet
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
            //Гусеница ползёт влево
            Obj2X2 := Obj2X1 + TBitmap(Fly1.ImgMassLeft.items[Fly1.sprleftindex]).Width;
            end
          else
            begin
            //Гусеница ползёт вправо
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
   //Гусеница ползёт вправо
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
      //т.к. пуля уничтожена, то проверять ее столкновение с оставшимися объектами в цикле не нужно
      //прерываем цикл
      break;
//      FreeAndNil(Bullet1);

//      Worm1.shagx1:=0;
//      Worm1.shagx2:=0;
//      Worm1.shagy2:=4;
      //Гусеница ползёт влево
//      If Worm1.ThereMove =WdirectionLeft then
//         begin
//         Worm1.ThereMove:=WdirectionRight;
//         Worm1.shagx1:=4;
//         end
//      else
      //Гусеница ползёт вправо
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
      //Иначе муха летит влево
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

//Таймер пуль
procedure TForm1.TimerBulletsTimer(Sender: TObject);
begin
ProcessingBullets;
end;

//Таймер движка
procedure TForm1.TimerFPSTimer(Sender: TObject);
var
i,j:byte;
begin
VirtBitmap.Width := XScreenMax;
VirtBitmap.Height := YScreenMax;
Form1.Width := VirtBitmap.Width;
Form1.Height := VirtBitmap.Height;//Таймер движка
procedure TForm1.TimerFPSTimer(Sender: TObject);
var
i,j:byte;
begin
VirtBitmap.Width := XScreenMax;
VirtBitmap.Height := YScreenMax;
Form1.Width := VirtBitmap.Width;
Form1.Height := VirtBitmap.Height;

//Заполняем виртуальный экран чёрным цветом
//(если нет заднего плана, а просто игра на черном фоне)
//VirtBitmap.Canvas.Brush.Color:=clBlack;
//VirtBitmap.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));

//Копируем на виртуальный экран задний план
//VirtBitmap.Canvas.Draw(0, 0, BackGroundBitmap);
//Заливаем черный фон на виртуальный экран
//VirtBitmap.Canvas.FillRect(Rect(0, 0, VirtBitmap.Width, VirtBitmap.Height));

//Çàïîëíÿåì âèðòóàëüíûé ýêðàí ÷¸ðíûì öâåòîì
//(åñëè íåò çàäíåãî ïëàíà, à ïðîñòî èãðà íà ÷åðíîì ôîíå)
//VirtBitmap.Canvas.Brush.Color:=clBlack;
//VirtBitmap.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));

//Êîïèðóåì íà âèðòóàëüíûé ýêðàí çàäíèé ïëàí
//VirtBitmap.Canvas.Draw(0, 0, BackGroundBitmap);
//Çàëèâàåì ÷åðíûé ôîí íà âèðòóàëüíûé ýêðàí
VirtBitmap.Canvas.FillRect(Rect(0, 0, VirtBitmap.Width, VirtBitmap.Height));

//Вызываем функциии наших столкновений, чтобы проверить есть ли стоклкновения
//Перебираем все объекты по очереди
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

//Каждый объект отрисовываем на виртуальный канвас
//Гусениц
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
         //Устанавливаем флаг Победы
         TheVictory := true;
         end;
       end
     else
       begin
       Worms[i].Show();
       end;
     end;
   end;
//И мух
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
         //Устанавливаем флаг Победы
         TheVictory := true;
         end;
       end
     else
     Flyes[i].Show;
     end;
   end;

//Выводим на канвас облака
for i := 0 to MaxInGameClouds - 1 do
  begin
  Clouds[i].Show;
  end;

//Выводим на канвас подсолнухи
for i := 0 to MaxSunflower - 1 do
  begin
  Sunflowers[i].Show;
  end;
//Выводим на канвас Совёнка
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
  VirtBitmap.Canvas.TextOut(200,30,'Æàëü ! Ïîäñîëíóõ ñúåäåí. Âû ïðîèãðàëè ...');
  end;
 //Копируем виртуальный канвас
Form1.Image1.Canvas.Draw(0, 0, VirtBitmap);
end;

Procedure TForm1.ProcessingBullets;
var
j:byte;
begin
//Таймер полёта пули
//Здесь будет таймер пуль
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
