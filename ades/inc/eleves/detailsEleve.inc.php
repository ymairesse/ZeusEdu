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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$dataEleve = $Eleve->getDetailsEleve();

$matricule = $dataEleve['matricule'];
$groupe = $dataEleve['groupe'];

echo json_encode(array('matricule' => $dataEleve['matricule'], 'groupe' => $dataEleve['groupe']));
