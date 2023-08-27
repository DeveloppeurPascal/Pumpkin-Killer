unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.generics.collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.Effects, uCitrouilles, FMX.Menus, FMX.ScrollBox, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, dmBoutons;

type
  TEcranEnCours = (eecAucun, eecMenu, eecJeu, eecFinJeu, eecScores);

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
    btnJouer: TButton;
    btnQuitter: TButton;
    btnMusiqueOnOff: TButton;
    btnBruitagesOnOff: TButton;
    btnCredits: TButton;
    btnHallOfFame: TButton;
    StyleBook1: TStyleBook;
    btnOlfSoftware: TButton;
    btnGamolf: TButton;
    btnDeveloppeurPascal: TButton;
    btnDelphi: TButton;
    imgTitreMenu: TGlyph;
    imgTitreGameOver: TGlyph;
    btnRetourGameOver: TButton;
    ShadowEffect2: TShadowEffect;
    zoneGameOverScore: TLayout;
    zoneGameOverFond: TRectangle;
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
    procedure btnDelphiClick(Sender: TObject);
    procedure btnDeveloppeurPascalClick(Sender: TObject);
    procedure btnGamolfClick(Sender: TObject);
    procedure btnOlfSoftwareClick(Sender: TObject);
    procedure btnRetourGameOverClick(Sender: TObject);
  private
    { Déclarations privées }
    listeCitrouilles: TListeCitrouilles;
    EcranEnCours: TEcranEnCours;
    function NouvelleCitrouille: TCitrouille;
    procedure afficheMenu;
    procedure masqueMenu;
    procedure afficheJeu;
    procedure masqueJeu;
    procedure afficheGameOver;
    procedure masqueGameOver;
    procedure afficheBackground;
    procedure masqueBackground;
  public
    { Déclarations publiques }
    procedure ChangeScore;
    procedure ChangeNbVies;
    procedure ChangeNiveau;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses dmImages, System.Math, uScores, u_urlOpen, dmLogos, dmTitres, FMX.Platform,
  FMX.MediaLibrary;

procedure TfrmMain.afficheBackground;
begin
  listeCitrouilles.vide;
  zoneBackground.Visible := true;
  zoneBackground.BringToFront;
  TimerCitrouilles.Enabled := true;
end;

procedure TfrmMain.afficheGameOver;
begin
  imgTitreGameOver.images := dmAssetsTitres.imgTitres;
  lblGameOver.Text := 'Score : ' + score.score.ToString + #13#10 + 'Niveau : ' +
    score.niveau.ToString;
  actPartage.TextMessage := 'J''ai atteint le niveau ' + score.niveau.ToString +
    ' avec le score de ' + score.score.ToString +
    ' points sur Pumpkin Killer. Feras-tu mieux que moi ? #pumpkinkiller #gamolf https://pumpkinkiller.gamolf.fr';
  masqueJeu;
  masqueMenu;
  afficheBackground;
  zoneGameOver.Visible := true;
  zoneGameOver.BringToFront;
  EcranEnCours := eecFinJeu;
end;

procedure TfrmMain.afficheJeu;
begin
  masqueMenu;
  masqueGameOver;
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
  btnDeveloppeurPascal.images := dmAssetsLogos.imgLogos;
  btnDeveloppeurPascal.ImageIndex := 3;
  btnOlfSoftware.images := dmAssetsLogos.imgLogos;
  btnOlfSoftware.ImageIndex := 2;
  btnDelphi.images := dmAssetsLogos.imgLogos;
  btnDelphi.ImageIndex := 0;
  btnGamolf.images := dmAssetsLogos.imgLogos;
  btnGamolf.ImageIndex := 1;
  masqueJeu;
  masqueGameOver;
  afficheBackground;
  zoneMenu.Visible := true;
  zoneMenu.BringToFront;
  EcranEnCours := eecMenu;
end;

procedure TfrmMain.btnJouerClick(Sender: TObject);
begin
  afficheJeu;
end;

procedure TfrmMain.btnOlfSoftwareClick(Sender: TObject);
begin
  url_Open_In_Browser('https://olfsoftware.fr');
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

procedure TfrmMain.btnRetourGameOverClick(Sender: TObject);
begin
  afficheMenu;
end;

procedure TfrmMain.btnDelphiClick(Sender: TObject);
begin
  url_Open_In_Browser('https://www.embarcadero.com/fr/products/delphi');
end;

procedure TfrmMain.btnDeveloppeurPascalClick(Sender: TObject);
begin
  url_Open_In_Browser('https://developpeur-pascal.fr/pumpkin-killer.html');
end;

procedure TfrmMain.btnGamolfClick(Sender: TObject);
begin
  url_Open_In_Browser('https://gamolf.fr');
end;

procedure TfrmMain.ChangeNbVies;
begin
  lblVies.Text := 'Vies : ' + score.NbVies.ToString;
  { TODO : ajouter animation pour changement du nombre de vies }
end;

procedure TfrmMain.ChangeNiveau;
begin
  lblNiveau.Text := 'Niveau : ' + score.niveau.ToString;
  { TODO : ajouter animation pour changement du niveau }
end;

procedure TfrmMain.ChangeScore;
begin
  lblScore.Text := 'Score : ' + score.score.ToString;
  { TODO : ajouter animation pour changement du score }
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  listeCitrouilles := TListeCitrouilles.Create;
  EcranEnCours := eecAucun;
  afficheMenu;
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
      eecFinJeu:
        afficheMenu;
      eecScores:
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

procedure TfrmMain.masqueBackground;
begin
  if zoneBackground.Visible then
  begin
    TimerCitrouilles.Enabled := false;
    listeCitrouilles.vide;
    zoneBackground.Visible := false;
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

procedure TfrmMain.TimerCitrouillesTimer(Sender: TObject);
var
  Citrouille: TCitrouille;
begin
  if TimerCitrouilles.Enabled then
  begin
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
end;

procedure TfrmMain.zoneBackgroundResize(Sender: TObject);
begin
  if assigned(listeCitrouilles) then
    listeCitrouilles.SetTailleMax;
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

procedure TfrmMain.zoneMenuResize(Sender: TObject);
var
  largeur, hauteur: single;
  X, Y, w, h: single;
begin
  hauteur := zoneMenu.height / 3;
  imgTitreMenu.ImageIndex := ifthen((zoneMenu.width > zoneMenu.height), 1, 0);
  imgTitreMenu.height := hauteur;
{$REGION 'gestion des boutons de menus'}
  btnMusiqueOnOff.Visible := false;
  { TODO : gérer le bouton de réglage de la musique }
  btnBruitagesOnOff.Visible := false;
  { TODO : gérer le bouton de réglage du son }
  btnCredits.Visible := false;
  { TODO : gérer le bouton d'affichage de l'écran de crédits }
  btnHallOfFame.Visible := false;
  { TODO : gérer le bouton d'affichage de l'écran du tableau des scores }
{$IF defined(ANDROID) or defined(IOS)}
  btnJouer.Visible := true;
  btnQuitter.Visible := false;
  largeur := zoneMenu.width;
{$ELSE}
  btnJouer.Visible := true;
  btnQuitter.Visible := true;
  largeur := zoneMenu.width / 2;
{$ENDIF}
  w := min(max(min(200, hauteur - 20), 44), largeur - 20);
  h := w;
  X := (largeur - w) / 2 + 10;
  Y := hauteur + 10;
  if (btnJouer.Visible) then
  begin
    btnJouer.width := w;
    btnJouer.height := h;
    btnJouer.Position.X := X;
    btnJouer.Position.Y := Y;
    X := X + largeur;
  end;
  if (btnQuitter.Visible) then
  begin
    btnQuitter.width := w;
    btnQuitter.height := h;
    btnQuitter.Position.X := X;
    btnQuitter.Position.Y := Y;
    // X := X + largeur;
  end;
{$ENDREGION}
{$REGION 'gestion des boutons de sites web'}
  largeur := zoneMenu.width / 4;
  w := min(max(min(100, hauteur - 20), 44), largeur - 20);
  h := w;
  X := (largeur - w) / 2 + 10;
  Y := zoneMenu.height - 10 - w;
  btnOlfSoftware.width := w;
  btnOlfSoftware.height := h;
  btnOlfSoftware.Position.X := X;
  btnOlfSoftware.Position.Y := Y;
  X := X + largeur;
  btnDeveloppeurPascal.width := w;
  btnDeveloppeurPascal.height := h;
  btnDeveloppeurPascal.Position.X := X;
  btnDeveloppeurPascal.Position.Y := Y;
  X := X + largeur;
  btnDelphi.width := w;
  btnDelphi.height := h;
  btnDelphi.Position.X := X;
  btnDelphi.Position.Y := Y;
  X := X + largeur;
  btnGamolf.width := w;
  btnGamolf.height := h;
  btnGamolf.Position.X := X;
  btnGamolf.Position.Y := Y;
{$ENDREGION}
end;

initialization

{$IFDEF DEBUG}
  reportmemoryleaksonshutdown := true;
{$ENDIF}
randomize;

end.
