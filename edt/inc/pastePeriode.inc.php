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

$date = isset($_POST['date']) ? $_POST['date'] : Null;
$heure = isset($_POST['heure']) ? $_POST['heure'] : Null;
$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;
$startTime = isset($_POST['startTime']) ? $_POST['startTime'] : Null;

$newDate = isset($_POST['newDate']) ? $_POST['newDate'] : Null;
$newHeure = isset($_POST['newHeure']) ? $_POST['newHeure'] : Null;
$newAcronyme = isset($_POST['newAcronyme']) ? $_POST['newAcronyme'] : Null;

if (($date != $newDate) || ($abreviation != $newAcronyme)){
    echo -1;
}
else {
    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
    $Edt = new Edt();

    $dateSQL = Application::dateMySQL($date);
    // caractéristiques et statut pour la période copiée
    $absence = $Edt->getAbsence4periode($abreviation, $dateSQL, $heure);
    $listeStatuts = $Edt->getStatuts4periode($abreviation, $dateSQL, $heure);

    // enregistrement de la nouvelle absence
    $startTime = sprintf('%s %s:00', $dateSQL, $newHeure);;
    $absence['startTime'] = $startTime;
    $absence['heure'] = $newHeure;
    $nb = $Edt->setAbsence4periode($absence);

    // enregistrement des statuts correspondants
    $nb = $Edt->setStatuts4periode4prof($abreviation, $dateSQL, $newHeure, $startTime, $listeStatuts);

    echo $nb;
    }
