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

$start = $_POST['start'];
$end = $_POST['end'];
$type = $_POST['type'];
$coursGrp = $_POST['coursGrp'];
$classe = $_POST['classe'];
$matricule = $_POST['matricule'];

$module = $Application->getModule(2);
require_once INSTALL_DIR."/$module/inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

switch ($type) {
    case 'cours':
        $eventsList = $Jdc->getEvents4Cours($start, $end, $coursGrp, $acronyme);
        break;
    case 'eleves':
        $listeCoursEleve = $Jdc->listeCoursGrpEleves($matricule);
        $eventsListCours = $Jdc->getEvents4Cours($start, $end, $listeCoursEleve, $acronyme);
        $eventsListClasse = $Jdc->getEvents4Classe($start, $end, $classe, $acronyme);
        $eventsList = array_merge($eventsListCours, $eventsListClasse);
        break;
    case 'classe':
        $listeCoursClasse = $Jdc->listeCoursClasse($classe);
        $eventsListCours = $Jdc->getEvents4Cours($start, $end, $listeCoursClasse, $acronyme);
        $eventsListClasse = $Jdc->getEvents4Classe($start, $end, $classe, $acronyme);
        $eventsList = array_merge($eventsListCours, $eventsListClasse);
        break;
    default:
        $eventsList = Null;
        break;
    }


echo json_encode($eventsList);
