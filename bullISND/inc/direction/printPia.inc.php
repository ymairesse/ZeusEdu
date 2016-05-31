<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$listeEleves = isset($_POST['listeEleves']) ? $_POST['listeEleves'] : null;

require_once '../../inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

if (!isset($_SESSION[APPLICATION])) {
    die("<p><strong>Votre session est expirée. Veuillez vous reconnecter.</strong></p>");
    exit();
    }

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();
// retrouver le nom du module actif
$module = $Application->getModule(3);
$bulletin = PERIODEENCOURS;

require_once INSTALL_DIR.'/infirmerie/inc/classes/classInfirmerie.inc.php';
require_once (INSTALL_DIR.'/inc/classes/classEleve.inc.php');

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

require_once INSTALL_DIR.'/html2pdf/html2pdf.class.php';
$html2pdf = new HTML2PDF('P', 'A4', 'fr');

$smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));

foreach ($listeEleves as $matricule) {
    $Eleve = new Eleve($matricule);
    $detailsEleve = $Eleve->getDetailsEleve();
    $degre = $Ecole->degreDeClasse($detailsEleve['groupe']);
    $ceb = ($degre == 1) ? $Bulletin->getCEB($matricule) : null;
    $infirmerie = new eleveInfirmerie($matricule);
    $infosMedic = $infirmerie->getInfoMedic($matricule);
    $resultatsPre = $Bulletin->syntheseToutesAnnees($matricule);
    $listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin);
    $listeCoursGrp = $listeCoursGrp[$matricule];
    $listeProfs = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);
    $listeMails = $Ecole->listeMailsEleves($listeEleves);
    if ($resultatsPre != null) {
        //millésimes de l'année précédente
        $anPrec = array_keys($resultatsPre);
        $anPrec = $anPrec[0];
        $anScolaire = $anPrec;
        // année d'étude précédente
        $resultatsPre = array_shift($resultatsPre);
        $niveauPre = array_keys($resultatsPre);
        $niveauPre = $niveauPre[0];
        $annee = $niveauPre;
        // les résultats rien que pour l'année précédente
        $resultatsPrec = array_shift($resultatsPre);
        // les mentions obtenues
        $mentions = $Bulletin->listeMentions($matricule, null, null, ANNEESCOLAIRE);
    } else {
        $anScolaire = null;
        $niveauPre = null;
        $resultatsPrec = null;
        $mentions = null;
    }
    $eleve = array(
        'detailsEleve' => $detailsEleve,
        'degre' => $degre,
        'ceb' => $ceb,
        'annee' => $niveauPre,
        'anScolaire' => $anScolaire,
        'listeCoursActuelle' => $listeCoursGrp,
        'infosMedic' => $infosMedic,
        'resultats' => $resultatsPrec['resultats'],
        'listeCours' => $resultatsPrec['listeCours'],
        'listeProfs' => $listeProfs,
        'mentions' => $mentions,
        );

    $smarty->assign('eleve', $eleve);
    $doc4PDF = $smarty->fetch('../../templates/direction/pia2pdf.tpl');
    $html2pdf->WriteHTML($doc4PDF);
}

$nomFichier = sprintf('doc_%s.pdf', $classe);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/$module/pdf/$acronyme/";
if (!(file_exists($chemin))) {
    mkdir(INSTALL_DIR."/$module/pdf/$acronyme");
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$smarty->assign('acronyme',$acronyme);
$smarty->assign('classe',$classe);
$link = $smarty->fetch('../../templates/direction/lienDocument.tpl');
echo $link;
