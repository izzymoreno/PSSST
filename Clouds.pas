unit Clouds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

const
//������������ �������� ������� �������
MaxClouds = 1;


type
    TCloudsDirection = (clDirLeft, clDirRight);

type
  //��������, ��� ������ ���: ���� �������, ������ ���������
  TCloudsSpritesArr = array[0..MaxClouds] of TBitMap;
  pCloudsSpritesArr = ^TCloudsSpritesArr;

type

  TCloud = class (TObject)
    Name: string;
    ImgMassClouds: TList;
    XCloud, YCloud: integer;
    procedure Show;
    procedure TimerCloudsProcessing(Sender: TObject);
    Constructor CreateCloud(X, Y: integer; ownerForm: TWinControl; var pCloudsSpritesArr);
    Destructor Destroy(); override;
  end;

implementation

Uses Unit1, UOwl;

constructor TCloud.CreateCloud(X,Y:integer; ownerForm: TWinControl; var pCloudsSpritesArr);
var
i,k:integer;
begin
//���������� X � Y ������� ������������
XCloud := X;
YCloud := Y;
self.owner:=ownerForm;
ImgMassClouds := pCloudsSpritesArr;
//ImgMassClouds := pCloudsSpritesArr;

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

end.
