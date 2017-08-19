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

$arborescence = isset($_POST['arborescence'])?$_POST['arborescence']:Null;
$directory = isset($_POST['directory'])?$_POST['directory']:Null;

$ds = DIRECTORY_SEPARATOR;
$root = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;

$arborescence = $arborescence.$ds.$directory;
// rustine
$fileName = preg_replace('~/+~', '/', $fileName);

// impossible d'effacer un répertoire dont le nom commence par #
if (substr($arborescence, 0, 1) != '#') {
     $allFiles = $Files->getAllFilesFrom($root, $arborescence);
     $allFiles = $Files->getFileIdForFileList($allFiles, $acronyme);
     $nb = $Files->unShareFileList($allFiles);
     echo json_encode(array('nbFiles' => count($allFiles), 'nbDir' => $Files->delTree(INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$arborescence)));
    }
else {
     exit;
}
