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

$module = $Application::getmodule(3);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$mode = isset($_POST['mode']) ? $_POST['mode'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

require_once INSTALL_DIR.$ds.'inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$detailsEleve = $Eleve->getDetailsEleve();

$identite = $User->identite();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

// informations pour les grilles d'absences
$listePeriodes = $Presences->lirePeriodesCours();

// date et heure pour l'enregistrement
// en mode "speed", les informations de période, date et justification sont reprises
// telles qu'elles pour le prochain élève
$dateFrom = isset($_POST['dateFrom']) ? $_POST['dateFrom'] : Application::dateNow();
$smarty->assign('dateFrom', $dateFrom);
$dateTo = isset($_POST['dateTo']) ? $_POST['dateTo'] : Application::dateNow();
$smarty->assign('dateTo', $dateTo);
$periodeActuelle = $Presences->periodeActuelle($listePeriodes);
$periodeFrom = isset($_POST['periodeFrom']) ? $_POST['periodeFrom'] : $periodeActuelle;
$smarty->assign('periodeFrom', $periodeFrom);
$periodeTo = isset($_POST['periodeTo']) ? $_POST['periodeTo'] : $periodeActuelle;
$smarty->assign('periodeTo', $periodeTo);
$justification = isset($_POST['justification']) ? $_POST['justification'] : Null;
$smarty->assign('justification', $justification);

// liste des statuts d'absences possibles
$statutsAbs = $Presences->listeJustificationsAbsences();
$smarty->assign('statutsAbs', $statutsAbs);

$smarty->assign('eleve', $detailsEleve);
$smarty->assign('listePeriodes', $listePeriodes);

$smarty->assign('matricule', $matricule);
$smarty->assign('mode', $mode);
$smarty->assign('acronyme', $acronyme);
$smarty->assign('identite', $identite);

$smarty->display('absences/formulaireJustif.tpl');
