unit USettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, ExtCtrls, UTableHitScore, jpeg;

const WM_CLOSE_MODAL = WM_USER + 1;

type
  TSettingsForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    TrackBarWorms: TTrackBar;
    TrackBarFlyes: TTrackBar;
    EditPlayerName: TEdit;
    EditWorms: TEdit;
    EditFlyes: TEdit;
    Button1: TButton;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button3: TButton;
    Label6: TLabel;
    EditRegisterKey: TEdit;
    RegisterIt: TButton;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    TrackBarLevels: TTrackBar;
    Label8: TLabel;
    EditLevels: TEdit;
    Label9: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    PROCEDURE WndProc(var Msg: TMessage); override;
    procedure Button1Click(Sender: TObject);
    procedure TrackBarWormsChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrackBarFlyesChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RegisterItClick(Sender: TObject);
    procedure TrackBarLevelsChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  var
  TableHitScore: TFormTableScore;

implementation

uses
Unit1, UOwl;
{$R *.dfm}

PROCEDURE TSettingsForm.WndProc(var Msg: TMessage);
begin
  inherited;
  if Msg.Msg = WM_CLOSE_MODAL then
    begin
    //временно нам надо чтобы окно с паролем самостоятельно отвечало на вопрос.
    SettingsForm.ModalResult := mrOk;
    //LoginForm.Close;
    end;
end;

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  self.Visible := false;
  postmessage(self.Handle, WM_CLOSE_MODAL, 0, 0);
  SettingsForm.ModalResult := mrOk;
  Form1.DestroyLevel;
  Form1.InitLevel();
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
FormTableScore.Destroy;
self.Visible := false;
SettingsForm.ModalResult := mrClose;
Application.Terminate;
end;

procedure TSettingsForm.Button3Click(Sender: TObject);
begin
FormTableScore.FormCreate(Application);
FormTableScore.Visible := True;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
//
FormTableScore := TFormTableScore.Create(Application);
self.TrackBarWorms.Min := 1;
self.TrackBarFlyes.Min := 1;
self.TrackBarLevels.Min := 1;
self.RadioGroup1.Enabled := False;
self.EditPlayerName.Enabled := False;
self.EditWorms.Enabled := False;
self.EditFlyes.Enabled := False;
self.EditLevels.Enabled := False;
self.TrackBarLevels.Enabled := False;
self.TrackBarWorms.Enabled := False;
self.TrackBarFlyes.Enabled := False;
self.Button1.Enabled := False;
self.Button2.Enabled := False;
self.Button3.Enabled := False;
self.CheckBox1.Enabled := False;

end;

procedure TSettingsForm.RegisterItClick(Sender: TObject);
begin
if (self.EditRegisterKey.Text = 'xUSSR') or (self.EditRegisterKey.Text = 'СССР') then
   begin
   self.RadioGroup1.Enabled := True;
   self.EditPlayerName.Enabled := True;
   self.EditWorms.Enabled := True;
   self.EditFlyes.Enabled := True;
   self.TrackBarWorms.Enabled := True;
   self.TrackBarFlyes.Enabled := True;
   self.EditLevels.Enabled := True;
   self.TrackBarLevels.Enabled := True;
   self.Button1.Enabled := True;
   self.Button2.Enabled := True;
   self.Button3.Enabled := True;
   self.CheckBox1.Enabled := True;

   end;
end;

procedure TSettingsForm.TrackBarFlyesChange(Sender: TObject);
begin
EditFlyes.Text := inttostr(self.TrackBarFlyes.Position);
end;

procedure TSettingsForm.TrackBarLevelsChange(Sender: TObject);
begin
EditLevels.Text := inttostr(self.TrackBarLevels.Position);
{if self.TrackBarLevels = 1 then ImageMenu1.Picture.LoadFromFile('RWorm1.bmp');
if self.TrackBarLevels = 1 then ImageMenu1.Picture.LoadFromFile('RFly1.bmp');
if self.TrackBarLevels = 1 then ImageMenu1.Picture.LoadFromFile('RWorm1&RFly1.bmp');}
end;

procedure TSettingsForm.TrackBarWormsChange(Sender: TObject);
begin
EditWorms.Text := inttostr(self.TrackBarWorms.Position);
end;

{**
The connection is made here.
You can see how the connection string is generated and how to connect to the database.
}

end.
