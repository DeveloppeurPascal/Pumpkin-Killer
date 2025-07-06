(* C2PP
  ***************************************************************************

  Pumpkin Killer

  Copyright 2018-2025 Patrick Prémartin under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://pumpkinkiller.gamolf.fr/

  Project site :
  https://github.com/DeveloppeurPascal/Pumpkin-Killer

  ***************************************************************************
  File last update : 2025-07-03T10:44:32.077+02:00
  Signature : 81d1916f77e692f67d7d290f4a6a63465a7e9c80
  ***************************************************************************
*)

unit uScores;

interface

uses system.classes;

type
  TScoresMethod = procedure of object;
  TScoresValue = cardinal;

  TScores = class(tobject)
  private
    FScore: TScoresValue;
    FNbVies: TScoresValue;
    FNiveau: TScoresValue;
    FScoreNiveauSuivant: TScoresValue;
    FonScoreChange: TScoresMethod;
    FonNbViesChange: TScoresMethod;
    FonNiveauChange: TScoresMethod;
    procedure SetNbVies(const Value: TScoresValue);
    procedure SetNiveau(const Value: TScoresValue);
    procedure SetScore(const Value: TScoresValue);
    procedure SetonNbViesChange(const Value: TScoresMethod);
    procedure SetonNiveauChange(const Value: TScoresMethod);
    procedure SetonScoreChange(const Value: TScoresMethod);
  public
    property NbVies: TScoresValue read FNbVies write SetNbVies;
    property Niveau: TScoresValue read FNiveau write SetNiveau;
    property Score: TScoresValue read FScore write SetScore;
    property onScoreChange: TScoresMethod read FonScoreChange
      write SetonScoreChange;
    property onNiveauChange: TScoresMethod read FonNiveauChange
      write SetonNiveauChange;
    property onNbViesChange: TScoresMethod read FonNbViesChange
      write SetonNbViesChange;
    procedure start;
    procedure stop;
    constructor create;
  end;

var
  Score: TScores;

implementation

uses system.sysutils;
{ TScores }

procedure TScores.start;
begin
  SetScore(0);
  SetNbVies(3);
  SetNiveau(1);
  FScoreNiveauSuivant := 100;
end;

procedure TScores.stop;
begin
  FNiveau := 0;
  onScoreChange := nil;
  onNiveauChange := nil;
  onNbViesChange := nil;
end;

constructor TScores.create;
begin
  inherited;
  FNiveau := 0;
  FNbVies := 0;
  FScore := 0;
end;

procedure TScores.SetNbVies(const Value: TScoresValue);
begin
  FNbVies := Value;
  if assigned(onNbViesChange) then
    onNbViesChange;
end;

procedure TScores.SetNiveau(const Value: TScoresValue);
begin
  FNiveau := Value;
  if assigned(onNiveauChange) then
    onNiveauChange;
end;

procedure TScores.SetonNbViesChange(const Value: TScoresMethod);
begin
  FonNbViesChange := Value;
end;

procedure TScores.SetonNiveauChange(const Value: TScoresMethod);
begin
  FonNiveauChange := Value;
end;

procedure TScores.SetonScoreChange(const Value: TScoresMethod);
begin
  FonScoreChange := Value;
end;

procedure TScores.SetScore(const Value: TScoresValue);
begin
  FScore := Value;
  if assigned(onScoreChange) then
    onScoreChange;
  if (FNiveau > 0) and (FScore > FScoreNiveauSuivant) then
  begin
    Niveau := Niveau + 1;
    NbVies := NbVies + 1;
    FScoreNiveauSuivant := FScoreNiveauSuivant * 2;
    { TODO : revoir calcul des scores permettant de changer de palier }
  end;
end;

initialization

Score := TScores.create;

finalization

if assigned(Score) then
  freeandnil(Score);

end.
