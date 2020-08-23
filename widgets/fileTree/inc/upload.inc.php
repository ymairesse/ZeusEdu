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

$activeDir = isset($_REQUEST['activeDir']) ? $_REQUEST['activeDir'] : Null;

$ds = DIRECTORY_SEPARATOR;

if (!empty($_FILES)) {
    $tempFile = $_FILES['file']['tmp_name'];
    $targetPath = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$activeDir;
    setlocale(LC_ALL,'fr_FR.UTF-8');
    $_FILES['file']['name'] = iconv('UTF-8', 'ASCII//TRANSLIT', $_FILES['file']['name']);
    // $_FILES['file']['name'] =  preg_replace("/[^A-Za-z0-9 \_\-\.]/", '_', basename($_FILES['file']['name']));
    $targetFile = $targetPath.$ds.$_FILES['file']['name'];

    echo (move_uploaded_file($tempFile, $targetFile));
}
