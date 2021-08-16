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

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$Eleve = new Eleve($matricule);
$dataEleve = $Eleve->getDetailsEleve();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classInfirmerie.inc.php';
$Infirmerie = new Infirmerie();

// informations médicales importantes
$detailsEleve = $Infirmerie->getInfoMedic($matricule);
// informations médicales générales (médecin traitant,...)
$medicEleve = $Infirmerie->getMedicEleve($matricule);
// vistes de l'élève à l'informerie
$consultEleve = $Infirmerie->getVisitesEleve($matricule);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('matricule', $matricule);
$smarty->assign('dataEleve', $dataEleve);
$smarty->assign('titulaires', $titulaires);

$smarty->assign('infoMedic', $detailsEleve);
$smarty->assign('medicEleve', $medicEleve);
$smarty->assign('consultEleve', $consultEleve);

$html = $smarty->fetch('eleve.tpl');

echo json_encode(array('html' => $html, 'dataEleve' => $dataEleve));
