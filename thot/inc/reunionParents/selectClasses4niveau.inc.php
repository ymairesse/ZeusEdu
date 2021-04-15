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

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;

// $unAn = time() + 365 * 24 * 3600;
// $classe = $coursGrp = Application::postOrCookie('classe', $unAn);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeClasses = $Ecole->listeClassesNiveau($niveau);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeClasses', $listeClasses);
// $smarty->assign('classe', $classe);

$smarty->display('reunionParents/selecteurs/selectClasse.tpl');
