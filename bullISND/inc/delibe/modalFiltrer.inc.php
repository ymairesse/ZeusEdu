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
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$periodesDelibes = explode(',', PERIODESDELIBES);

$periodeSelect = isset($_COOKIE['periodeSelect']) ? $_COOKIE['periodeSelect'] : Null;
$mentionsSelect = isset($_COOKIE['mentionsSelect']) ? $_COOKIE['mentionsSelect'] : Null;

$anScol = ANNEESCOLAIRE;
$listeMentions = $Bulletin->listeMentionsAnScol($anScol);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('periodesDelibes', $periodesDelibes);
$smarty->assign('periodeSelect', $periodeSelect);
$smarty->assign('mentionsSelect', $mentionsSelect);

$smarty->assign('listeMentions', $listeMentions);

$smarty->display('delibe/modal/modalFiltrer.tpl');
