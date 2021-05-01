<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// retrouver le nom du module actif
$module = $Application->getModule(3);

$pad = isset($_POST['pad']) ? $_POST['pad'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classPad.inc.php';
$padEleve = new padEleve($matricule, $acronyme);

$nb = 0;
foreach ($pad as $unPad) {
    $id = explode('_', $unPad['id'])[1];
    $texte = $unPad['texte'];
    $nb += $padEleve->updatePadEleve($id, $matricule, $texte);
}

echo $nb;
