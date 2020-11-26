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
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(3);
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

require_once INSTALL_DIR.$ds.'inc/classes/classEleve.inc.php';
$listeCoursEleve = Eleve::getListeCoursEleve($matricule);
$detailsEleve = Eleve::staticGetDetailsEleve($matricule);
$classe = $detailsEleve['groupe'];
$niveau = substr($classe, 0, 1);

$eventsListCours = $Jdc->getEvents4Cours($start, $end, $listeCoursEleve, Null);
$eventsListEleve = $Jdc->getEvents4Eleve($start, $end, $matricule, Null);
$eventsListClasse = $Jdc->getEvents4Classe($start, $end, $classe, Null);
$eventsListNiveau = $Jdc->getEvents4Niveau($start, $end, $niveau, Null);;
$eventsListEcole = $Jdc->getEvents4Ecole($start, $end, Null);
$listeRemediations = $Jdc->retreiveRemediations($start, $end, $matricule);
$listeCoaching = $Jdc->retreiveCoaching($start, $end, $matricule);


$eventsList = array_merge(
    $eventsListEleve,
    $eventsListCours,
    $eventsListClasse,
    $eventsListNiveau,
    $eventsListEcole,
    $listeRemediations,
    $listeCoaching
);

echo json_encode($eventsList);
