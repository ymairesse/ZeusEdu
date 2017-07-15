<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$module = $Application->getModule(3);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR."/inc/classes/classEcole.inc.php";
$Ecole = new Ecole();
// récupérer le formulaire d'encodage du livre
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;

$form = array();
parse_str($formulaire, $form);

$idretenue = $form['idretenue'];
// liste des élèves inscrits à cette retenues
$listeEleves = array_keys($Ades->listeElevesRetenue($idretenue));

// enregistrement des présences
$nbPresents = isset($form['present']) ? $Ades->savePresences($listeEleves, $form['present'], $idretenue) : 0;
// enregistrement des signatures
$nbSignes = isset($form['signe']) ? $Ades->saveSignature($listeEleves, $form['signe'], $idretenue) : 0;

echo sprintf('<strong>%d</strong> élèves présents et <strong>%d</strong> retenues signées', $nbPresents, $nbSignes);
