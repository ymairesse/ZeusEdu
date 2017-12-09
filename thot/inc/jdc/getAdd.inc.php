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

require_once INSTALL_DIR."/$module/inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$categories = $Jdc->categoriesTravaux();

$startDate = isset($_POST['startDate']) ? $_POST['startDate'] : null;
$heure = isset($_POST['heure']) ? $_POST['heure'] : null;
if ($heure != Null) {
    $heure = $Jdc->heureLaPlusProche($heure);
}
$listePeriodes = $Jdc->lirePeriodesCours();

$type = isset($_POST['type']) ? $_POST['type'] : null;
$destinataire = isset($_POST['destinataire']) ? $_POST['destinataire'] : null;
$lblDestinataire = isset($_POST['lblDestinataire']) ? $_POST['lblDestinataire'] : null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('categories', $categories);
// $smarty->assign('listeCours', $listeCours);
// $smarty->assign('listeClasses', $listeClasses);
$smarty->assign('listePeriodes', $listePeriodes);

$smarty->assign('startDate', $startDate);
$smarty->assign('heure', $heure);
$smarty->assign('type', $type);
$smarty->assign('destinataire', $destinataire);
$smarty->assign('lblDestinataire', $lblDestinataire);

$smarty->display('jdc/modalEdit.tpl');
