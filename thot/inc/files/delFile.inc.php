<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}
$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$fileName = isset($_POST['fileName'])?$_POST['fileName']:Null;
$path = isset($_POST['path'])?$_POST['path']:Null;

$listShares = $Files->listShares($path, $fileName, $acronyme);

$resultat = false;
$ds = DIRECTORY_SEPARATOR;
if ($fileName != Null) {
    // $file = INSTALL_DIR.$ds.$module.$ds.'upload'.$ds.$acronyme.$ds.$path.$ds.$fileName;
    $file = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$path.$ds.$fileName;
    $resultat = @unlink($file);
    if ($resultat) {
        $Files->clearBD($path, $fileName, $acronyme);
        $Files->delAllShares($path, $fileName, $acronyme);
    }
}

echo ($resultat === false)?0:1;
