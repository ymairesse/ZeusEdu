<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT."</div>");
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$activeDir = isset($_POST['activeDir'])?$_POST['activeDir']:Null;
$dirName = isset($_POST['dirName'])?trim($_POST['dirName']):Null;

$ds = DIRECTORY_SEPARATOR;

if (preg_match("/^[A-Za-z0-9\-_ÀÁÅÃÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ ]+$/", $dirName)) {
    $newDir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$activeDir.$dirName;
    if (!(is_Dir($newDir)))
        $resultat = mkdir($newDir, 0770, true);
        else $resultat = 'Ce dossier existe déjà';
    echo $resultat;
}
else echo 'Le nom du dossier contient des caractères interdits';
