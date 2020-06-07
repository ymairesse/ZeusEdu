<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class User pour récupérer le nom d'utilisateur depuis la session
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

// retrouver le nom du module actif
$module = $Application->getModule(3);
$ds = DIRECTORY_SEPARATOR;

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// récupérer le formulaire d'encodage des cours
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$matricule = $form['matricule'];

require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
$padEleve = new padEleve($matricule, $acronyme);

$nb = $padEleve->saveFicheMatiere($form);
$nb += $padEleve->saveFicheGenerale($form);

echo $nb;
