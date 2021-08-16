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

$dateDebut = isset($_POST['dateDebut']) ? $_POST['dateDebut'] : date("d/m/Y");
$dateFin = isset($_POST['dateFin']) ? $_POST['dateFin'] : date("d/m/Y");

$dateDebutSQL = Application::dateMySql($dateDebut);
$dateFinSQL = Application::dateMySql($dateFin);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classInfirmerie.inc.php';
$Infirmerie = new Infirmerie();

$listeVisites = $Infirmerie->listeVisitesParDate($dateDebutSQL, $dateFinSQL);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';

$listePhotos = array();
foreach ($listeVisites AS $date => $dataDate){
    foreach ($dataDate AS $matricule => $dataConsult){
            $listePhotos[$matricule] = Ecole::photo($matricule);
        }
    }

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('listeVisites', $listeVisites);
$smarty->assign('listePhotos', $listePhotos);
$smarty->assign('dateDebut', $dateDebut);
$smarty->assign('dateFin', $dateFin);

$smarty->display('listesParDates.tpl');
