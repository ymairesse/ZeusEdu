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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$anneeScolaire = isset($form['anneeScolaire']) ? $form['anneeScolaire'] : null;
$dateDebut = isset($form['debut']) ? $form['debut'] : null;
$dateFin = isset($form['fin']) ? $form['fin'] : null;
$tri = isset($form['tri']) ? $form['tri'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('dateDebut', $dateDebut);
$smarty->assign('dateFin', $dateFin);

$debut = Application::dateMySQL($dateDebut);
$fin = Application::dateMySQL($dateFin);

require_once INSTALL_DIR.'/inc/classes/class.Athena.php';

$elevesSuivis = Athena::getEleveUser($acronyme, $debut, $fin, $tri, $anneeScolaire);
if (isset($elevesSuivis[$anneeScolaire]))
    $elevesSuivis = $elevesSuivis[$anneeScolaire];
    else $elevesSuivis = Null;

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


$listeEleves4PDF = $smarty->fetch('listeEleves4PDF.tpl');

require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
$html2pdf = new Html2PDF('P', 'A4', 'fr');

$html2pdf->WriteHTML($listeEleves4PDF);

$nomFichier = 'Athena_'.$acronyme.'.pdf';
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
}

$html2pdf->Output($chemin.$nomFichier,'F');

echo sprintf('<p>Vous pouvez récupérer le document au format PDF en cliquant <a target="_blank" id="celien" href="inc/download.php?type=pfN&amp;f=%s/%s">sur ce lien</a></p>', $module, $nomFichier);
