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

$idTravail = isset($_POST['idTravail']) ? $_POST['idTravail'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$competences = isset($_POST['competences']) ? $_POST['competences'] : null;

// enregistrer les nouvelles compétences pour ce travail
$nb = $Files->saveNewCompetences ($idTravail, $competences);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

// créer le nouveau tableau des compétences dans la page d'édition du travail
$dataTravail = $Files->getDataTravail($idTravail, $acronyme, $coursGrp);
$listeCompetences = $Files->getCompetencesCoursGrp($coursGrp);

$smarty->assign('dataTravail', $dataTravail);
$smarty->assign('listeCompetences', $listeCompetences);

echo $smarty->fetch('casier/tableauCompetences.tpl');
