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

$module = $Application->getModule(3);

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$idRP = isset($_POST['idRP'])?$_POST['idRP']:Null;
$periode = isset($_POST['periode'])?$_POST['periode']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$Thot = new Thot();

// introduire dans la liste d'attente complète
$resultat = $Thot->setListeAttenteProf($matricule, $acronyme, $idRP, $periode);

return $resultat;
