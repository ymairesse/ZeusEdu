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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.$ds.'inc/classes/classEleve.inc.php';

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('module', $module);

$startDate =  $form['debut'];
$endDate =  $form['fin'];

$matricule = $form['matricule'];
$smarty->assign('matricule', $matricule);

$listeCategories = $form['idCategories'];

$DATE = $Application::dateNow();
$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $DATE);
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
$smarty->assign('dateDebut', $startDate);
$smarty->assign('dateFin', $endDate);


$listeCoursGrp = $Ecole->listeCoursGrpEleve($matricule);
$identite = Eleve::staticGetDetailsEleve($matricule);
// relire l'historique pour l'élève et fusionner avec la liste des coursGrp
$historique = $Jdc->getHistorique($matricule, true);
foreach ($historique as $coursGrp => $data) {
    $listeCoursGrp[$coursGrp] = $data;
    }

$jdcExtract = $Jdc->jdcFromTo($startDate, $endDate, $listeCoursGrp, $listeCategories, ANNEESCOLAIRE);
$smarty->assign('jdcExtract', $jdcExtract);

$nomPrenomClasse = sprintf('%s %s (classe: %s)', $identite['nom'], $identite['prenom'], $identite['classe']);
$smarty->assign('nomPrenomClasse', $nomPrenomClasse);

$jdc4PDF = $smarty->fetch('jdc/jdc4PDF.tpl');

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

// pour éviter l'erreur "le contenu d'une balise TD ne rentre pas sur une seule page"
$html2pdf->setTestTdInOnePage(false);

$html2pdf->WriteHTML($jdc4PDF);

$nomFichier = sprintf('%s_%s_%d', $identite['nom'], $identite['prenom'], $identite['matricule']);
$smarty->assign('nomFichier', $nomFichier.'.pdf');

$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
    }

$nomFichierPDF = $chemin.$ds.$nomFichier.'.pdf';

$html2pdf->Output($nomFichierPDF, 'F');

$smarty->display('jdc/inc/trArchive.tpl');
