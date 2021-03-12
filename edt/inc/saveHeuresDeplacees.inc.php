<?php

require_once '../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("Votre session est expirée. Veuillez vous reconnecter.");
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(2);

// liste des mouvements (movedFrom ou movedTo) provenant du formulaire
$listeOld = json_decode($_POST['listeOld']);
$listeNew = json_decode($_POST['listeNew']);

// Application::afficher(array($listeOld, $listeNew), true);

$dataNew = array();
foreach ($listeNew AS $data){
    $data[0] = Application::dateMySQL($data[0]);
    $abreviation = $data[2];
    $startTime = $data[3];
    $heure = $data[1];
    $dataNew[$abreviation][$startTime] = $data;
}

$dataOld = array();
foreach ($listeOld as $data){
    $data[0] = Application::dateMySQL($data[0]);
    $abreviation = $data[2];
    $startTime = $data[3];
    $heure = $data[1];
    $dataOld[$abreviation][$startTime] = $data;
}

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// parcourir l'ensemble des périodes anciennes (déplacées)
foreach ($dataOld AS $abreviation => $dataProf) {
    foreach ($dataProf AS $startTime => $dataPeriode){
        $oldDate = $dataPeriode[0];
        $oldHeure = $dataPeriode[1];
        $abreviation = $dataPeriode[2];

        //récupérer les statuts
        $oldStatuts = $Edt->getStatuts4periode($abreviation, $oldDate, $oldHeure);

        // récupérer les informations d'absences pour la période
        $oldAbsence = $Edt->getAbsence4periode($abreviation, $oldDate, $oldHeure);

        $newStatuts = $oldStatuts;
        $oldStatuts['move'] = 'movedFrom';
        $newStatuts['move'] = 'movedTo';

        $newPeriode = $dataNew[$abreviation][$startTime];
        $newHeure = $newPeriode[1];

        // enregistrer la nouvelle période d'absence après déplacement
        $newAbsence = $oldAbsence;
        $newAbsence['heure'] = $newHeure;

        $nb = $Edt->setAbsence4periode($newAbsence);

        // ajuster la période d'origine (avec "movedFrom")
        $nb = $Edt->setStatuts4periode4prof($abreviation, $oldDate, $oldHeure, $startTime, $oldStatuts);
        // enregistrer la période de destination (avec "movedTo")
        $nb = $Edt->setStatuts4periode4prof($abreviation, $oldDate, $newHeure, $startTime, $newStatuts);

    }
}
// nombre de déplacements
echo count($listeOld);
