unit UTableHitScore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls;

Const
MAX_Count = 4;

type
  TFormTableScore = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
 end;

var
  FormTableScore: TFormTableScore;
  Rect: TRect;
  WidthImage,HeightImage: integer;
  ACol, ARow: byte;
  StrList: TStringList;

implementation

{$R *.dfm}

procedure TFormTableScore.FormCreate(Sender: TObject);
var
i: integer;
begin
StrList:=TStringList.Create;

for i := 0 to MAX_Count do
  begin
  Self.StringGrid1.Cells[i+1,2]:=IntToStr(0);
  Self.StringGrid1.Cells[i+1,3]:=IntToStr(0);
  Self.StringGrid1.Cells[i+1,4]:=IntToStr(0);
  Self.StringGrid1.Cells[0,0]:='X';
  Self.StringGrid1.Cells[1,0]:='Черви';
  Self.StringGrid1.Cells[2,0]:='Мухи';
  Self.StringGrid1.Cells[2,1]:='';//+IntToStr();
  Self.StringGrid1.Cells[3,1]:='';// IntToStr( Self. );//EditPlayerName.Text
  end;
ACol := 1;
ARow := 1;
//FormTableScore.Image1.Create(FormTableScore);
//FormTableScore.Image1.Picture.LoadFromFile('RWorm1.bmp');
{Rect.Left := FormTableScore.StringGrid1.Left;
Rect.Top := FormTableScore.StringGrid1.Top;
Rect.Right := Rect.Left + FormTableScore.Image1.Width;
Rect.Bottom := Rect.Top + FormTableScore.Image1.Height;
FormTableScore.StringGrid1.Canvas.StretchDraw(Rect, FormTableScore.Image1.Picture.Graphic);
//FormTableScore.StringGrid1.Canvas( 1,1, FormTableScore.Image1.Picture.Graphic);}
end;

procedure TFormTableScore.FormDestroy(Sender: TObject);
begin
FormTableScore.StringGrid1.Destroy;
FormTableScore.Image1.Destroy;
FormTableScore.Image2.Destroy;
StrList.Destroy;
end;

procedure TFormTableScore.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
if (ACol = 1) and (ARow=1) then //Условие ACol*ARow=1 тождественно (ACol=1)and(ARow=1)
  StringGrid1.Canvas.StretchDraw(Rect, Image1.Picture.Graphic);
if (ACol = 2) and (ARow = 1) then //Условие ACol*ARow=1 тождественно (ACol=1)and(ARow=1)
  StringGrid1.Canvas.StretchDraw(Rect, Image2.Picture.Graphic);
end;

end.
