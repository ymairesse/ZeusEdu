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

require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
$Athena = new Athena();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

// enregistrement dans la table didac_athena
$id = $Athena->saveEleveASuivre($form);
$date = $form['date'];
$urgence = $form['urgence'];

// enregistrement dans la table des demandes de suivi
$nb = $Athena->saveDemandeSuivi($id, $date, $urgence);

echo $id;
