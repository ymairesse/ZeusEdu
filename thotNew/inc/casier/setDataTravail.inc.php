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

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$listeCours = $User->listeCoursProf();

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$idTravail = isset($_POST['idTravail']) ? $_POST['idTravail'] : null;

// recherche des caractéristiques générales du travail
$dataTravail = $Files->getDataTravail($idTravail, $acronyme, $coursGrp);

// liste des compétences génériques pour ce cours
$listeCompetences = $Files->getCompetencesCoursGrp($coursGrp);
// liste des compétences testées dans ce travail
$listeCompetencesTravail = $Files->getCompetencesTravail($idTravail);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('dataTravail', $dataTravail);
$smarty->assign('listeCompetences', $listeCompetences);
$smarty->assign('listeCompetencesTravail', $listeCompetencesTravail);

echo $smarty->fetch('casier/editTravail.tpl');
