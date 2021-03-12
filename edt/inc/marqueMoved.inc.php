<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

// liste des mouvements (movedFrom ou movedTo)
$listeOld = json_decode($_POST['listeOld']);
$listeNew = json_decode($_POST['listeNew']);
$statut = isset($_POST['statut']) ? $_POST['statut'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

$nb = 0;
foreach ($liste as $dataMove){
    // structure de $dataMove = array($date, $heure, array($abreviation, $startTime))
    $date = $dataMove[0];
    $heure = $dataMove[1];
    $key = $dataMove[2];
    $abreviation = $key[0];
    // $startTime recomposé après déplacement (ou pas) à ne pas confondre avec startTime d'origine
    $startTime = sprintf('%s %s', $date, $heure);

    // ajout du statut s'il n'y est pas déjà
    $nb += $Edt->addStatut4periodeProf($abreviation, $startTime, $heure, $statut);
}

echo $nb;
