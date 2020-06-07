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

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR."/inc/classes/classEleve.inc.php";
$eleve = new Eleve($matricule);

require_once INSTALL_DIR.'/bullISND/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
$padEleve = new padEleve($matricule, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$detailsEleve = $eleve->getDetailsEleve();
$nomEleve = sprintf('%s_%s_%s', $detailsEleve['nom'], $detailsEleve['prenom'], $detailsEleve['groupe']);
$classe = $detailsEleve['groupe'];

$smarty->assign('classe', $classe);
$smarty->assign('matricule', $matricule);
$smarty->assign('nomEleve', $nomEleve);

// recherche des infos concernant le passé scolaire
$smarty->assign('ecoles', $eleve->ecoleOrigine());

// le CEB
$smarty->assign('degre', $Ecole->degreDeClasse($eleve->groupe()));
$smarty->assign('ceb', $Bulletin->getCEB($matricule));

// recherche des cotes de situation et délibé éventuelle pour toutes les périodes de l'année en cours
$listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule);
if ($listeCoursActuelle != Null)
    $listeCoursActuelle = $listeCoursActuelle[$matricule];
$smarty->assign('listeCoursGrp', $listeCoursActuelle);

// recherche des correspondances entre acronyme et nom des profs
$dicoProfs = $padEleve->dicoProfs();
$smarty->assign('dicoProfs', $dicoProfs);

// feuille de synthèse pour l'année scolaire en cours
$syntheseAnneeEnCours = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);
$smarty->assign('anneeEnCours', $syntheseAnneeEnCours);
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

// tableau de synthèse de toutes les cotes de situation pour toutes les années scolaires
$syntheseToutesAnnees = $Bulletin->syntheseToutesAnnees($matricule);
$smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);

$mentions = $Bulletin->listeMentions($matricule);
$smarty->assign('mentions', $mentions);

// $smarty->assign('listeCoursActuelle', $listeCoursActuelle);

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('L', 'A4', 'fr');

$fichierHtml = $smarty->fetch('direction/pad/tabEleve2.print.tpl');

$html2pdf->WriteHTML($fichierHtml);

$nomFichier = 'scolaire_'.$nomEleve.'.pdf';

$ds = DIRECTORY_SEPARATOR;
$chemin = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds;
// créer le répetoire s'il n'existe pas encore
if (!(file_exists($chemin))) {
    mkdir($chemin, 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$chemin = $ds.$module.$ds;
echo $chemin.$nomFichier;
