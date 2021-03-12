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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

$date = isset($form['date']) ? $form['date'] : Null;
$dateSQL = Application::dateMySQL($date);
$heure = isset($form['heure']) ? $form['heure'] : Null;
$abreviation = isset($form['acronyme']) ? $form['acronyme'] : Null;
$remarque = isset($form['remarque']) ? $form['remarque'] : Null;
$listeStatuts = isset($form['listeStatuts']) ? $form['listeStatuts'] : Null;
$eduprof = isset($form['eduprof']) ? strtoupper($form['eduprof']) : Null;
$startTime = isset($form['startTime']) ? $form['startTime'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// enregistrement des détails (remplaçant, remarque)
$nb1 = $Edt->saveDataPeriodeAbs($abreviation, $dateSQL, $heure, $remarque, $eduprof);

// enregistrement des statuts
$nb2 = $Edt->setStatuts4periode4prof($abreviation, $dateSQL, $heure, $startTime, $listeStatuts);
// les statuts "move" ne sont pas comptés (pas de modification possible par l'utilisateur)
if (in_array('movedTo', $listeStatuts) || in_array('movedFrom', $listeStatuts))
    $nb2--;

echo json_encode(array('data' => $nb1, 'statuts' => $nb2));
