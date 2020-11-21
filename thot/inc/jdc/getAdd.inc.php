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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$categories = $Jdc->categoriesTravaux();

$heure = isset($_POST['heure']) ? $_POST['heure'] : Null;
if ($heure != Null) {
    $heure = $Jdc->heureLaPlusProche($heure);
}

$date = isset($_POST['date']) ? $_POST['date'] : Null;
$type = isset($_POST['type']) ? $_POST['type'] : Null;
$destinataire = isset($_POST['destinataire']) ? $_POST['destinataire'] : Null;
$lblDestinataire = isset($_POST['lblDestinataire']) ? $_POST['lblDestinataire'] : Null;

$travail = array(
    'destinataire' => $destinataire,
    'proprietaire' => $acronyme,
    'idCategorie' => $type,
    'startDate' => $date,
    'heure' => $heure,
    'type' => $type,
    'listePJ' => Null,
    );

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('categories', $categories);
$listePeriodes = $Jdc->lirePeriodesCours();
$smarty->assign('listePeriodes', $listePeriodes);

$smarty->assign('lblDestinataire', $lblDestinataire);

$smarty->assign('travail', $travail);
$smarty->display('jdc/jdcEdit.tpl');
