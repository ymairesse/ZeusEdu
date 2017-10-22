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
$module = $Application->getModule(3);

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$unAn = time() + 365 * 24 * 3600;
$matricule = Application::postOrCookie('matricule', $unAn);
$idTravail = Application::postOrCookie('idTravail', $unAn);
$coursGrp = Application::postOrCookie('coursGrp', $unAn);

$listeCours = $User->listeCoursProf();
$listeTravaux = $coursGrp != Null ? $Files->listeTravaux($acronyme, $coursGrp) : Null;
$listeTravauxRemis = $Files->listeTravauxRemis($coursGrp, $idTravail, $acronyme);
$listeEvaluations = $Files->getEvaluations4Travail($idTravail);
$infoTravail = $Files->getDataTravail($idTravail, $acronyme);
$competencesTravail = $Files->getCompetencesTravail($idTravail);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeEleves = $Ecole->listeElevesCours($coursGrp);
$photo = Ecole::photo($matricule);

// caractéristiques du fichier joint par l'élève
$fileInfos = $Files->getFileInfos($matricule, $idTravail, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR."/$module/templates";
$smarty->compile_dir = INSTALL_DIR."/$module/templates_c";

$smarty->assign('fileInfos', $fileInfos);
$listeCompetences = $Files->getCompetencesCoursGrp($coursGrp);

$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('idTravail', $idTravail);
$smarty->assign('matricule', $matricule);
$smarty->assign('listeCours', $listeCours);
$smarty->assign('listeTravaux', $listeTravaux);
$smarty->assign('listeTravauxRemis', $listeTravauxRemis);
$smarty->assign('listeEvaluations', $listeEvaluations);
$smarty->assign('competencesTravail', $competencesTravail);
$smarty->assign('infoTravail', $infoTravail);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('BASEDIR', BASEDIR);
$smarty->assign('photo', $photo);
$smarty->assign('listeCompetences', $listeCompetences);

$smarty->display('casier/evalTravaux.tpl');
