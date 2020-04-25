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

$nomGroupe = isset($_POST['nomGroupe']) ? $_POST['nomGroupe'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classThot.inc.php';
$Thot = new Thot();

// recherche des notifications au groupe $nomGroupe
$listeNotifs = $Thot->listeNotifs4entite('groupe', $nomGroupe, $acronyme);

$nbPJ = 0;
$nbAcc = 0;
foreach ($listeNotifs AS $notifId => $wtf){
    $nbPJ += $Thot->delPJ4notif($notifId, $acronyme, Null) ;
    $nbAcc += $Thot->delAccuse($notifId, $acronyme);
}

if ($Thot->supprGroupeEtMembres($nomGroupe, $acronyme))
    echo sprintf('Groupe supprimé, %d annonce(s), %d pièce(s) jointe(s) et %d accusé(s) de lecture supprimés', count(array_keys($listeNotifs)), $nbPJ, $nbAcc);
    else echo "Ce groupe ne vous appartient pas";
