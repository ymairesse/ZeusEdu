<?php

require_once '../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$anScol = isset($_GET['anScol']) ? $_GET['anScol'] : null;
$matricule = isset($_GET['matricule']) ? $_GET['matricule'] : null;

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$eleve = new Eleve($matricule);
$Eleve = $eleve->getDetailsEleve();

$module = $Application->getModule(2);
require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes($matricule);

$listeFaits = $EleveAdes->getListeFaits($matricule)[$anScol];
$listeRetenues = $EleveAdes->getListeRetenuesEleve($matricule);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();
$listeTypesFaits = $Ades->listeTypesFaits();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $Application->dateNow());
$smarty->assign('BASEDIR', BASEDIR);
$smarty->assign('ANNEESCOLAIRE', $anScol);

$smarty->assign('Eleve', $Eleve);
$smarty->assign('listeFaits', $listeFaits);
$smarty->assign('listeRetenues', $listeRetenues);
$smarty->assign('listeTypesFaits', $listeTypesFaits);
$descriptionChamps = $Ades->listeChamps();

$smarty->assign('descriptionChamps', $descriptionChamps);
define('PAGEWIDTH', 600);
$echelles = $Ades->fieldWidth(PAGEWIDTH, $listeTypesFaits, $descriptionChamps);
$smarty->assign('echelles', $echelles);
$smarty->assign('contexte', 'tableau');

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

$ficheEleve4PDF = $smarty->fetch('eleve/ficheEleve4PDF.tpl');
$html2pdf->WriteHTML($ficheEleve4PDF);
$html2pdf->Output('fiche'.$matricule.'.pdf');
