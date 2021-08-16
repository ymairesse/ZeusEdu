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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$consultID = isset($_POST['consultID']) ? $_POST['consultID'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classInfirmerie.inc.php';
$Infirmerie = new Infirmerie();

$visite = ($consultID != Null) ? $Infirmerie->getVisitesEleve($matricule, $consultID) : Null;
if ($visite != Null){
    $visite = $visite[$consultID];
    $visite['date'] = Application::datePHP($visite['date']);
}

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$dataEleve = $Eleve->getDetailsEleve();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeProfs = $Ecole->listeProfs();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('visite', $visite);
$smarty->assign('consultID', $consultID);
$smarty->assign('dataEleve', $dataEleve);
$smarty->assign('listeProfs', $listeProfs);

$smarty->display('modal/modalEditVisite.tpl');
