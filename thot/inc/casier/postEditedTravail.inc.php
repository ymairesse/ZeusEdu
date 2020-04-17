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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;

$form = array();
parse_str($formulaire, $form);

$coursGrp = $form['coursGrp'];

// (ré-)enregistrer le travail
$travail = $Files->saveDataTravail($form, $acronyme);

// restaurer les données à l'écran
$idTravail = $travail['idTravail'];
$dataTravail = $Files->getDataTravail($idTravail, $acronyme, $coursGrp);

$coursGrp = $dataTravail['coursGrp'];
$idTravail = $dataTravail['idTravail'];

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeEleves = $Ecole->listeElevesCours($coursGrp);
// préparation des casiers pour le dépôt des travaux
$nb = $Files->initTravauxEleves($acronyme, $idTravail, $listeEleves);

// compétences pour ce cours
$listeCompetences = $Files->getCompetencesCoursGrp($coursGrp);
// compétences utilisées pour ce travail
$listeCompetencesTravail = $Files->getCompetencesTravail($idTravail);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('dataTravail', $dataTravail);
$smarty->assign('listeCompetences', $listeCompetences);
$smarty->assign('listeCompetencesTravail', $listeCompetencesTravail);

echo $smarty->fetch('casier/editTravail.tpl');
