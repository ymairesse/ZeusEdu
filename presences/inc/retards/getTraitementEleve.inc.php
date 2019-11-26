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

$module = $Application::getmodule(3);

// récupérer le formulaire
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$debut = isset($_POST['debut']) ? $_POST['debut'] : Null;
$fin = isset($_POST['fin']) ? $_POST['fin'] : Null;
$niveau = Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

$listeIds = $Presences->getRetards4Periode($debut, $fin, Null, Null, $matricule);
$listeRetards = isset($listeIds[$matricule]['nonTraite']) ? $listeIds[$matricule]['nonTraite'] : 0;

// Vérifier si le module EDT a été installé
$EDTInstalle = file_exists(INSTALL_DIR.$ds.'edt'.$ds.'inc/classes/classEDT.inc.php');

if ($EDTInstalle) {
    require_once INSTALL_DIR.$ds.'edt'.$ds.'inc/classes/classEDT.inc.php';
    $Edt = new Edt();
    $imageEDT = $Edt->getEdtEleve($matricule);
    }

require_once INSTALL_DIR.$ds.'inc/classes/classEleve.inc.php';
$eleve = Eleve::getMinDetailsEleve($matricule);

setlocale(LC_TIME, "fr_FR");
$today = strftime('%A %d/%m/%Y');

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes', $listePeriodes);

$smarty->assign('date', $today);
if ($EDTInstalle)
    $smarty->assign('imageEDT', $imageEDT);
$smarty->assign('EDTInstalle', $EDTInstalle);
$smarty->assign('matricule', $matricule);
$smarty->assign('eleve', $eleve);
$smarty->assign('listeRetards', $listeRetards);

$smarty->display('retards/choixSanction.tpl');
