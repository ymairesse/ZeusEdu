<?php

session_start();
require_once '../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class Presences
require_once '../inc/classes/classPresences.inc.php';
$Presences = new Presences();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$smarty->assign('matricule', $matricule);

$date = isset($_POST['date']) ? $_POST['date'] : null;
$mode = isset($_POST['mode']) ? $_POST['mode'] : null;

$dateSuivante = $Application->datesSuivantes($date, 1, false);
$dateSuivante = current($dateSuivante);
$smarty->assign('date', $dateSuivante);
$smarty->assign('mode', $mode);

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes', $listePeriodes);

$listeJustifications = $Presences->listeJustificationsAbsences();
$smarty->assign('listeJustifications', $listeJustifications);

$listeSpeed = $Presences->listeJustificationsAbsences(true, false, true);
$smarty->assign('listeSpeed', $listeSpeed);

$smarty->assign('listePresences', $Presences->listePresencesElevesDate($dateSuivante, $matricule));
// il s'agit d'un ajout d'un jour: ne pas remettre la ligne de titre du tableau
$smarty->assign('ajout', true);

echo $smarty->fetch('presencesJourDate.tpl');
