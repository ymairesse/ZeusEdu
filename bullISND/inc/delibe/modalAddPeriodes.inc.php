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

$listePeriodes = $Bulletin->listePeriodes(NBPERIODES);
$periodesDelibes = explode(',', PERIODESDELIBES);
// $listeHorsDelibe = array_diff($listePeriodes, $periodesDelibes);
// cookies pour la sélection de périodes non délibératoires issues de la feuille de synthèse par période
$periodesSynthese = isset($_COOKIE['periodesSynthese']) ? $_COOKIE['periodesSynthese'] : Null;


require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listePeriodes', $listePeriodes);
$smarty->assign('periodesDelibes', $periodesDelibes);
$smarty->assign('periodesSynthese', $periodesSynthese);

$smarty->display('delibe/modal/modalAddPeriodes.tpl');
