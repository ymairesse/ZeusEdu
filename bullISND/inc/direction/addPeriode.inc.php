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
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$anScol = isset($_POST['anScol']) ? $_POST['anScol'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
$padEleve = new padEleve($matricule, $acronyme);

$nb = $padEleve->addPeriode($anScol, $periode);

echo $nb;
