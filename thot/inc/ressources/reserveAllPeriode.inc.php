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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$heure = isset($_POST['heure']) ? $_POST['heure'] : Null;

$dateStart = isset($form['dateStart']) ? $form['dateStart'] : Null;
$dateStart = Application::dateMysql($dateStart);

$dateEnd = isset($form['dateEnd']) ? $form['dateEnd'] : Null;
$dateEnd = Application::dateMysql($dateEnd);

$ressources = isset($form['ressources']) ? $form['ressources'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
$Reservation = new Reservation();

// liste des jours hors WE
$listeJours = $Reservation->getListOfDays($dateStart, $dateEnd);
$listeDatesDebut = array();
foreach ($listeJours as $n => $date){
    $listeDatesDebut[$n] = sprintf('%s %s:00', $date, $heure);
}

$listeModifs = $Reservation->reserveAllRessource4periode($ressources, $listeDatesDebut, $heure, $acronyme);
