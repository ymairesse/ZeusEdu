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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

// informations médicales
require_once INSTALL_DIR.'/infirmerie/inc/classes/classInfirmerie.inc.php';
$infirmerie = new eleveInfirmerie($matricule);

$smarty->assign('medicEleve', $infirmerie->getMedicEleve($matricule));
$smarty->assign('consultEleve', $infirmerie->getVisitesEleve($matricule));

require_once INSTALL_DIR."/inc/classes/classEleve.inc.php";
$eleve = new Eleve($matricule);

$detailsEleve = $eleve->getDetailsEleve();
$nomEleve = sprintf('%s_%s_%s', $detailsEleve['nom'], $detailsEleve['prenom'], $detailsEleve['groupe']);
$classe = $detailsEleve['groupe'];

$smarty->assign('nomEleve', $nomEleve);

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

$fichierHtml = $smarty->fetch('direction/pad/visitesInfirmerie.print.tpl');

$html2pdf->WriteHTML($fichierHtml);

$nomFichier = 'infirmerie_'.$nomEleve.'.pdf';

$ds = DIRECTORY_SEPARATOR;
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$chemin = $ds.$module.$ds;
echo $chemin.$nomFichier;
