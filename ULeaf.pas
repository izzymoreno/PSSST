unit ULeaf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uConstant;

const
//Таймер задержки роста подсолнуха
LeafGrownTime = 1000;
//Спрайты листа
MaxImageLeaf = 3;
//Максимальное размеры фазы листа
MaxShowIndex = 3;

//Отрисовка листа слева или справа
type
    TLeafPosition = (pozLeft, pozRight);


type

  TLeaf = class (TObject)
    Name: string;
    ImageMassLeaf: array[0..MaxImageLeaf-1] of TBitMap;
    owner:TWinControl;
    ownerStem: TObject;
    LeafTick: Longint;
    TimerLeaf: TTimer;
    ShowIndex: integer;
    XLeaf, YLeaf: integer;
    LeafPosition: TLeafPosition;
    procedure Grown(Element:byte);
    procedure Show;
    procedure TimerLeafProcessing(Sender: TObject);
    Constructor CreateLeaf(X,Y: integer; ownerForm: TWinControl; Stem: TObject; InLeafPosition:TLeafPosition);
    Destructor Destroy(); //override;
  end;

implementation

uses Unit1, USunflower;

constructor TLeaf.CreateLeaf(X,Y:integer; ownerForm: TWinControl; Stem: TObject; InLeafPosition:TLeafPosition);
var
i,k:integer;
begin
//Координаты X и Y ствола
ownerStem := Stem;
XLeaf:=X;
YLeaf:=Y;
LeafPosition:=InLeafPosition;
ShowIndex:=0;
//Таймер для роста листочка
self.LeafTick := gettickcount();
//Sunflowerstemspr1:=2;
self.TimerLeaf:=TTimer.Create(nil);
self.TimerLeaf.OnTimer:=self.TimerLeafProcessing;
self.TimerLeaf.Interval:=round((Random*120)+(Random*60)+1);
//Sunflowerstemspr1:=2;
//XSunflower:=320;
//YSunflower:=round(Random*ymax);
self.owner:=ownerForm;
//MyCanvas[1]:=TImage.Create(owner);
//В зависимости от того какой лист мы грузим те или другие спрайты
if LeafPosition = pozLeft then
   begin
   For i:=0 to MaxImageLeaf-1 Do
       begin
       ImageMassLeaf[i]:=TBitMap.Create;
       ImageMassLeaf[i].LoadFromFile('Leaf'+IntToStr(i+1)+'.bmp');
       ImageMassLeaf[i].Transparent:=True;
       ImageMassLeaf[i].TransparentMode:=tmFixed;
       ImageMassLeaf[i].TransparentColor:=clBlack;
       end;
   end
else
   begin
   For i:=4 to 3+MaxImageLeaf Do
      begin
      ImageMassLeaf[i-4]:=TBitMap.Create;
      ImageMassLeaf[i-4].LoadFromFile('Leaf'+IntToStr(i)+'.bmp');
      ImageMassLeaf[i-4].Transparent:=True;
      ImageMassLeaf[i-4].TransparentMode:=tmFixed;
      ImageMassLeaf[i-4].TransparentColor:=clBlack;
      end;
   end;
end;

procedure TLeaf.TimerLeafProcessing(Sender: TObject);
var
i:integer;
begin
self.TimerLeaf.Interval:=Random(LeafGrownTime);
self.Grown(1);
end;

procedure TLeaf.Show;
var
res,newtick: Longint;
begin
//Перед тем как вывести, мы должны узнать координаты ствола родителя и на основе этих координат
//вычислить координаты листа
newtick := gettickcount();
res := newtick - self.LeafTick;
if res > 5000 then
   begin
   //Сохраняем новое значение tick
   self.LeafTick := newtick;
   //С момента последнего считывания таймера прошло 5 секунд
   self.ShowIndex := self.ShowIndex +1;
   if self.ShowIndex >= MaxShowIndex then self.ShowIndex :=0;
   end;
//Обращаемся к объекту родителя [TSteam]
XLeaf:=TStem(self.ownerStem).XStem;
YLeaf:=TStem(self.ownerStem).YStem;
//Узнаём, что нужно выводить спрайты листиков на левой стороне и выводим
If self.LeafPosition = pozLeft then
  begin
  XLeaf:=XLeaf - TStem(self.ownerStem).ImageMassStem[0].Width - 1;
  YLeaf:=YLeaf + TStem(self.ownerStem).ImageMassStem[0].Height;
  if self.ShowIndex = 0 then
     begin
     VirtBitmap.Canvas.Draw(self.XLeaf, self.YLeaf, self.ImageMassLeaf[0]);
     end;
  if self.ShowIndex = 1 then
     begin
     VirtBitmap.Canvas.Draw(self.XLeaf-30, self.YLeaf-60, self.ImageMassLeaf[1]);
     end;
  if self.ShowIndex = 2 then
     begin
     VirtBitmap.Canvas.Draw(self.XLeaf-75, self.YLeaf-80, self.ImageMassLeaf[2]);
//   VirtBitmap.Canvas.Draw(self.XHead-round(self.ImageMassHead[1].Width/2), self.YHead-round(self.ImageMassHead[1].Height/2), self.ImageMassHead[1]);
     end;
  end
else
  begin
//Узнаём, что нужно выводить спрайты листиков на правой стороне и выводим
  XLeaf:=XLeaf + TStem(self.ownerStem).ImageMassStem[0].Width + 1;
  YLeaf:=YLeaf + TStem(self.ownerStem).ImageMassStem[0].Height;
  if self.ShowIndex = 0 then
     begin
     VirtBitmap.Canvas.Draw(self.XLeaf, self.YLeaf, self.ImageMassLeaf[0]);
     end;
  if self.ShowIndex = 1 then
     begin
     VirtBitmap.Canvas.Draw(self.XLeaf, self.YLeaf-60, self.ImageMassLeaf[1]);
     end;
  if self.ShowIndex = 2 then
     begin
     VirtBitmap.Canvas.Draw(self.XLeaf, self.YLeaf-85, self.ImageMassLeaf[2]);
//   VirtBitmap.Canvas.Draw(self.XHead-round(self.ImageMassHead[1].Width/2), self.YHead-round(self.ImageMassHead[1].Height/2), self.ImageMassHead[1]);
     end;
  end;
//Знаем координаты угла и вычисляем координаты левой или правой стороны ствола для того, чтобы прикрепить и вывести листок

//Загружаем изображение ствола подсолнуха в объект
//MyCanvas[1].Left:=XStem;
//MyCanvas[1].Top:=YStem;
//MyCanvas[1].Picture.Assign(ImgMass[10]);
//MyCanvas[1].Visible:=True;
//MyCanvas[1].Parent:=owner;
//Выводим один членик на виртуальный Canvas
(*if self.ShowIndex = 0 then
   begin
   VirtBitmap.Canvas.Draw(self.XLeaf, self.YLeaf, self.ImageMassLeaf[0]);
   end;
if self.ShowIndex = 1 then
   begin
   VirtBitmap.Canvas.Draw(self.XLeaf-13, self.YLeaf, self.ImageMassLeaf[1]);
   end;
   if self.ShowIndex = 2 then
   begin
   VirtBitmap.Canvas.Draw(self.XLeaf-23, self.YLeaf, self.ImageMassLeaf[2]);
//   VirtBitmap.Canvas.Draw(self.XHead-round(self.ImageMassHead[1].Width/2), self.YHead-round(self.ImageMassHead[1].Height/2), self.ImageMassHead[1]);
   end;*)
end;

//Класс создания члеников подсолнуха
procedure TLeaf.Grown(Element:byte);
//var
//len:word;
//tmpStem: TStem;
//Новый членик
//NewStem: TStem;
//Xtmp,Ytmp:integer; //Координаты последней ветки массива
begin
(*
//Устанавливаем триггер, который указывает, распустился подсолнух или нет.
//Обнуляем длину массива
len:=0;
if Length(Sunflowerstem) > 0 then
   begin
   //Ищкем у координаты последней ветки
   //Узнаём длину массива
   len := Length(Sunflowerstem);
   //Ограничиваем рост подсолнуха
   if Length(Sunflowerstem)>SunflowerHeightMax then
                                                    begin
                                                    self.Head.ShowHeadOn:=1;
                                                    end;
   if Length(Sunflowerstem)<=SunflowerHeightMax then
   begin
   self.Head.ShowHeadOn:=0;
   //Находим последний элемент массива
   //Получаем экземпляр ветки из последней ячейки массива
   tmpStem := TStem(Sunflowerstem[len-1]);
   //Находим координаты последней ветки
   Xtmp:=tmpStem.XStem;
   //Узнаём координаты последнего членика и вычитаем из них высоту спрайта нового членика
   Ytmp:=tmpStem.YStem;
   Ytmp:=Ytmp-tmpStem.ImageMassStem[0].Height;
   //Присваеваем координаты головы подсолнуха
   //Вычисляем координату середины ствола и сдвигаем её на координату половины головы влево
   self.Head.XHead:=Xtmp-round(self.Head.ImageMassHead[0].Width/2)+round(tmpStem.ImageMassStem[0].Width/2);
   self.Head.YHead:=Ytmp-self.Head.ImageMassHead[0].Height;
   //Создаём новый членик с вычисленными координатами
   NewStem:=TStem.CreateStem(Xtmp,Ytmp,Form1);
   //Сохраняем новый объект в массиве
   SetLength(Sunflowerstem, len+1);
   Sunflowerstem[len]:=NewStem;
   //Находим последний элемент массива
//    tmpStem := TStem(Sunflowerstem[len-1]);
     end;
   end
 else
   //Если нет ни одного членика в массиве
   begin
   Xtmp:=XSunflower;
   Ytmp:=YSunflower;
   //Создаём новый членик, передав в него координаты этого членика
   NewStem:=TStem.CreateStem(Xtmp,Ytmp,Form1);
   //Сохраняем новый объект в массиве
   SetLength(Sunflowerstem, len+1);
   Sunflowerstem[len]:=NewStem;
   self.Head.XHead:=Xtmp-round(self.Head.ImageMassHead[0].Width/2)+round(NewStem.ImageMassStem[0].Width/2);
   self.Head.YHead:=Ytmp-self.Head.ImageMassHead[0].Height;
   end;*)
end;

//Выгружаем из памяти изображения из которых состоит подсолнух
destructor TLeaf.Destroy;
var
i:byte;
begin
//for i := 1 to MyCanvasMax do
//   begin
//   If MyCanvas[i]<>nil then MyCanvas[i].free;
//   end;
For i:=1 to  MaxImageLeaf Do
   begin
   if ImageMassLeaf[i]<>nil then ImageMassLeaf[i].free;
   end;
self.TimerLeaf.free;
inherited;
end;

end.
