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

$arborescence = isset($_POST['arborescence']) ? $_POST['arborescence'] : null;
$fileName = isset($_POST['fileName']) ? $_POST['fileName'] : null;

$ds = DIRECTORY_SEPARATOR;

$activeDir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$arborescence.$ds.$fileName;
$listFiles = $Files->flatDirectory($activeDir);

if (count($listFiles) > 0) {
    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('arborescence', $arborescence);
    $smarty->assign('fileName', $fileName);
    $smarty->assign('listFiles', $listFiles);

    $smarty->display('files/listFiles.tpl');
}
else echo Null;
