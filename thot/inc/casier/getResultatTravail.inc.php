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

$unAn = time() + 365 * 24 * 3600;
$idTravail = Application::postOrCookie('idTravail', $unAn);
$matricule = Application::postOrCookie('matricule', $unAn);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$photo = ($matricule != Null) ? Ecole::photo($matricule) : Null;

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

$infoTravail = $Files->getDataTravail($idTravail, $acronyme);
$smarty->assign('infoTravail', $infoTravail);

// caractéristiques des fichiers joints par lélève
$fileInfos = $Files->getFileInfos($matricule, $idTravail, $acronyme);
$smarty->assign('fileInfos', $fileInfos);

$ds = DIRECTORY_SEPARATOR;
$path = '#thot'.$ds.$idTravail.$ds.$matricule;

$smarty->assign('idTravail', $idTravail);
$smarty->assign('matricule', $matricule);

$smarty->assign('photo', $photo);

$smarty->assign('BASEDIR', BASEDIR);
$smarty->assign('COTEABS', COTEABS);
$smarty->assign('COTENULLE', COTENULLE);

$smarty->display('casier/detailsEvaluation.tpl');
