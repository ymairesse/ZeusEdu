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

$listeCours = $User->listeCoursProf();

$unAn = time() + 365 * 24 * 3600;
$coursGrp = Application::postOrCookie('coursGrp', $unAn);
$idTravail = Application::postOrCookie('idTravail', $unAn);
$showArchive = isset($_POST['showArchive']) ? $_POST['showArchive'] : Null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$dataTravail = $Files->getDataTravail($idTravail, $acronyme, $coursGrp);

// faut-il présenter les détails d'un travail archivé?
if (($showArchive == 'hide') && ($dataTravail['statut'] == 'archive')) {
    echo "<p class='avertissement'>Veuillez sélectionner un travail dans la colonne de gauche</p>";
    }
    else {
        $listeCompetences = $Files->getCompetencesCoursGrp($coursGrp);
        $listeStatuts = $Files->getDicoStatuts();

        require_once INSTALL_DIR.'/smarty/Smarty.class.php';
        $smarty = new Smarty();
        $smarty->template_dir = '../../templates';
        $smarty->compile_dir = '../../templates_c';

        $smarty->assign('dataTravail', $dataTravail);
        $smarty->assign('listeCompetences', $listeCompetences);
        $smarty->assign('listeStatuts', $listeStatuts);

        $smarty->display('casier/editTravail.tpl');
    }
