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

$arborescence = isset($_POST['arborescence']) ? $_POST['arborescence'] : Null;
$directory = isset($_POST['directory']) ? $_POST['directory'] : Null;

// si on a cliqué dans le breadcrumb plutôt que dans la liste des fichiers
if ($directory == Null) {
    $directory = substr($arborescence, strrpos($arborescence,'/')+1);
    $arborescence = substr($arborescence, 0, strrpos($arborescence,'/'));
}

$ds = DIRECTORY_SEPARATOR;
$root = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;

if (is_dir($root.$ds.$arborescence.$ds.$directory)) {
    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $arborescence = $arborescence.$ds.$directory;
    // rustine :o(
    $arborescence = preg_replace('~/+~', '/', $arborescence);

    $smarty->assign('arborescence', $arborescence);

    // création des breadcrumbs
    $liste = explode('/', $arborescence);
    $listeDirs = array();
    $dirPrec = Null;
    foreach ($liste as $n => $dir) {
        $listeDirs[$dir] = ($dirPrec != '') ? $dirPrec.$ds.$dir : $dirPrec.$dir;
        $dirPrec = $listeDirs[$dir];
    }
    $smarty->assign('listeDirs', $listeDirs);
    $smarty->assign('acronyme', $acronyme);
    $smarty->assign('directory', $directory);

    $smarty->display('files/breadcrumbs.tpl');
}
