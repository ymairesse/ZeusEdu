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

$arborescence = isset($_POST['arborescence']) ? $_POST['arborescence'] : '/';
$level = isset($_POST['level']) ? $_POST['level'] : 0;

$module = Application::getModule(2);

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$ds = DIRECTORY_SEPARATOR;
$root = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;

$filesList = $Files->onlyFilesList($root, $arborescence);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('arborescence', $arborescence);
$smarty->assign('level', $level);
$smarty->assign('filesList', $filesList);

$smarty->display('repertoire.tpl');
