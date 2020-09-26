<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$laDate = isset($_POST['laDate']) ? $_POST['laDate'] : null;
$typeDoc = isset($_POST['typeDoc']) ? $_POST['typeDoc'] : null;
$signature = isset($_POST['signature']) ? $_POST['signature'] : null;

require_once '../../inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();
// retrouver le nom du module actif
$module = $Application->getModule(3);

// liste des élèves par classe
if ($typeDoc == 'competences') {
    $listeEleves = $Ecole->listeEleves($classe, 'groupe', false, true);
}
if ($typeDoc == 'pia') {
    $listeEleves = $Ecole->listeEleves($classe, 'groupe', false, true);
}

$listeCours = $Ecole->listeCoursClasse($classe);
$listeCompetences = $Bulletin->listeCompetencesListeCours($listeCours);
$sommeCotes = $Bulletin->sommeToutesCotes($listeEleves, $listeCours, $listeCompetences);

$listeAcquis = $Bulletin->listeAcquis($sommeCotes);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('acronyme', $acronyme);
$smarty->assign('module', $module);
$smarty->assign('classe', $classe);

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('listeCours', $listeCours);
$smarty->assign('listeCompetences', $listeCompetences);
$smarty->assign('listeAcquis', $listeAcquis);

$smarty->assign('laDate', $laDate);
$smarty->assign('typeDoc', $typeDoc);
$smarty->assign('signature', $signature);
$smarty->assign('DIRECTION', DIRECTION);
$smarty->assign('ECOLE', ECOLE);
$smarty->assign('ADRESSE', ADRESSE);
$smarty->assign('VILLE', VILLE);

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

foreach ($listeEleves as $matricule => $unEleve) {
    $smarty->assign('matricule', $matricule);
    $smarty->assign('unEleve', $unEleve);
    $doc4PDF = $smarty->fetch('direction/piaCompetences2pdf.tpl');
    $html2pdf->WriteHTML($doc4PDF);
}

$ds = DIRECTORY_SEPARATOR;

$nomFichier = sprintf('%s_%s.pdf', $typeDoc, $classe);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module;
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
}

$html2pdf->Output($chemin.$ds.$nomFichier, 'F');
$smarty->assign('nomFichier', $module.$ds.$nomFichier);

$link = $smarty->fetch('direction/lienDocument.tpl');
echo $link;
