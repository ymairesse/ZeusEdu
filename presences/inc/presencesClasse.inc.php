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

$module = $Application->getModule(2);

$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$date = isset($_POST['date']) ? $_POST['date'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$userStatus = $User->getStatus4appli($module);
$smarty->assign('userStatus', $userStatus);

$photosVis = isset($_COOKIE['photosVis']) ? $_COOKIE['photosVis'] : null;
$smarty->assign('photosVis', $photosVis);

if ($date == Null)
    $date = strftime('%d/%m/%Y');
$smarty->assign('date', $date);
$jourSemaine = ucfirst(strftime('%A', $Application->dateFR2Time($date)));
$smarty->assign('dateFr', $jourSemaine.', le '.$date);

$titusClasse = $Ecole->titusDeGroupe($classe);
$smarty->assign('titusClasse', $titusClasse);
$smarty->assign('classe', $classe);

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes', $listePeriodes);
$lesPeriodes = range(1, count($listePeriodes));
$smarty->assign('lesPeriodes', $lesPeriodes);

$periode = isset($_POST['periode']) ? $_POST['periode'] : $Presences->periodeActuelle($listePeriodes);
$smarty->assign('periode', $periode);

$smarty->assign('acronyme', $acronyme);

$listeEleves = $Ecole->listeElevesClasse($classe);
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('nbEleves', count($listeEleves));

// quelles sont les mentions d'absences accessibles (en principe, NP, ABS, PRES)
$justifications = $Presences->listeJustificationsAbsences(false);
$smarty->assign('justifications', $justifications);

$listeJustifications = $Presences->listeJustificationsAbsences(true);
$smarty->assign('listeJustifications', $listeJustifications);

$listePresences = $Presences->listePresencesElevesDate($date, $listeEleves);
$listePresences = isset($listePresences) ? $listePresences : null;
$smarty->assign('listePresences', $listePresences);

$statutsAbs = $Presences->listeJustificationsAbsences();
$smarty->assign('statutsAbs', $statutsAbs);

$smarty->display('feuillePresencesClasse.tpl');
