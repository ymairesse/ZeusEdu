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

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR."/inc/classes/class.Athena.php";

$anneeScolaire = isset($_GET['anneeScolaire']) ? $_GET['anneeScolaire'] : null;
$dateDebut = isset($_GET['dateDebut']) ? $_GET['dateDebut'] : null;
$dateFin = isset($_GET['dateFin']) ? $_GET['dateFin'] : null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('dateDebut', $dateDebut);
$smarty->assign('dateFin', $dateFin);

$dateDebut = Application::dateMySQL($dateDebut);
$dateFin = Application::dateMySQL($dateFin);
$elevesSuivis = Athena::getEleveUser($acronyme, $dateDebut, $dateFin, $anneeScolaire);
$elevesSuivis = $elevesSuivis[$anneeScolaire];

$smarty->assign('elevesSuivis', $elevesSuivis);
$smarty->assign('anneeScolaire', $anneeScolaire);
$nomCoach = $User->getNom($acronyme);
$smarty->assign('nomCoach', $nomCoach);

$DATE = $Application::dateNow();
$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $DATE);

require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
$html2pdf = new Html2PDF('P', 'A4', 'fr');

$listeEleves4PDF = $smarty->fetch('listeEleves4PDF.tpl');
$html2pdf->WriteHTML($listeEleves4PDF);
$html2pdf->Output('Athena_'.$acronyme.'.pdf');
