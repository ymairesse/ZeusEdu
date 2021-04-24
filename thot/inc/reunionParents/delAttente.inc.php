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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : $acronyme;
$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;


require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();

$nb = $thot->delListeAttenteProf($matricule, $abreviation, $idRP, $periode);

echo $nb;
