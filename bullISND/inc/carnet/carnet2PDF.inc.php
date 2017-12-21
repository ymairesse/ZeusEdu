<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

$titre = isset($_POST['titre'])?$_POST['titre']:'';
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$tri = isset($_POST['tri'])?$_POST['tri']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:Null;
$nomProf =  isset($_POST['nomProf'])?$_POST['nomProf']:Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

require_once INSTALL_DIR."/inc/classes/classEcole.inc.php";
$Ecole = new Ecole();

require_once INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php";
$Bulletin = new Bulletin();

$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
$listeTravaux = $Bulletin->listeTravaux($coursGrp, $bulletin);
$listeCotes = ($listeTravaux != Null) ? $Bulletin->listeCotesCarnet($listeTravaux) : Null;
$listeMoyennes = $Bulletin->listeMoyennesCarnet($listeCotes);
$listeCompetences = current($Bulletin->listeCompetences($coursGrp));

$smarty->assign('listeCotes', $listeCotes);
$smarty->assign('listeMoyennes', $listeMoyennes);
$smarty->assign('listeCompetences', $listeCompetences);
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('listeTravaux',$listeTravaux);
$smarty->assign('listeEleves',$listeEleves);
$smarty->assign('nomProf',$nomProf);

$carnet4PDF =  $smarty->fetch('simpleShowCarnet.tpl');

require_once(INSTALL_DIR."/html2pdf/html2pdf.class.php");
$html2pdf = new HTML2PDF('L','A4','fr');

$html2pdf->WriteHTML($carnet4PDF);

$nomFichier = $coursGrp.'_'.$bulletin.'.pdf';
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

echo sprintf('<p>Vous pouvez récupérer le document au format PDF en cliquant <a target="_blank" id="celien" href="inc/download.php?type=pfN&amp;f=%s/%s">sur ce lien</a></p>', $module, $nomFichier);
