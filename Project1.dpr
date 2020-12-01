program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  USunflower in 'USunflower.pas',
  UFlyes in 'UFlyes.pas',
  UWorms in 'UWorms.pas',
  ULeaf in 'ULeaf.pas',
  UOwl in 'UOwl.pas',
  UBullets in 'UBullets.pas',
  uConstant in 'uConstant.pas',
  UWeapon in 'UWeapon.pas',
  UBrick in 'UBrick.pas',
  UTableHitScore in 'UTableHitScore.pas' {Form2},
  UClouds in 'UClouds.pas';
//  Unit3 in 'Unit3.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
//  Application.CreateForm(TForm3, Form3);
  //  Application.CreateForm(TFormTableScore, FormTableScore);
  Application.Run;
end.
