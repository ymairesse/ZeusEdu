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

// vérifier que l'utilisateur est propriétaire du travail
$id = $Files->verifProprietaireTravail($acronyme, $idTravail);

if ($id == $idTravail) {
    $listeCompetences = $Files->getCompetencesTravail($idTravail);
    $dataTravail = $Files->getDataTravail($idTravail, $acronyme);

    $bulletin = PERIODEENCOURS;
    $listePeriodes = range(0,NBPERIODES);

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('listeCompetences', $listeCompetences);
    $smarty->assign('dataTravail', $dataTravail);
    $smarty->assign('bulletin', $bulletin);
    $smarty->assign('listePeriodes', $listePeriodes);
    echo $smarty->fetch('casier/listeCompetences4carnet.tpl');
}
else echo "Ce travail ne vous appartient pas.";
