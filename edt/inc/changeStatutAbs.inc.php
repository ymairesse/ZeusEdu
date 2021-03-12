<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

$date = isset($_POST['date']) ? $_POST['date'] : Null;
$heure = isset($_POST['heure']) ? $_POST['heure'] : Null;
$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;
$startTime = isset($_POST['startTime']) ? $_POST['startTime'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

$dateSQL = Application::dateMySQL($date);
$absence = $Edt->getAbsence4periode($abreviation, $dateSQL, $heure);

// liste des statuts déjà activés pour cette période
$Statuts = $Edt->getStatuts4periode($abreviation, $dateSQL, $heure);

// réorganisation "normal" et "move"
$listeStatuts = array();
foreach ($Statuts AS $unStatut) {
    if (($unStatut == 'movedFrom') || ($unStatut == 'movedTo'))
        $listeStatuts['move'] = $unStatut;
        else $listeStatuts['normal'][] = $unStatut;
    }

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeProfs = $Ecole->listeProfs();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';


$smarty->assign('absence', $absence);
$smarty->assign('listeStatuts', $listeStatuts);
$smarty->assign('heure', $heure);
$smarty->assign('date', $date);
$smarty->assign('acronyme', $abreviation);
$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('startTime', $startTime);

$smarty->display('modal/modalChangeStatut.tpl');
