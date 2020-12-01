unit USunflower;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ULeaf, uConstant;

const

//������ �������� ����� ����������
SunFlowersTime = 1000;
//������ ������ ����������
MaxImageStem = 1;
//������� ������� ����������
MaxImageHead = 2;
//������ ����� ���������� � ���������� ��������
SunflowerHeightMax = 150;  //49
//������� �������
MaxImageLeaf = 6;


xmax = 860;
ymax = 520;
xmin = 0;
ymin = 0;

type

  TStem = class (TObject)
    Name: string;
    ImageMassStem: array[0..MaxImageStem-1] of TBitMap;
    //������ �������� �������
    //ImageMassStem: TList;
    owner :TWinControl;
    Leaf: TLeaf;
    ownerSunflower: TObject;
    Timer: TTimer;
    XStem, YStem: integer;
    procedure Show;
    procedure TimerStemTimer(Sender: TObject);
    Constructor CreateStem(X,Y: integer; ownerForm: TWinControl; ownSunflower: TObject; pStemSprites: TList);
    Destructor Destroy(); //override;
  end;

  THead = class (TObject)
    Name: string;
    ImageMassHead: array[0..MaxImageHead-1] of TBitMap;
//    ImageMassHead: TList;
    ownerSunflower: TObject;
    Timer: TTimer;
    XHead, YHead: integer;
//�������, ������� ���������, ����������� ��������� ��� ���.
    ShowHeadOn: integer;
    procedure Show;
    Constructor CreateHead(X,Y: integer; ownerForm: TWinControl; ownSunflower: TObject; pHeadSprites: TList);
    Destructor Destroy(); //override;
  end;


  TSunflower = class (TObject)
  public
  Name: string;
//����� ������ ����������
  //Sunflowerstem: array of TStem;
  Sunflowerstem: TList;//������ TStem;
  SunFlowerLose: boolean;
  ShowHeadOn: integer;
  Head: THead;
  TimerGrown: TTimer;
  owner:TWinControl;
  XSunflower, YSunflower, Sunflowerstemspr1, Sunflowerstemspr2 :integer;
//  procedure GetHeightSunflower;
  procedure TimerGrownTimer(Sender: TObject);
  procedure Show;
  procedure Grown(Element:byte);
  procedure UnGrown(Element:byte);
  Constructor CreateSunflower(X,Y: integer; ownerForm: TWinControl);
  Destructor Destroy(); //override;
  end;

implementation

uses Unit1;

constructor TStem.CreateStem(X,Y:integer; ownerForm: TWinControl; ownSunflower: TObject; pStemSprites: TList);
var
i,j,k:integer;
r:real;
begin
//���������� X � Y ������
XStem:=X;
YStem:=Y;
self.ownerSunflower := ownSunflower;
//Sunflowerstemspr1:=2;
self.Timer := TTimer.Create(nil);
self.Timer.OnTimer:=self.TimerStemTimer;
self.Timer.Interval:=round((Random*120)+(Random*60)+1);
self.Timer.Enabled := false;
//Sunflowerstemspr1:=2;
//XSunflower:=320;
//YSunflower:=round(Random*ymax);
self.owner := ownerForm;
//MyCanvas[1]:=TImage.Create(owner);
For i := 0 to MaxImageStem - 1 Do
   begin
   //ImageMassStem[i]:=TBitMap.Create;
   //ImageMassStem[i].LoadFromFile('Stem'+IntToStr(i+1)+'.bmp');
   ImageMassStem[i] := pStemSprites.Items[i];
   ImageMassStem[i].Transparent:=True;
   ImageMassStem[i].TransparentMode:=tmFixed;
   ImageMassStem[i].TransparentColor:=clBlack;
   end;
//ImageMassStem := pStemSprites;
//��������� �������: ���� �� � ������� ����, �.�, ���� ������ ������ �����,
//���� ��������� nil
//���� �������� ������ 3, �� ����� ��������� �� ����.
i := (TSunflower(self.ownerSunflower).SunflowerStem.Count);
if i > 5 then
    begin
    j :=  i div 10;
    r := i / 10;
    if j = r then
       begin
       k := Random(100);
       if k > 50 then
          self.Leaf := TLeaf.CreateLeaf (XStem, YStem, ownerForm, self, pozLeft)
       else
          self.Leaf := TLeaf.CreateLeaf (XStem, YStem, ownerForm, self, pozRight);
       end;
    end;
end;

constructor THead.CreateHead(X: Integer; Y: Integer; ownerForm: TWinControl; ownSunflower: TObject; pHeadSprites: TList);
var
i: integer;
begin
XHead := X;
YHead := Y;
self.ownerSunflower := ownSunflower;
For i := 0 to MaxImageHead - 1 Do
   begin
   ImageMassHead[i] := TBitmap(pHeadSprites.Items[i]);
   //ImageMassHead[i]:=TBitMap.Create;
   //ImgMass[i].LoadFromFile('Stem1.bmp');
   //ImageMassHead[i].LoadFromFile('Sunflower'+IntToStr(i+1)+'.bmp');
   ImageMassHead[i].Transparent := True;
   ImageMassHead[i].TransparentMode := tmFixed;
   ImageMassHead[i].TransparentColor := clBlack;
   end;
end;

//����������� ����������
constructor TSunflower.CreateSunflower(X,Y:integer; ownerForm: TWinControl);
var
i:integer;
begin
//inherited;
//������ ��������� SunFlower �������� ������ ���� ��� �����������: THead � TStem
//��������������, ��� � ������������ �� ������ ������� ��� ��� �����������.
SunflowerLose := false;
Sunflowerstemspr1 := 1;
XSunflower := X;
YSunflower := Y;
self.Head := THead.CreateHead(self.XSunflower, self.YSunflower, Form1, self, HeadSpritesArr);
//Randomize;

//SetLength(Sunflowerstem,0);
Sunflowerstem := TList.Create;//������ TStem;

self.TimerGrown := TTimer.Create(nil);
self.TimerGrown.OnTimer := self.TimerGrownTimer;
self.TimerGrown.Interval := 1000;
end;

procedure TSunflower.TimerGrownTimer(Sender: TObject);
var
i:integer;
begin
//self.TimerGrown.Interval := Random(SunFlowersTime);
self.Grown(1);
end;

procedure TStem.TimerStemTimer(Sender: TObject);
begin

end;

//����� �������� �������� ����������
procedure TSunflower.Grown(Element:byte);
var
//len: word;
tmpStem: TStem;
tmpStemBitmap: TBitMap;
tmpHeadBitMap: TBitmap;
//����� ������
NewStem: TStem;
Xtmp, Ytmp:integer; //���������� ��������� ����� �������
begin
//������������� �������, ������� ���������, ����������� ��������� ��� ���.
//�������� ����� �������
//len := 0;
if SunFlowerLose = true then exit;
if (Sunflowerstem.Count) > 0 then
   begin
   //����� � ���������� ��������� �����
   //����� ����� �������
   //len := (Sunflowerstem.Count);
   //������������ ���� ����������
   if (Sunflowerstem.Count) > SunflowerHeightMax then
     begin
     self.Head.ShowHeadOn := 1;
     end;
   if (Sunflowerstem.Count) <= SunflowerHeightMax then
     begin
     self.Head.ShowHeadOn := 0;
     //������� ��������� ������� �������
     //�������� ��������� ����� �� ��������� ������ �������
     tmpStem := TStem(Sunflowerstem.Last);
     //������� ���������� ��������� �����
     Xtmp := tmpStem.XStem;
     //����� ���������� ���������� ������� � �������� �� ��� ������ ������� ������ �������
     Ytmp := tmpStem.YStem;
     Ytmp := Ytmp - tmpStem.ImageMassStem[0].Height;
     //����������� ���������� ������ ����������
     //��������� ���������� �������� ������ � �������� � �� ���������� �������� ������ �����
     //self.Head.XHead:=Xtmp-round(self.Head.ImageMassHead[0].Width/2)+round(tmpStem.ImageMassStem[0].Width/2);
     self.Head.YHead := Ytmp - self.Head.ImageMassHead[0].Height;
     //������ ����� ������ � ������������ ������������
     //������������ X-���������� �� ������ ������
     Xtmp := self.Head.XHead + round(self.Head.ImageMassHead[0].Width/2) - round(tmpStem.ImageMassStem[0].Width/2);

     NewStem := TStem.CreateStem(Xtmp, Ytmp, Form1, self, StemSpritesArr);
     //��������� ����� ������ � �������
     Sunflowerstem.Add(NewStem);
     //SetLength(Sunflowerstem, len + 1);
     //Sunflowerstem[len] := NewStem;
     //������� ��������� ������� �������
     //    tmpStem := TStem(Sunflowerstem[len-1]);
     end;
   end
 else
   //���� ��� �� ������ ������� � �������
   begin
   Xtmp := XSunflower;
   Ytmp := YSunflower;
   //������ ����� ������, ������� � ���� ���������� ����� �������
   NewStem := TStem.CreateStem(Xtmp, Ytmp, Form1, self, StemSpritesArr);
   //������������ X-���������� ������������ ������
   NewStem.XStem := self.Head.XHead + round(self.Head.ImageMassHead[0].Width/2) - round(NewStem.ImageMassStem[0].Width/2);
   //��������� ����� ������ � �������
   Sunflowerstem.Add(NewStem);
   //SetLength(Sunflowerstem, len+1);
   //Sunflowerstem[len] := NewStem;
//   self.Head.XHead:=Xtmp-round(self.Head.ImageMassHead[0].Width/2)+round(NewStem.ImageMassStem[0].Width/2);
   self.Head.YHead := Ytmp - self.Head.ImageMassHead[0].Height;
  end;
end;

procedure TSunflower.UnGrown(Element: byte);
var
//len: word;
tmpStem: TStem;
//���������� ������
NewStem: TStem;
Xtmp, Ytmp: integer; //���������� ���������� ����� �������
begin
//���� ������ � ���� ��������� ������
//������� ��������� ������ �� ������� � ��������� ��� ������
//len := 0;
//����� ���������� ���������� �����
if SunFlowerLose = false then
begin
if (Sunflowerstem <> nil) then
  begin
  If (Sunflowerstem.Count) > 0 then
   begin
   //����� ����� �������
   //len := (Sunflowerstem.Count);
   //������� ��������� ������� �������
   //�������� ��������� ����� �� ��������� ������ �������
   //tmpStem := TStem(Sunflowerstem.Items[len - 1]);
   tmpStem := TStem(Sunflowerstem.Last);
   if tmpStem <> nil then Freeandnil(tmpStem);
   Sunflowerstem.Delete(Sunflowerstem.Count - 1);
   if (Sunflowerstem.Count - 1) <= 0 then
     begin
     SunflowerLose := true;

     end;
   //SetLength(Sunflowerstem, len - 1);
   //len := (Sunflowerstem.Count);
   if Sunflowerstem.Count > 0 then
      begin
      tmpStem := TStem(Sunflowerstem.Last);
      if tmpStem <> nil then
        begin
        //������� ���������� ��������� �����
        //��������� ���������� �� ����� ���������, ���� ��, �� ������ ��� �������������� ������.
        Xtmp := tmpStem.XStem;
        //����� ���������� ���������� ������� � �������� �� ��� ������ ������� ������ �������
        Ytmp := tmpStem.YStem;
        Ytmp := Ytmp + tmpStem.ImageMassStem[0].Height;
        //����������� ���������� ������ ����������
        //��������� ���������� �������� ������ � �������� � �� ���������� �������� ������ �����
        if self.Head <> nil then
          begin
          //self.Head.XHead:=Xtmp-round(self.Head.ImageMassHead[0].Width/2)+round(tmpStem.ImageMassStem[0].Width/2);
          self.Head.YHead := Ytmp - self.Head.ImageMassHead[0].Height;
          end;
        end;
      end
   //������� ��������� ������� �������
//    tmpStem := TStem(Sunflowerstem[len-1]);
   else
   //���� ��� �� ������ ������� � �������
      begin
      Xtmp := XSunflower;
      Ytmp := YSunflower;
      self.Head.XHead := XSunflower;
      self.Head.YHead := YSunflower - self.Head.ImageMassHead[0].Height;
   //������ ����� ������, ������� � ���� ���������� ����� �������
        end;
      end;
     end;
   end;
end;

procedure TStem.Show;
begin
//��������� ����������� ������ ���������� � ������
//������� ���� ������ �� ����������� Canvas
VirtBitmap.Canvas.Draw(self.XStem, self.YStem, self.ImageMassStem[0]);
//���� ���� ��������� ������, �� ������������ ��
if self.Leaf<>nil then Leaf.Show;

end;

procedure THead.Show;
var
tmpStem: TStem;
tmpSunflower: TSunflower;
xtmp:integer;
begin
//��������� ����������� ������ ���������� � ������
//������� ���� ������ �� ����������� Canvas
if self.ShowHeadOn = 0 then
   begin
   VirtBitmap.Canvas.Draw(self.XHead, self.YHead, self.ImageMassHead[0]);
   end;
if self.ShowHeadOn = 1 then
   begin
   tmpSunflower := TSunflower(self.ownerSunflower);
   tmpStem := tmpSunflower.Sunflowerstem[0];
   //VirtBitmap.Canvas.Draw(round(self.XHead-self.ImageMassHead[1].Width/2), self.YHead, self.ImageMassHead[1]);
   //����� ����� ��������. ��������� ������ ������������� 29 !!!
   xtmp:=self.XHead + round(self.ImageMassHead[0].Width/2 - 65) - round(tmpStem.ImageMassStem[0].Width/2);
   VirtBitmap.Canvas.Draw(round(xtmp), self.YHead, self.ImageMassHead[1]);
   end;
end;

procedure TSunflower.Show;
var
i: byte;
begin
if self = nil then exit;
if (Sunflowerstem.Count) > 0 then
   begin
   for i := 0 to (Sunflowerstem.Count) - 1 do
      begin
   //������� ����������� ������� �������
      if Sunflowerstem[i] <> nil then
         begin
         TStem(Sunflowerstem[i]).Show;
         end;
      end;
   end;
if self.Head <> nil then
  begin
  self.Head.Show;
  If self.Head.ShowHeadOn <> 0 then
    begin
    self.ShowHeadOn := 1;
    Form1.TheVictory := true;
    end;

  end;
end;

//��������� �� ������ ����������� �� ������� ������� ���������
destructor TStem.Destroy;
var
i:byte;
begin
Timer.Enabled := False;
For i := 0 to MaxImageStem - 1 Do
   begin
   if ImageMassStem[i] <> nil then Freeandnil(ImageMassStem[i]);
   end;

{For i:=1 to  MaxImageStem Do
   begin
   if ImageMassStem[i]<>nil then ImageMassStem[i].free;
   end;}

If Self.Leaf <> nil then freeandnil(Leaf);
self.Timer.Free;
inherited;
end;

destructor THead.Destroy;
var
i:byte;
begin
For i := 0 to MaxImageHead - 1 Do
   begin
   If ImageMassHead[i] <> nil then
      begin
      ImageMassHead[i].Free;
      end;
   end;
end;

destructor TSunflower.Destroy;
var
i: byte;
tmpStem: TStem;
begin
//if Length(Sunflowerstem)>0 then
//    begin
//    for i := 0 to Length(Sunflowerstem)-1 do
//       begin
//       if TStem(Sunflowerstem[i])<>nil then TStem(Sunflowerstem[i]).Free;
//       end;
//    end;
if Sunflowerstem <> nil then
  begin
  while Sunflowerstem.Count > 0 do
    begin
    tmpStem := TStem(Sunflowerstem.Items[0]);
    FreeAndNil(tmpStem);
    Sunflowerstem.Delete(0);
    end;
  FreeAndNil(Sunflowerstem);
  end;

If self.Head <> nil then
   begin
   Head.Free;
   end;
If self.TimerGrown <> nil then
   begin
   TimerGrown.Free;
   end;
inherited;
end;

end.
