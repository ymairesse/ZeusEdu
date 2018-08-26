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

$activeDir = isset($_POST['activeDir']) ? $_POST['activeDir'] : '/';
$level = isset($_POST['level']) ? $_POST['level'] : 0;

$module = Application::getModule(3);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/widgets/fileTree/inc/classes/class.Treeview.php';
$Tree = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$acronyme, Null);

$root = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;
$filesList = $Tree->onlyFilesList($root, $activeDir);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.'/widgets/fileTree/templates';
$smarty->compile_dir = INSTALL_DIR.'/widgets/fileTree/templates_c';

$smarty->assign('activeDir', $activeDir);
$smarty->assign('level', $level);
$smarty->assign('filesList', $filesList);

$smarty->display('repertoire.tpl');
