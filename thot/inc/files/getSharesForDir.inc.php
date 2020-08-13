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

$arborescence = isset($_POST['arborescence']) ? $_POST['arborescence'] : Null;

// suppression du '/' au début du chemin
$arborescence = substr($arborescence, 0, strrpos($arborescence, '/'));
$fileName = substr($arborescence, strrpos($arborescence, '/')+1);
$dirOrFile = 'dir';

// la racine n'est pas partageable (sécurité) => Null
$shareEnabled = ($fileName == Null) ? false : true;

$listePartages = $Files->getSharesByFileName($arborescence, $fileName, $dirOrFile, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listePartages', $listePartages);
$smarty->assign('fileName', $fileName);
$smarty->assign('arborescence', $arborescence);
$smarty->assign('shareEnabled', $shareEnabled);
$smarty->assign('dirOrFile', $dirOrFile);

$smarty->display('files/listePartages.tpl');
