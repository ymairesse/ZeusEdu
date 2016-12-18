<?php

require_once '../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(2);
require_once INSTALL_DIR."/$module/inc/classes/classAthena.inc.php";

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$elevesSuivis = Athena::getEleveUser($acronyme);
$smarty->assign('elevesSuivis', $elevesSuivis);

$nomCoach = $User->getNom($acronyme);
$smarty->assign('nomCoach', $nomCoach);

$DATE = $Application::dateNow();
$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('TELEPHONE', TELEPHONE);
$smarty->assign('COMMUNE', COMMUNE);
$smarty->assign('DATE', $DATE);
$smarty->assign('BASEDIR', BASEDIR);
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
$html2pdf = new Html2PDF('P', 'A4', 'fr');

$listeEleves4PDF = $smarty->fetch('listeEleves4PDF.tpl');
$html2pdf->WriteHTML($listeEleves4PDF);
$html2pdf->Output('Athena_'.$DATE.'.pdf');
