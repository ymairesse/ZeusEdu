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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

// en provenance du CKEditor
$description = isset($_POST['description']) ? $_POST['description'] : null;
$form['description'] = $description;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classThot.inc.php';
$Thot = new Thot();

// enregistrement des informations sur le groupe
$nb = $Thot->saveData4groupe($form, $acronyme);
// enregistrement des informations sur le propriétaire si quelque chose a été enregistré
if ($nb == 1) {
    $nomGroupe = $form['nomGroupe'];
    $n = $Thot->saveProprioGroupe($nomGroupe, $acronyme);
}

echo $nb;
