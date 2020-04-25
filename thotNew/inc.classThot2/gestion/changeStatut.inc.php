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

// si c'est une édition, on récupère le nom du groupe
$nomGroupe = isset($_POST['nomGroupe']) ? $_POST['nomGroupe'] : Null;
$membre = isset($_POST['membre']) ? $_POST['membre'] : Null;
$statut = isset($_POST['statut']) ? $_POST['statut'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classThot2.inc.php';
$Thot = new Thot();

$nb = $Thot->changeStatutMembreGroupe($membre, $nomGroupe, $statut);

echo $statut;
