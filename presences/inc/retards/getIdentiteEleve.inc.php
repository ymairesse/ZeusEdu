<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "ERREURSESSION";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

if (is_numeric($matricule)) {
    require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
    $detailsEleve = Eleve::staticGetDetailsEleve($matricule);

    echo json_encode($detailsEleve);
}
