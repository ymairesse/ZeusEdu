<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}
$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$ds = DIRECTORY_SEPARATOR;

// $listePJ = isset($_POST['listePJ']) ? $_POST['listePJ'] : Null;
// $listePJ =  json_decode($listePJ);
// Application::afficher($listePJ);
// require_once INSTALL_DIR.'/inc/classes/class.Treeview.php';
//
// $tree = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$acronyme);
// $baobab = $tree->getTree($listePJ);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('tree', $baobab);
$smarty->assign('listePJ', $listePJ);

$smarty->display('treeview4PJ.tpl');
