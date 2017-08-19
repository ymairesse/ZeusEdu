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

$fileName = isset($_POST['fileName'])?$_POST['fileName']:Null;
$arborescence = isset($_POST['arborescence'])?$_POST['arborescence']:Null;

$listShares = $Files->listShares($arborescence, $fileName, $acronyme);

$resultat = false;
$ds = DIRECTORY_SEPARATOR;

if ($fileName != Null) {
    $file = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$arborescence.$ds.$fileName;
    $resultat = @unlink($file);
    if ($resultat) {
        // supprimer les références au fichier, dans la BD
        $Files->clearBD($arborescence, $fileName, $acronyme);
        // supprimer tous les partages du fichier dans la BD
        $Files->delAllShares($arborescence, $fileName, $acronyme);
    }
}

echo ($resultat === false) ? 0 : 1;
