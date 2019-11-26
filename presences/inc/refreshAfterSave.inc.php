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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$date = isset($_POST['date']) ? $_POST['date'] : Null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : Null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

// on a pris les présences pour un coursGrp ou pour une classe
if ($coursGrp != Null)
    $listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha', false);
    else $listeEleves = $Ecole->listeElevesClasse($classe, false);

$smarty->assign('listeEleves', $listeEleves);

$photosVis = isset($_COOKIE['photosVis']) ? $_COOKIE['photosVis'] : null;
$smarty->assign('photosVis', $photosVis);

$smarty->assign('date', $date);
$jourSemaine = ucfirst(strftime('%A', $Application->dateFR2Time($date)));
$smarty->assign('dateFr', $jourSemaine.', le '.$date);

$listePeriodes = $Presences->lirePeriodesCours();
$lesPeriodes = range(1, count($listePeriodes));
$smarty->assign('lesPeriodes', $lesPeriodes);

$smarty->assign('periode', $periode);

$smarty->assign('acronyme', $acronyme);
$smarty->assign('coursGrp', $coursGrp);


// quelles sont les mentions d'absences accessibles (en principe, NP, ABS, PRES)
$justifications = $Presences->listeJustificationsAbsences(false);
$smarty->assign('justifications', $justifications);

$listeJustifications = $Presences->listeJustificationsAbsences(true);
$smarty->assign('listeJustifications', $listeJustifications);

$listePresences = $Presences->listePresencesElevesDate($date, $listeEleves);
$smarty->assign('listePresences', $listePresences);

$smarty->display('listeDouble.tpl');
