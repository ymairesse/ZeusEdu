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

$unAn = time() + 365 * 24 * 3600;

$start = $_POST['start'];
$end = $_POST['end'];

$type = isset($_POST['type']) ? $_POST['type'] : Null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;

$module = $Application->getModule(3);
require_once INSTALL_DIR."/$module/inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$eventsList = array();
switch ($type) {
    case 'coursGrp':
        $eventsList = $Jdc->getEvents4Cours($start, $end, $coursGrp, $acronyme);
        break;
    case 'eleve':
        $eventsList = $Jdc->getEvents4Eleve($start, $end, $matricule, $acronyme);
        break;
    case 'classe':
        $eventsList = $Jdc->getEvents4Classe($start, $end, $classe, $acronyme);
        break;
    case 'niveau':
        $eventsList = $Jdc->getEvents4Niveau($start, $end, $niveau, $acronyme);
        break;
    case 'ecole':
        $eventsList = $Jdc->getEvents4Ecole($start, $end, $acronyme);
        break;
    case 'subjectif':
        require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
        $listeCoursEleve = Eleve::getListeCoursEleve($matricule);
        $detailsEleve = Eleve::staticGetDetailsEleve($matricule);
        $classe = $detailsEleve['groupe'];
        $niveau = substr($classe, 0, 1);
        $eventsListCours = $Jdc->getEvents4Cours($start, $end, $listeCoursEleve, $acronyme);
        $eventsListEleve = $Jdc->getEvents4Eleve($start, $end, $matricule, $acronyme);
        $eventsListClasse = $Jdc->getEvents4Classe($start, $end, $classe, $acronyme);
        $eventsListNiveau = $Jdc->getEvents4Niveau($start, $end, $niveau, $acronyme);;
        $eventsListEcole = $Jdc->getEvents4Ecole($start, $end, $acronyme);
        $eventsList = array_merge($eventsListEleve, $eventsListCours, $eventsListClasse, $eventsListNiveau, $eventsListEcole);
        break;
}

echo json_encode($eventsList);
