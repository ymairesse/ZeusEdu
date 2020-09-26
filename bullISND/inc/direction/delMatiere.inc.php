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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$anScol = isset($_POST['anScol']) ? $_POST['anScol'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classPad.inc.php';
$padEleve = new padEleve($matricule, $acronyme);

$nb = $padEleve->delMatiere($matricule, $coursGrp, $anScol, $periode);

echo $nb;
