<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

require_once '../../inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// retrouver le nom du module actif
$module = $Application->getModule(3);

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$annee = isset($_POST['annee']) ? $_POST['annee'] : null;
$mois = isset($_POST['mois']) ? $_POST['mois'] : null;
$signature = isset($_POST['signature']) ? $_POST['signature'] : null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('acronyme', $acronyme);
$smarty->assign('classe', $classe);
$smarty->assign('mois', $mois);
$smarty->assign('annee', $annee);
$smarty->assign('DIRECTION', DIRECTION);
$smarty->assign('signature', $signature);
$smarty->assign('pathImages','../../');

require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
$html2pdf = new HTML2PDF('P', 'A4', 'fr');

$resultatsExternes = $Bulletin->getResultatsExternes($classe, ANNEESCOLAIRE);

require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
$html2pdf = new HTML2PDF('P', 'A4', 'fr');

foreach ($resultatsExternes as $matricule => $unEleve) {
    $smarty->assign('matricule', $matricule);
    $smarty->assign('unEleve', $unEleve);
    $nom = current($unEleve)['nom'].' '.current($unEleve)['prenom'];
    $smarty->assign('nomEleve', $nom);
    $classe = current($unEleve)['classe'];
    $smarty->assign('classe', $classe);
    $doc4PDF = $smarty->fetch('../../templates/direction/eprExt2pdf.tpl');
    $html2pdf->WriteHTML($doc4PDF);
}
$nomFichier = sprintf('doc_%s.pdf', $classe);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/$module/pdf/$acronyme/";
if (!(file_exists($chemin))) {
    mkdir(INSTALL_DIR."/$module/pdf/$acronyme");
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$link = $smarty->fetch('../../templates/direction/lienDocument.tpl');
echo $link;
