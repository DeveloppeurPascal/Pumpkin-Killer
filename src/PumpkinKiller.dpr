﻿/// <summary>
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
/// File last update : 2024-09-19T19:15:36.000+02:00
/// Signature : b66903a4e852777e54f00728bb5a493ee707a54e
/// ***************************************************************************
/// </summary>

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
  Gamolf.FMX.MusicLoop in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  u_urlOpen in '..\lib-externes\librairies\src\u_urlOpen.pas';

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

