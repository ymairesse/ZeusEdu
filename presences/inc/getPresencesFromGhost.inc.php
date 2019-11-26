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
$userStatus = $User->getStatus4appli($module);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classPresences.inc.php';
$Presences = new Presences();

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$date = isset($_POST['laDate']) ? $_POST['laDate'] : Null;
$date = Application::datePHP($date);
$heure = isset($_POST['heure']) ? $_POST['heure'] : Null;

// recherche de la période de cours correspondant à l'heure de début
$listePeriodes = $Presences->lirePeriodesCours();
$periode = 0; $trouve = false;
$hMax = count($listePeriodes);
while ($periode <= $hMax && !($trouve)) {
    $periode++;
    if ($listePeriodes[$periode]['debut'] >= $heure)
        $trouve = true;
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('periode', $periode);

$smarty->assign('date', $date);
$jourSemaine = ucfirst(strftime('%A', $Application->dateFR2Time($date)));
$smarty->assign('dateFr', $jourSemaine.', le '.$date);

$smarty->assign('acronyme', $acronyme);
$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('userStatus', $userStatus);

$detailsCours = $Ecole->detailsCours($coursGrp);
$smarty->assign('detailsCours', $detailsCours);

$prof = $User->identite();
$smarty->assign('prof', $prof);

$photosVis = isset($_COOKIE['photosVis']) ? $_COOKIE['photosVis'] : null;
$smarty->assign('photosVis', $photosVis);

$jourSemaine = strftime('%A', $Application->dateFR2Time($date));
$smarty->assign('jourSemaine', $jourSemaine);

$smarty->assign('listePeriodes', $listePeriodes);
$lesPeriodes = range(1, count($listePeriodes));
$smarty->assign('lesPeriodes', $lesPeriodes);

$listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha');
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

$smarty->display('feuillePresencesCours.tpl');
