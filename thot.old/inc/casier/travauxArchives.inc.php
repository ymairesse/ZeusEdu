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

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$unAn = time() + 365 * 24 * 3600;
$coursGrp = Application::postOrCookie('coursGrp', $unAn);

$statuts = array('archive');
$listeTravaux = $Files->listeTravaux($acronyme, $coursGrp, $statuts);
$listeStatuts = $Files->getDicoStatuts();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';


$smarty->assign('listeTravaux', $listeTravaux);
$smarty->assign('listeStatuts', $listeStatuts);

$smarty->display('casier/modal/detailsArchives.tpl');
