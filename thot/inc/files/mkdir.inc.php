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

$module = $Application->getModule(3);

$arborescence = isset($_POST['arborescence'])?$_POST['arborescence']:Null;
$directory = isset($_POST['directory'])?trim($_POST['directory']):Null;

$ds = DIRECTORY_SEPARATOR;

if (preg_match("/^[A-Za-z0-9\-_ÀÁÅÃÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ ]+$/", $directory)) {
    $newDir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$arborescence.$ds.$directory;
    // ce répertoire existe-t-il déjà?
    if (!(is_Dir($newDir)))
        $resultat = mkdir($newDir, 0770, true);
        else $resultat = 'Ce dossier existe déjà';
    echo $resultat;
}
else echo 'Le nom du dossier contient des caractères interdits';
