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
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

$fileInfos = $Files->getFileInfos($matricule, $idTravail, $acronyme);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$photo = Ecole::photo($matricule);

// recherche des compétences associées à ce travail
$competencesTravail = $Files->getCompetencesTravail($idTravail);

// recherche des cotes associées aux compétences pour l'élève
$evaluationsTravail = $Files->getEvaluationsTravail($idTravail, $matricule);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('BASEDIR', BASEDIR);
$smarty->assign('fileInfos', $fileInfos);
$smarty->assign('photo', $photo);
$smarty->assign('competencesTravail', $competencesTravail);
$smarty->assign('evaluationsTravail', $evaluationsTravail);

echo $smarty->fetch('casier/detailsEvaluation.tpl');
