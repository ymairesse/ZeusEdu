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

$fileName = isset($_POST['fileName']) ? $_POST['fileName'] : '';
$arborescence = isset($_POST['arborescence']) ? $_POST['arborescence'] : Null;
$dirOrFile = isset($_POST['dirOrFile']) ? $_POST['dirOrFile'] : Null;

$listePartages = $Files->getSharesByFileName($arborescence, $fileName, $dirOrFile,  $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listePartages', $listePartages);
$smarty->assign('fileName', $fileName);
$smarty->assign('arborescence', $arborescence);
$smarty->assign('shareEnabled', true);
$smarty->assign('dirOrFile', $dirOrFile);

$smarty->display('files/listePartages.tpl');
