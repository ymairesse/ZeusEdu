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

$date = isset($_POST['date']) ? $_POST['date'] : Null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;

$start = $Application::dateMySql($date);
$endTime = new DateTime($start);
$endTime->add(new DateInterval('P1D'));
$end = $endTime->format('Y-m-d H:i:s');

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$categoriesTravaux = $Jdc->categoriesTravaux();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$listeEleves = $Ecole->listeElevesCours($coursGrp);
$listeCoursGrp4eleves = $Jdc->getListeCoursGrp4Eleves($listeEleves);

// recherche des événements pour chaque élève de la liste
foreach ($listeEleves AS $matricule => $eleve){
    $classe = $eleve['classe'];
    $niveau = substr($classe, 0, 1);
    $listeCoursEleve = $listeCoursGrp4eleves[$matricule];
    $listeCoursString = "'".implode("','", $listeCoursEleve)."'";
    $events4Eleve[$matricule] = $Jdc->retreiveEvents4Eleve($start, $end, $niveau, $classe, $matricule, $listeCoursString);
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('categories', $categoriesTravaux);
$smarty->assign('listeEleves', $listeEleves);

$smarty->assign('date', $date);
$smarty->assign('events', $events4Eleve);

$smarty->display('jdc/modal/modalCheckOthers.tpl');
