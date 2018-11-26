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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();
$start = $_POST['start'];
$end = $_POST['end'];

$type = isset($_POST['type']) ? $_POST['type'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$destinataire = isset($_POST['destinataire']) ? $_POST['destinataire'] : Null;

// $lesTypes sont les types d'événements visibles par le $destinataire
$eventsList = $Jdc->getMyGlobalEvents($type, $destinataire, $start, $end, Null);

echo json_encode($eventsList);
