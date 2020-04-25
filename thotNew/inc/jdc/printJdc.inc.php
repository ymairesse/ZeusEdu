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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

$dateDebut = $form['from'];
$dateFin = $form['to'];
$coursGrp = $form['coursGrp'];

$jdcExtract = $Jdc->fromToJDCList($form, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

if ($coursGrp == 'all')
    $smarty->assign('coursGrp', 'Tous les cours');
    else {
        require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
        $Ecole = new Ecole();
        $detailsCours = $Ecole->detailsCours($coursGrp);
        $cours = sprintf('%s %sh [%s]', $detailsCours['libelle'], $detailsCours['nbheures'], $coursGrp);
        $smarty->assign('coursGrp', $cours);
    }

$DATE = $Application::dateNow();
$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $DATE);
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
$smarty->assign('dateDebut', $dateDebut);
$smarty->assign('dateFin', $dateFin);

$userName = implode(' ', $User->getNom());
$smarty->assign('userName', $userName);

$smarty->assign('jdcExtract', $jdcExtract);

$jdc4PDF = $smarty->fetch('jdc/jdc4PDF.tpl');

// define('PAGEWIDTH', 700);

require_once INSTALL_DIR.$ds.'html2PDF/vendor/autoload.php';

// use Spipu\Html2Pdf\Html2Pdf;
// use Spipu\Html2Pdf\Exception\Html2PdfException;
// use Spipu\Html2Pdf\Exception\ExceptionFormatter;

$html2pdf = new \Spipu\Html2Pdf\Html2Pdf('P', 'A4', 'fr');

$html2pdf->WriteHTML($jdc4PDF);

$nomFichier = 'jdc_'.$acronyme.'_'.$coursGrp.'.pdf';
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
}

$html2pdf->Output($chemin.$nomFichier,'F');

echo sprintf('<p>Vous pouvez récupérer le document au format PDF en cliquant <a target="_blank" id="celien" href="inc/download.php?type=pfN&amp;f=/%s/%s">sur ce lien</a></p>', $module, $nomFichier);
