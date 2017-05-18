<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$idTravail = isset($_POST['idTravail']) ? $_POST['idTravail'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

// résultats pour l'élève $matricule pour le tavail $idTravail ($acronyme pour vérifier le propriétaire)
$evaluationsTravail = $Files->getResultatTravail($idTravail, $matricule, $acronyme);
$smarty->assign('evaluationsTravail', $evaluationsTravail);

// compétences évaluées dans ce travail, y compris les points accordés par compétence
$competencesTravail = $Files->getCompetencesTravail($idTravail);
$smarty->assign('competencesTravail', $competencesTravail);

// caractéristiques du fichier joint par lélève
$fileInfos = $Files->getFileInfos($matricule, $idTravail, $acronyme);
$smarty->assign('fileInfos', $fileInfos);

echo $smarty->fetch('casier/detailsEvaluation.tpl');
