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

$module = $Application::getmodule(3);

$formulaire = isset($_POST['formSanctions']) ? $_POST['formSanctions'] : null;
$formSanctions = array();
parse_str($formulaire, $formSanctions);

$formulaire = isset($_POST['formSelect']) ? $_POST['formSelect'] : null;
$formSelection = array();
parse_str($formulaire, $formSelection);

$nb = 0;

if (isset($formSanctions['datesSanctions']) && isset($formSanctions['idRetards'])) {
    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
    $Presences = new Presences();
    // définir un identifiant $ref pour le traitement en cours
    $idTraitement = $Presences->initTraitementRetard($acronyme);

    // liaison entre le $ref et les dates choisies pour la sanction
    $nb = $Presences->saveDatesSanction($idTraitement, $formSanctions);
    $nb = $Presences->saveIdTraitementIdLogs($idTraitement, $formSanctions);
}
// nombre de retards traités
echo $nb;
