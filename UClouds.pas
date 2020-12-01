unit UClouds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

const
//������������ �������� ������� �������
MaxClouds = 3;


type
    TCloudsDirection = (clDirLeft, clDirRight);

type
  //��������, ��� ������ ���: ���� �������, ������ ���������
  TCloudsSpritesArr = array[0..MaxClouds] of TBitMap;
  pCloudsSpritesArr = ^TCloudsSpritesArr;

type

  TCloud = class (TObject)
    owner: TWinControl;
    Name: string;
    ImgMassClouds: TList;
    XCloud, YCloud, sprindex, shagx1: integer;
    Timer: TTimer;
    ThereMove: TCloudsDirection;
    procedure Show;
    procedure TimerCloudTimer(Sender: TObject);
    Constructor CreateCloud(X, Y: integer; ownerForm: TWinControl; var pCloudsSpritesArr: TList);
    Destructor Destroy(); override;
  end;

implementation

Uses Unit1, UOwl;

constructor TCloud.CreateCloud(X,Y:integer; ownerForm: TWinControl; var pCloudsSpritesArr: TList);
var
i,k:integer;
begin
Randomize;
self.Timer:=TTimer.Create(nil);
self.Timer.OnTimer:=self.TimerCloudTimer;
self.Timer.Interval:=50;
//���������� X � Y ������
XCloud := X;
YCloud := Y;
shagx1 := 1;
self.owner := ownerForm;
ImgMassClouds := pCloudsSpritesArr;
ThereMove := clDirRight;
//�������� ������ ������
self.Timer.Enabled:=true;
end;

procedure TCloud.Show;
begin
VirtBitmap.Canvas.Draw(self.XCloud, self.YCloud, TBitMap(self.ImgMassClouds.Items[2]))//Items[self.sprindex]
end;

procedure TCloud.TimerCloudTimer;
begin
//������ ����� �����
If self.XCloud>=xmax then
   begin
   shagx1 := -1;
   ThereMove := clDirLeft;
   end;
//������ ����� ������
If self.XCloud <= xmin then
   begin
   shagx1 := 1;
   ThereMove := clDirRight;
   end;

self.XCloud:=self.XCloud+self.shagx1;

end;

//��� ���������� �������
destructor TCloud.Destroy;
var
i:byte;
begin
//������� ������
Timer.free;
//����� ����������� ������������� ������
inherited;
end;

end.
