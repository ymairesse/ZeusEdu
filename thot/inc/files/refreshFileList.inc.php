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

$directory = isset($_POST['directory']) ? $_POST['directory'] : '';
$arborescence = isset($_POST['arborescence']) ? $_POST['arborescence'] : Null;

$viewMode = isset($_COOKIE['viewMode']) ? $_COOKIE['viewMode'] : 'grille';

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$ds = DIRECTORY_SEPARATOR;
$root = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('arborescence', $arborescence);
$smarty->assign('directory', $directory);
$smarty->assign('viewMode', $viewMode);
$smarty->assign('dir', $Files->flatDirectory($root.$ds.$arborescence.$ds.$directory));

$smarty->display('files/listeFichiers.tpl');
