<?php
session_start();
require_once("../../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once(INSTALL_DIR."/inc/classes/classEcole.inc.php");
$Ecole = new Ecole();

require_once(INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php");
$Bulletin = new Bulletin();

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");

$page = isset($_POST['page'])?$_POST['page']:Null;
$titre = isset($_POST['titre'])?$_POST['titre']:'';
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$tri = isset($_POST['tri'])?$_POST['tri']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:Null;
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$nomProf =  isset($_POST['nomProf'])?$_POST['nomProf']:Null;
$module = isset($_POST['module'])?$_POST['module']:Null;

require_once('../../../smarty/Smarty.class.php');
$smarty = new Smarty;

$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
$listeTravaux = $Bulletin->listeTravaux($coursGrp,$bulletin);
$listeCotes = ($listeTravaux != Null)?$Bulletin->listeCotesCarnet($listeTravaux):Null;
$listeMoyennes = $Bulletin->listeMoyennesCarnet($listeCotes);
$listeCompetences = current($Bulletin->listeCompetences($coursGrp));

$smarty->assign('listeCotes', $listeCotes);
$smarty->assign('listeMoyennes', $listeMoyennes);
$smarty->assign('listeCompetences', $listeCompetences);
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('listeTravaux',$listeTravaux);
$smarty->assign('listeEleves',$listeEleves);
$smarty->assign('nomProf',$nomProf);

$carnet4PDF =  $smarty->fetch('../../templates/simpleShowCarnet.tpl');

if (isset($page)) {
    $page = $carnet4PDF;
    $html2pdf = new HTML2PDF('L','A4','fr');

    $html2pdf->WriteHTML($page);
    $nomFichier = $coursGrp."_".$bulletin.".pdf";
    // création éventuelle du répertoire au nom de l'utlilisateur
    $chemin = INSTALL_DIR."/$module/carnet/$acronyme/";
    if (!(file_exists($chemin)))
        mkdir (INSTALL_DIR."/$module/carnet/$acronyme");

    $html2pdf->Output($chemin.$nomFichier,'F');
    }

 ?>
