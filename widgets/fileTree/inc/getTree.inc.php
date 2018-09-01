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

// la liste des fichiers présélectionnés
$files = isset($_POST['files']) ? $_POST['files'] : null;
$selectedFiles = array();
parse_str($files, $selectedFiles);
$selectedFiles = current($selectedFiles);

$listePJ = array();
if ($selectedFiles != Null) {
    foreach ($selectedFiles AS $oneFile) {
        $file = explode('|//|', $oneFile);
        $listePJ[] = $file[1].$file[2];
    }
}

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'widgets/fileTree/inc/classes/class.Treeview.php';

$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
    }
$Tree = new Treeview($chemin, $listePJ);

$tree = $Tree->getTree();

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('tree', $tree);
$smarty->display('tree.tpl');
