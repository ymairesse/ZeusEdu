<?php

require_once '../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}
$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/thot/inc/classes/classJdc.inc.php';
$jdc = new Jdc();

$listeCours = $User->getListeCours();
$listeClasses = $User->listeTitulariats("'G','TT','S','C','D'");
$categories = $jdc->categoriesTravaux();

$startDate = isset($_POST['startDate']) ? $_POST['startDate'] : null;
$viewState = isset($_POST['viewState']) ? $_POST['viewState'] : null;
$heure = isset($_POST['heure']) ? $_POST['heure'] : null;
$type = isset($_POST['type']) ? $_POST['type'] : null;
$destinataire = isset($_POST['destinataire']) ? $_POST['destinataire'] : null;
$lblDestinataire = isset($_POST['lblDestinataire']) ? $_POST['lblDestinataire'] : null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('categories', $categories);
$smarty->assign('listeCours', $listeCours);
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('startDate', $startDate);
$smarty->assign('viewState', $viewState);
$smarty->assign('heure', $heure);
$smarty->assign('type', $type);
$smarty->assign('destinataire', $destinataire);
$smarty->assign('lblDestinataire', $lblDestinataire);

$smarty->display('jdc/modalAdd.tpl');
