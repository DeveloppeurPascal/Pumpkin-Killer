/// <summary>
/// ***************************************************************************
///
/// Pumpkin Killer
///
/// Copyright 2018-2024 Patrick Prémartin under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://pumpkinkiller.gamolf.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Pumpkin-Killer
///
/// ***************************************************************************
/// File last update : 2024-09-19T19:09:44.225+02:00
/// Signature : 3cb4ecfc690a36d46cc6d202f93514c116022f4f
/// ***************************************************************************
/// </summary>

unit uCitrouilles;

interface

uses system.classes, system.generics.collections, fmx.types, fmx.controls,
  fmx.imglist, fmx.ani, system.UITypes;

type
  TCitrouille = class;

  TCitrouille = class(tglyph)
  private
    FVx, FVy: single;
    FZoneParente: TControl;
    FClicAnimation: TFloatAnimation;
    FNbRebonds: integer;
    FSensInverse: boolean;
  public
    constructor Create(AOwner: TComponent; AParent: TFmxObject); overload;
    procedure SetTailleMax;
    procedure Bouge;
    procedure Initialise;
    procedure ClicTrouille;
    procedure ClicTrouilleFin(Sender: TObject);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: single);
  end;

  TListeCitrouilles = class(tlist<TCitrouille>)
  public
    procedure SetTailleMax;
    function NbCitrouillesMax(JeuEnCours: boolean = false): byte;
    procedure vide;
  end;

implementation

uses system.math, system.SysUtils, uScores, dmImages;

const
  _NbCitrouillesMax = 10;

  { TCitrouille }

procedure TCitrouille.Bouge;
begin
  Position.X := Position.X + FVx;
  Position.Y := Position.Y + FVy;
  if (Position.X + width < 0) or (Position.Y + height < 0) or
    (Position.X > FZoneParente.width) or (Position.Y > FZoneParente.height) then
  begin
    if (images = dmAssets.imgJoyouilles) then
    begin
      score.score := score.score + (imageindex + 1) * score.Niveau;
      Initialise;
    end
    else if (FNbRebonds < 10) then
    begin
      { TODO : déclencher un son de rebond }
      inc(FNbRebonds);
      FSensInverse := not FSensInverse;
      if (FSensInverse) then
        FVx := -FVx
      else
        FVy := -FVy;
    end
    else
    begin
      score.NbVies := score.NbVies - 1;
      Initialise;
    end;
  end;
end;

procedure TCitrouille.ClicTrouille;
begin
  if not assigned(FClicAnimation) then
  begin
    FClicAnimation := TFloatAnimation.Create(self);
    FClicAnimation.Parent := self;
    FClicAnimation.PropertyName := 'width';
    FClicAnimation.StartFromCurrent := true;
    FClicAnimation.OnFinish := ClicTrouilleFin;
  end;
  if not FClicAnimation.Enabled then
  begin
    { TODO : déclencher un son d'explosion }
    FClicAnimation.tag := 1;
    FClicAnimation.Duration := 0.2;
    FClicAnimation.StopValue := width * 2;
    height := height * 2;
    FClicAnimation.Enabled := true;
  end;
end;

procedure TCitrouille.ClicTrouilleFin(Sender: TObject);
begin
  FClicAnimation.Enabled := false;
  if (FClicAnimation.tag = 1) then
  begin
    FClicAnimation.tag := 2;
    FClicAnimation.Duration := 0.3;
    FClicAnimation.StopValue := 0;
    FClicAnimation.Enabled := true;
  end
  else
  begin
    if images = dmAssets.imgTristouilles then
      score.score := score.score + (imageindex + 1) * score.Niveau
    else
      score.NbVies := score.NbVies - 1;
    Initialise;
  end;
end;

constructor TCitrouille.Create(AOwner: TComponent; AParent: TFmxObject);
begin
  inherited Create(AOwner);
  Parent := AParent;
  FZoneParente := TControl(AParent);
  FClicAnimation := nil;
  HitTest := false;
  Initialise;
end;

procedure TCitrouille.Initialise;
var
  Largeur, hauteur, Echelle: single;
begin
  { TODO : gérer les citrouilles payantes si paiement inApp effectué }
  // par défaut 5 de chaque, après inApp 12 tristouilles de plus et 10 joyouilles de plus
  if random(100) < 80 then
    images := dmAssets.imgTristouilles
  else
    images := dmAssets.imgJoyouilles;
  imageindex := random(images.Count);
  FNbRebonds := 0;
  FSensInverse := false;
  Largeur := images.destination.Items[imageindex].Layers[0].SourceRect.width;
  hauteur := images.destination.Items[imageindex].Layers[0].SourceRect.height;
  Stretch := true;
  Echelle := 0.5 + (random(200) / 100);
  width := Largeur * Echelle;
  height := hauteur * Echelle;
  SetTailleMax;
  repeat
    FVx := random(11) - 5;
    FVy := random(11) - 5;
  until (FVx <> 0) and (FVy <> 0);
  case random(3) of
    0:
      begin
        Position.X := -width;
        if FVx < 0 then
          FVx := 1;
      end;
    1:
      Position.X := random(trunc(FZoneParente.width));
    2:
      begin
        Position.X := FZoneParente.width;
        if FVx > 0 then
          FVx := -1;
      end;
  end;
  case random(3) of
    0:
      begin
        Position.Y := -height;
        if FVy < 0 then
          FVy := 1;
      end;
    1:
      Position.Y := random(trunc(FZoneParente.height));
    2:
      begin
        Position.Y := FZoneParente.height;
        if FVy > 0 then
          FVy := -1;
      end;
  end;
  if (Position.X >= 0) and (Position.X < FZoneParente.width) and
    (Position.Y >= 0) and (Position.Y < FZoneParente.height) then
  begin
    Position.X := -width;
    if FVx < 0 then
      FVx := 1;
  end;

  // Gestion locale du clic
  HitTest := true;
  OnMouseDown := MouseDown;
end;

procedure TCitrouille.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: single);
begin
  HitTest := false;
  ClicTrouille;
end;

procedure TCitrouille.SetTailleMax;
var
  LargeurMax, HauteurMax: single;
  LargeurMin, HauteurMin: single;
begin
  LargeurMin := 44;
  LargeurMax := FZoneParente.width / 5;
  HauteurMin := 44;
  HauteurMax := FZoneParente.height / 5;
  if width > LargeurMax then
  begin
    height := height * LargeurMax / width;
    width := LargeurMax;
  end;
  if height > HauteurMax then
  begin
    width := width * HauteurMax / height;
    height := HauteurMax;
  end;
  if width < LargeurMin then
  begin
    height := height * LargeurMin / width;
    width := LargeurMin;
  end;
  if height < HauteurMin then
  begin
    width := width * HauteurMin / height;
    height := HauteurMin;
  end;
end;

{ TListeCitrouilles }

function TListeCitrouilles.NbCitrouillesMax(JeuEnCours: boolean): byte;
begin
  if JeuEnCours then
    result := min(score.Niveau, _NbCitrouillesMax)
  else
    result := _NbCitrouillesMax;
end;

procedure TListeCitrouilles.SetTailleMax;
var
  Citrouille: TCitrouille;
begin
  for Citrouille in self do
    Citrouille.SetTailleMax;
end;

procedure TListeCitrouilles.vide;
var
  Citrouille: TCitrouille;
begin
  while Count > 0 do
  begin
    Citrouille := Items[0];
    Delete(0);
{$IF defined(ANDROID) or defined(IOS)}
    // obligatoire car les images ne sont pas effacées du background
    // sans doute un effet de bord de ARC
    // (10.2.3 Tokyo, à tester plus tard)
    Citrouille.Parent := nil;
{$ENDIF}
    freeandnil(Citrouille);
  end;
  Clear;
end;

end.
