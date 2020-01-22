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

$id = isset($_POST['id']) ? $_POST['id'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$guest = isset($_POST['guest']) ? $_POST['guest'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classPad.inc.php';
$PadEleve = new padEleve($matricule, $acronyme);

$nb = 0;
if ($PadEleve->isOwner($acronyme, $id))
    $nb = $PadEleve->unlink($guest, $id);

echo $nb;
