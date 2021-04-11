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

$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : null;
$form['idRP'] = $idRP;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$nb = $Thot->saveRPinit2data($idRP, $form);
$message = sprintf('%d informations enregistrées', $nb);

$heures = $Thot->saveRPinit2heures($idRP, $form);

echo json_encode(array('nb' => $nb, 'heures'=> $heures));
