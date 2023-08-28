program PumpkinKiller;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  dmImages in '..\_PRIVE\src\dmImages.pas' {dmAssets: TDataModule},
  uScores in 'uScores.pas',
  uCitrouilles in 'uCitrouilles.pas',
  dmBoutons in '..\_PRIVE\src\dmBoutons.pas' {dmAssetsBoutons: TDataModule},
  dmLogos in '..\_PRIVE\src\dmLogos.pas' {dmAssetsLogos: TDataModule},
  dmTitres in '..\_PRIVE\src\dmTitres.pas' {dmAssetsTitres: TDataModule},
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmAssets, dmAssets);
  Application.CreateForm(TdmAssetsTitres, dmAssetsTitres);
  Application.CreateForm(TdmAssetsBoutons, dmAssetsBoutons);
  Application.CreateForm(TdmAssetsLogos, dmAssetsLogos);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

