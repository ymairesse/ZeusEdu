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

$commentaire = isset($_POST['commentaire'])?$_POST['commentaire']:Null;
$shareId =  isset($_POST['shareId'])?$_POST['shareId']:Null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

if ($Files->verifProprietaireShare($shareId, $acronyme)) {
    $commentaire = $Files->saveEditedComment($commentaire, $shareId);
}

echo $commentaire;
