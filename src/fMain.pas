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
/// Signature : 0cb5120e751ba251e4415ab7e20ca5530e0148dd
/// ***************************************************************************
/// </summary>

unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.generics.collections,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.ImgList,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  uCitrouilles,
  FMX.Menus,
  FMX.ScrollBox,
  System.Actions,
  FMX.ActnList,
  FMX.StdActns,
  FMX.MediaLibrary.Actions,
  dmBoutons,
  Gamolf.FMX.MusicLoop,
  FMX.Filter.Effects;

type
  TEcranEnCours = (eecAucun, eecMenu, eecJeu, eecFinJeu, eecScores, eecCredits);

  TfrmMain = class(TForm)
    zoneJeu: TLayout;
    zoneGameOver: TLayout;
    zoneMenu: TLayout;
    zoneBackground: TLayout;
    TimerCitrouilles: TTimer;
    lblScore: TLabel;
    lblNiveau: TLabel;
    lblVies: TLabel;
    lblGameOver: TLabel;
    GlowEffect1: TGlowEffect;
    GlowEffect2: TGlowEffect;
    GlowEffect3: TGlowEffect;
    ActionList1: TActionList;
    actPartage: TShowShareSheetAction;
    btnPartage: TButton;
    StyleBook1: TStyleBook;
    imgTitreMenu: TGlyph;
    imgTitreGameOver: TGlyph;
    btnRetourGameOver: TButton;
    ShadowEffect2: TShadowEffect;
    zoneGameOverScore: TLayout;
    zoneGameOverFond: TRectangle;
    ZoneMenuBoutons: TFlowLayout;
    btnJouer: TButton;
    btnBruitagesOnOff: TButton;
    btnMusiqueOnOff: TButton;
    btnHallOfFame: TButton;
    btnCredits: TButton;
    btnQuitter: TButton;
    zoneCreditsDuJeu: TLayout;
    imgTitreCreditsDuJeu: TGlyph;
    btnRetourCreditsDuJeu: TButton;
    zoneCreditsDuJeuTexte: TLayout;
    zoneCreditsDuJeuTexteBackground: TRectangle;
    VertScrollBox1: TVertScrollBox;
    lblCreditsDuJeu: TLabel;
    ShadowEffect1: TShadowEffect;
    lblCreditsDuJeuURL: TLabel;
    ShadowEffect3: TShadowEffect;
    MusicMonochromeEffect1: TMonochromeEffect;
    procedure FormCreate(Sender: TObject);
    procedure TimerCitrouillesTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnJouerClick(Sender: TObject);
    procedure btnQuitterClick(Sender: TObject);
    procedure zoneMenuResize(Sender: TObject);
    procedure zoneGameOverResize(Sender: TObject);
    procedure zoneBackgroundResize(Sender: TObject);
    procedure FormSaveState(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnPartageClick(Sender: TObject);
    procedure btnRetourGameOverClick(Sender: TObject);
    procedure ZoneMenuBoutonsResize(Sender: TObject);
    procedure btnCreditsClick(Sender: TObject);
    procedure btnMusiqueOnOffClick(Sender: TObject);
    procedure btnRetourCreditsDuJeuClick(Sender: TObject);
    procedure zoneCreditsDuJeuResize(Sender: TObject);
    procedure lblCreditsDuJeuURLClick(Sender: TObject);
  private
    { Déclarations privées }
    listeCitrouilles: TListeCitrouilles;
    EcranEnCours: TEcranEnCours;
    FMusicOnOff: boolean;
    function NouvelleCitrouille: TCitrouille;
    procedure afficheMenu;
    procedure masqueMenu;
    procedure afficheCreditsDuJeu;
    procedure masqueCreditsDuJeu;
    procedure afficheJeu;
    procedure masqueJeu;
    procedure afficheGameOver;
    procedure masqueGameOver;
    procedure afficheBackground;
    procedure masqueBackground;
    procedure LoadAndStartMusic;
    procedure SetMusicOnOff(const Value: boolean);
  public
    property MusicOnOff: boolean read FMusicOnOff write SetMusicOnOff;
    { Déclarations publiques }
    procedure ChangeScore;
    procedure ChangeNbVies;
    procedure ChangeNiveau;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.IOUtils,
  dmImages,
  System.Math,
  uScores,
  u_urlOpen,
  dmLogos,
  dmTitres,
  FMX.Platform,
  FMX.MediaLibrary;

procedure TfrmMain.afficheBackground;
begin
  listeCitrouilles.vide;
  zoneBackground.Visible := true;
  zoneBackground.BringToFront;
  TimerCitrouilles.Enabled := true;
end;

procedure TfrmMain.afficheCreditsDuJeu;
begin
  imgTitreCreditsDuJeu.images := dmAssetsTitres.imgTitres;
  masqueJeu;
  masqueGameOver;
  masqueMenu;
  afficheBackground;

  lblCreditsDuJeu.Text := 'Pumpkin Killer v1.4' + slinebreak + '(c) 2018-' +
    formatdatetime('YYYY', now) + ' Patrick Prémartin' + slinebreak +
    slinebreak;
  lblCreditsDuJeu.Text := lblCreditsDuJeu.Text +
    'Développement réalisé sous Delphi dans un projet FireMonkey.' + slinebreak
    + slinebreak;
  lblCreditsDuJeu.Text := lblCreditsDuJeu.Text +
    'Les images des citrouilles et boutons d''interface sont de Kolopach sous licence Adobe Stock (achetées chez Fotolia).'
    + slinebreak + slinebreak;
  lblCreditsDuJeu.Text := lblCreditsDuJeu.Text +
    'La musique de fond est de Bluejay Studio sous licence Jamendo.' +
    slinebreak + slinebreak;
  lblCreditsDuJeu.Text := lblCreditsDuJeu.Text +
    'Retrouvez nos informations sur';
  lblCreditsDuJeuURL.Text := 'https://pumpkinkiller.gamolf.fr';

  zoneCreditsDuJeu.Visible := true;
  zoneCreditsDuJeu.BringToFront;
  EcranEnCours := eecCredits;

  VertScrollBox1.ViewportPosition := TPointF.Create(0, 0);

{$IF Defined(iOS) or Defined(ANDROID)}
  if VertScrollBox1.Tag = 0 then
    tthread.ForceQueue(nil,
      procedure
      begin
        VertScrollBox1.Tag := 1;
        with ttext.Create(self) do
        begin
          parent := VertScrollBox1;
          Text := ' ';
          align := talignlayout.Top;
        end;
      end);
{$ENDIF}
end;

procedure TfrmMain.afficheGameOver;
begin
  imgTitreGameOver.images := dmAssetsTitres.imgTitres;
  lblGameOver.Text := 'Score : ' + score.score.tostring + slinebreak +
    'Niveau : ' + score.niveau.tostring;
  actPartage.TextMessage := 'J''ai atteint le niveau ' + score.niveau.tostring +
    ' avec le score de ' + score.score.tostring +
    ' points sur Pumpkin Killer. Feras-tu mieux que moi ? #pumpkinkiller #gamolf https://pumpkinkiller.gamolf.fr';
  masqueJeu;
  masqueMenu;
  masqueCreditsDuJeu;
  afficheBackground;
  zoneGameOver.Visible := true;
  zoneGameOver.BringToFront;
  EcranEnCours := eecFinJeu;
end;

procedure TfrmMain.afficheJeu;
begin
  masqueMenu;
  masqueGameOver;
  masqueCreditsDuJeu;
  afficheBackground;
  score.onScoreChange := ChangeScore;
  score.onNiveauChange := ChangeNiveau;
  score.onNbViesChange := ChangeNbVies;
  score.start;
  zoneJeu.Visible := true;
  zoneJeu.BringToFront;
  EcranEnCours := eecJeu;
  { TODO : ajouter une option pour mettre le jeu en pause }
end;

procedure TfrmMain.afficheMenu;
begin
  imgTitreMenu.images := dmAssetsTitres.imgTitres;
  masqueJeu;
  masqueGameOver;
  masqueCreditsDuJeu;
  afficheBackground;
  zoneMenu.Visible := true;
  zoneMenu.BringToFront;
  EcranEnCours := eecMenu;
end;

procedure TfrmMain.btnCreditsClick(Sender: TObject);
begin
  afficheCreditsDuJeu;
end;

procedure TfrmMain.btnJouerClick(Sender: TObject);
begin
  afficheJeu;
end;

procedure TfrmMain.btnMusiqueOnOffClick(Sender: TObject);
begin
  MusicOnOff := not MusicOnOff;
end;

procedure TfrmMain.btnPartageClick(Sender: TObject);
var
  img: tbitmap;
begin
  btnPartage.Visible := false;
  btnRetourGameOver.Visible := false;
  img := tbitmap.Create;
  try
    img.SetSize(width, height);
    PaintTo(img.Canvas);
    actPartage.Bitmap.Assign(img);
  finally
    btnPartage.Visible := true;
    btnRetourGameOver.Visible := true;
    freeandnil(img);
  end;
  actPartage.Execute;
end;

procedure TfrmMain.btnQuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnRetourCreditsDuJeuClick(Sender: TObject);
begin
  afficheMenu;
end;

procedure TfrmMain.btnRetourGameOverClick(Sender: TObject);
begin
  afficheMenu;
end;

procedure TfrmMain.ChangeNbVies;
begin
  lblVies.Text := 'Vies : ' + score.NbVies.tostring;
  { TODO : ajouter animation pour changement du nombre de vies }
end;

procedure TfrmMain.ChangeNiveau;
begin
  lblNiveau.Text := 'Niveau : ' + score.niveau.tostring;
  { TODO : ajouter animation pour changement du niveau }
end;

procedure TfrmMain.ChangeScore;
begin
  lblScore.Text := 'Score : ' + score.score.tostring;
  { TODO : ajouter animation pour changement du score }
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  listeCitrouilles := TListeCitrouilles.Create;
  EcranEnCours := eecAucun;
  afficheMenu;

  LoadAndStartMusic;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if assigned(listeCitrouilles) then
    freeandnil(listeCitrouilles);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key in [vkhardwareback, vkescape] then
  begin
    Key := 0;
    KeyChar := #0;
    case EcranEnCours of
      eecJeu:
        begin
          { TODO : activation de la pause }
          afficheGameOver;
        end;
      eecFinJeu, eecScores, eecCredits:
        afficheMenu;
      eecMenu:
        Close;
    else
      afficheMenu;
    end;
  end;
end;

procedure TfrmMain.FormSaveState(Sender: TObject);
begin
  { TODO : gérer la mise en veille du programme et sa réactivation }
end;

procedure TfrmMain.lblCreditsDuJeuURLClick(Sender: TObject);
begin
  if assigned(Sender) and (Sender is TLabel) then
    url_Open_In_Browser((Sender as TLabel).Text);
end;

procedure TfrmMain.LoadAndStartMusic;
var
  ml: tmusicloop;
  Nomfichier: string;
begin
  ml := MusicLoop;
{$IF defined(ANDROID)}
  // deploy in .\assets\internal\
  Nomfichier := tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
  // deploy in ;\
{$IFDEF DEBUG}
  Nomfichier := '..\..\..\_PRIVE\music';
{$ELSE}
  Nomfichier := extractfilepath(paramstr(0));
{$ENDIF}
{$ELSEIF defined(IOS)}
  // deploy in .\
  Nomfichier := extractfilepath(paramstr(0));
{$ELSEIF defined(MACOS)}
  // deploy in Contents\MacOS
  Nomfichier := extractfilepath(paramstr(0));
{$ELSEIF Defined(LINUX)}
  Nomfichier := extractfilepath(paramstr(0));
{$ELSE}
{$MESSAGE FATAL 'OS non supporté'}
{$ENDIF}
  // Nomfichier := tpath.combine(Nomfichier, '8_bit_Halloween_FiluAndDina_3.mp3');
  Nomfichier := tpath.combine(Nomfichier, 'BlueJay_Studio_8_bit_Halloween.wav');

  if not tfile.Exists(Nomfichier) then
    raise exception.Create('Can''t find the background music file.');

  ml.Load(Nomfichier);
  // TODO : paramétrer le volume sonore de la musique d'ambiance
  // TODO : gérer l'activation ou pas de la musique d'ambiance
  ml.Volume := 100;
  MusicOnOff := true;
end;

procedure TfrmMain.masqueBackground;
begin
  if zoneBackground.Visible then
  begin
    TimerCitrouilles.Enabled := false;
    listeCitrouilles.vide;
    zoneBackground.Visible := false;
  end;
end;

procedure TfrmMain.masqueCreditsDuJeu;
begin
  if zoneCreditsDuJeu.Visible then
  begin
    masqueBackground;
    zoneCreditsDuJeu.Visible := false;
  end;
end;

procedure TfrmMain.masqueGameOver;
begin
  if zoneGameOver.Visible then
  begin
    masqueBackground;
    zoneGameOver.Visible := false;
  end;
end;

procedure TfrmMain.masqueJeu;
begin
  if zoneJeu.Visible then
  begin
    masqueBackground;
    score.stop;
    zoneJeu.Visible := false;
  end;
end;

procedure TfrmMain.masqueMenu;
begin
  if zoneMenu.Visible then
  begin
    masqueBackground;
    zoneMenu.Visible := false;
  end;
end;

function TfrmMain.NouvelleCitrouille: TCitrouille;
begin
  result := TCitrouille.Create(self, zoneBackground);
end;

procedure TfrmMain.SetMusicOnOff(const Value: boolean);
begin
  FMusicOnOff := Value;

  if MusicLoop.IsActive then
    case FMusicOnOff of
      true:
        MusicLoop.Play;
      false:
        MusicLoop.Pause;
    end;

  MusicMonochromeEffect1.Enabled := (not MusicLoop.IsActive) or
    (not MusicLoop.IsPlaying) or MusicLoop.isPaused;
end;

procedure TfrmMain.TimerCitrouillesTimer(Sender: TObject);
var
  Citrouille: TCitrouille;
begin
  if not TimerCitrouilles.Enabled then
    exit;
  if not assigned(listeCitrouilles) then
    exit;

  if listeCitrouilles.Count < 1 then
    listeCitrouilles.Add(NouvelleCitrouille);
  if (random(100) < 30) and
    (listeCitrouilles.Count < listeCitrouilles.NbCitrouillesMax
    (EcranEnCours = eecJeu)) then
    listeCitrouilles.Add(NouvelleCitrouille);
  for Citrouille in listeCitrouilles do
    Citrouille.Bouge;
  if (EcranEnCours = eecJeu) and (score.NbVies < 1) then
    afficheGameOver;
end;

procedure TfrmMain.zoneBackgroundResize(Sender: TObject);
begin
  if assigned(listeCitrouilles) then
    listeCitrouilles.SetTailleMax;
end;

procedure TfrmMain.zoneCreditsDuJeuResize(Sender: TObject);
var
  largeur, hauteur: single;
  X, Y, w, h: single;
begin
  hauteur := zoneCreditsDuJeu.height / 4;
  imgTitreCreditsDuJeu.ImageIndex :=
    ifthen((zoneCreditsDuJeu.width > zoneCreditsDuJeu.height), 1, 0);
  imgTitreCreditsDuJeu.height := hauteur;
  zoneCreditsDuJeuTexte.height := hauteur * 2;
  btnRetourGameOver.Visible := true;
  largeur := zoneCreditsDuJeu.width;
  w := min(max(min(200, hauteur - 20), 44), largeur - 20);
  h := w;
  X := (largeur - w) / 2 + 10;
  Y := hauteur * 3 + (hauteur - h) / 2;
  btnRetourCreditsDuJeu.width := w;
  btnRetourCreditsDuJeu.height := h;
  btnRetourCreditsDuJeu.Position.X := X;
  btnRetourCreditsDuJeu.Position.Y := Y;
end;

procedure TfrmMain.zoneGameOverResize(Sender: TObject);
var
  largeur, hauteur: single;
  X, Y, w, h: single;
begin
  hauteur := zoneGameOver.height / 3;
  imgTitreGameOver.ImageIndex :=
    ifthen((zoneGameOver.width > zoneGameOver.height), 1, 0);
  imgTitreGameOver.height := hauteur;
  zoneGameOverScore.height := hauteur;
{$REGION 'taille et position des boutons'}
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXShareSheetActionsService) then
  begin
    btnPartage.Visible := true;
    btnRetourGameOver.Visible := true;
    largeur := zoneGameOver.width / 2;
  end
  else
  begin
    btnPartage.Visible := false;
    btnRetourGameOver.Visible := true;
    largeur := zoneGameOver.width;
  end;
  w := min(max(min(200, hauteur - 20), 44), largeur - 20);
  h := w;
  X := (largeur - w) / 2 + 10;
  Y := hauteur * 2 + (hauteur - h) / 2;
  if (btnPartage.Visible) then
  begin
    btnPartage.width := w;
    btnPartage.height := h;
    btnPartage.Position.X := X;
    btnPartage.Position.Y := Y;
    X := X + largeur;
  end;
  if (btnRetourGameOver.Visible) then
  begin
    btnRetourGameOver.width := w;
    btnRetourGameOver.height := h;
    btnRetourGameOver.Position.X := X;
    btnRetourGameOver.Position.Y := Y;
    // X := X + largeur;
  end;
{$ENDREGION}
end;

procedure TfrmMain.ZoneMenuBoutonsResize(Sender: TObject);
const
  CSizeMin = 48; // minimum pixel size for a clicable element
  CSizeMax = 200;
  CMarge = 24;
var
  // nbButtons: integer;
  i: integer;
  Taille: single;
  Marge: single;
begin
  btnMusiqueOnOff.Visible := true;
  btnBruitagesOnOff.Visible := false;
  { TODO : gérer le bouton de réglage du son }
  btnCredits.Visible := true;
  btnHallOfFame.Visible := false;
  { TODO : gérer le bouton d'affichage de l'écran du tableau des scores }
{$IF defined(ANDROID) or defined(IOS)}
  btnJouer.Visible := true;
  btnQuitter.Visible := false;
{$ELSE}
  btnJouer.Visible := true;
  btnQuitter.Visible := true;
{$ENDIF}
  // nbButtons := 0;
  // for i := 0 to ZoneMenuBoutons.ChildrenCount - 1 do
  // if (ZoneMenuBoutons.Children[i] is TButton) and
  // (ZoneMenuBoutons.Children[i] as TButton).Visible then
  // inc(nbButtons);

  // nbButtons := (nbButtons div 2) + (nbButtons mod 2);

  Marge := CMarge;

  if (ZoneMenuBoutons.width > ZoneMenuBoutons.height) then
    Taille := ZoneMenuBoutons.height / 2
  else
    Taille := ZoneMenuBoutons.width / 2;
  Taille := min(Taille - Marge * 2, CSizeMax);

  if Taille < CSizeMin then
  begin
    Marge := Marge - (CSizeMin - Taille) / 2;
    Taille := CSizeMin;
  end;

  // while ((Taille > CSizeMin) and ((Taille + Marge) * nbButtons * 2 >
  // ZoneMenuBoutons.width + ZoneMenuBoutons.height)) do
  // dec(Taille);

  for i := 0 to ZoneMenuBoutons.ChildrenCount - 1 do
    if (ZoneMenuBoutons.Children[i] is TButton) and
      (ZoneMenuBoutons.Children[i] as TButton).Visible then
      with ZoneMenuBoutons.Children[i] as TButton do
      begin
        width := Taille;
        height := Taille;
        margins.Top := Marge;
        margins.Bottom := Marge;
        margins.Left := Marge;
        margins.Right := Marge;
      end;
end;

procedure TfrmMain.zoneMenuResize(Sender: TObject);
begin
  imgTitreMenu.ImageIndex := ifthen((zoneMenu.width > zoneMenu.height), 1, 0);
  imgTitreMenu.height := zoneMenu.height / 3;
end;

initialization

{$IFDEF DEBUG}
  reportmemoryleaksonshutdown := true;
{$ENDIF}
randomize;

end.
