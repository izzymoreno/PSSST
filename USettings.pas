unit USettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, ExtCtrls, UTableHitScore;

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
    procedure FormCreate(Sender: TObject);
    PROCEDURE WndProc(var Msg: TMessage); override;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrackBarWormsChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrackBarFlyesChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  var
  TableHitScore: TFormTableScore;

implementation

uses
Unit1;
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
  Form1.InitLevel;
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
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
//btnConnect.Click;
end;

procedure TSettingsForm.TrackBarFlyesChange(Sender: TObject);
begin
EditFlyes.Text := inttostr(self.TrackBarFlyes.Position);
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
