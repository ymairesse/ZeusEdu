<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$activeDir = isset($_REQUEST['activeDir'])?$_REQUEST['activeDir']:null;

$User = $_SESSION[APPLICATION];

$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;

if (!empty($_FILES)) {
    $tempFile = $_FILES['file']['tmp_name'];
    // $targetPath = INSTALL_DIR.$ds.$module.$ds.'upload'.$ds.$acronyme.$activeDir;
    $targetPath = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$activeDir;
    $targetFile = $targetPath.$ds.$_FILES['file']['name'];
    echo (move_uploaded_file($tempFile, $targetFile));
}
