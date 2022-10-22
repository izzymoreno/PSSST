//Это модуль с полосой состояния загрузки спрайтов в процентах.

unit ULoading;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TFormLoading = class(TForm)
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLoading: TFormLoading;

implementation

{$R *.dfm}

end.
