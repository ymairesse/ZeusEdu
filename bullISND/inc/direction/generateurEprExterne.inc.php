<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

// retrouver le nom du module actif
$module = $Application->getModule(3);
$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// retrouver le nom du module actif
$module = $Application->getModule(3);

$unAn = time() + 365 * 24 * 3600;
$classe = Application::postOrCookie('classe', $unAn);

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

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('P', 'A4', 'fr');

$resultatsExternes = $Bulletin->getResultatsExternes($classe, ANNEESCOLAIRE);

// une page d'entête pour la classe
$smarty->assign('classe', $classe);
$smarty->assign('titreDoc', 'Synthèse des épreuves externes');
$doc4PDF = $smarty->fetch('../../templates/direction/entetePageClasse2pdf.tpl');
$html2pdf->WriteHTML($doc4PDF);

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

$nomFichier = sprintf('eprExterne_%s.pdf', $classe);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/upload/$acronyme/bulletin/";
if (!(file_exists($chemin))) {
    mkdir(INSTALL_DIR."/$module/pdf/$acronyme", 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$smarty->assign('nomFichier', 'bulletin/'.$nomFichier);
$link = $smarty->fetch('../../templates/direction/lienDocument.tpl');
echo $link;
