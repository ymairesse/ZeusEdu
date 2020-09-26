<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class User pour récupérer le nom d'utilisateur depuis la session
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

// définition de la class Ecole
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

// fonctions à passer dans la class Bulletin
// require_once 'fonctionsBulletin.inc.php';

$unAn = time() + 365 * 24 * 3600;
$classe = Application::postOrCookie('classe', $unAn);

// année d'étude actuelle (année de fin de degré)
$anneeEtude = $Ecole->anneeDeClasse($classe);
$anneeEtudePrecedente = $Ecole->anneePrecedenteDeClasse($classe);

// année scolaire en cours (du type "2016-2017")
$anneeScolaire = ANNEESCOLAIRE;

require INSTALL_DIR.'/vendor/autoload.php';
use Spipu\Html2Pdf\Html2Pdf;

$html2pdf = new Html2Pdf('L', 'A4', 'fr');

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$listeEleves = $Ecole->listeElevesClasse($classe);

// informations pour l'année scolaire en cours
$infoAnneeScolaire = $Bulletin->resultatsTousCours($listeEleves, NBPERIODES);
$infoEprExterne = $Bulletin->getResultatsExternes($classe, $anneeScolaire);
$infoMentions = $Bulletin->listeSimpleMentions($listeEleves, NBPERIODES, $anneeScolaire);
$listeDecisions = $Bulletin->listeDecisions($listeEleves);

// année scolaire précédente !! pour les élèves redoublants,
// l'année scolaire précédente est celle où il étaient dans l'année d'étude précédente
$anneesScolairesPrecedentes = $Bulletin->anneesScolairesPrecedentes($listeEleves, $anneeEtudePrecedente);
// recherche du nombre de périodes pour chacune des années scolaires précédentes de chaque élève
// ajouter le nombre de périodes durant cette année scolaire (afin de savoir le numéro de la dernière)
$nbPeriodes = $Bulletin->nbPeriodesAnScol($anneesScolairesPrecedentes);
foreach ($anneesScolairesPrecedentes as $matricule => $data) {
    $anScol = $data['anScol'];
    $anneesScolairesPrecedentes[$matricule]['nbPeriodes'] = $nbPeriodes[$anScol];
}

// une page d'entête pour la classe
$smarty->assign('classe', $classe);
$smarty->assign('titreDoc', 'Récapitulatif du degré');
$doc4PDF = $smarty->fetch('../../templates/direction/entetePageClasse2pdf.tpl');
$html2pdf->WriteHTML($doc4PDF);

$smarty->assign('anneeEtude', $anneeEtude);
$smarty->assign('anneeEtudePrecedente', $anneeEtudePrecedente);
$smarty->assign('anneeScolaire', $anneeScolaire);

foreach ($listeEleves as $matricule => $dataEleve) {
    $smarty->assign('dataEleve', $dataEleve);
    // passer les informations si on les connaît (nouveaux élèves?)
    if (isset($anneesScolairesPrecedentes[$matricule])) {
        $smarty->assign('anneeScolairePrecedente', $anneesScolairesPrecedentes[$matricule]);
        $infoAnneePrecedente = $Bulletin->infoAnneePrecedente($matricule, $anneesScolairesPrecedentes);
        $tdWidthPrec = (int) (100 / count($infoAnneePrecedente));
        $smarty->assign('tdWidthPrec', $tdWidthPrec);
        $smarty->assign('infoAnneePrecedente', $infoAnneePrecedente);
    }
    else $smarty->assign('anneeScolairePrecedente', Null);

    $tdWidthAct = (int) (100 / count($infoAnneeScolaire[$matricule]));
    $smarty->assign('tdWidthAct', $tdWidthAct);
    $smarty->assign('infoAnneeScolaire', $infoAnneeScolaire[$matricule]);
    $tdWidthCE1D = (int) (100 / count($infoEprExterne[$matricule]));
    $smarty->assign('tdWidthCE1D', $tdWidthCE1D);
    $smarty->assign('infoEprExterne', $infoEprExterne[$matricule]);
    $smarty->assign('infoMention', $infoMentions[$matricule]);
    $critere = $listeDecisions[$matricule]['decision'];
    switch ($critere) {
        case '':
            $decision = '---';
            break;
        case 'Échec':
            $decision = 'NON';
            break;
        case 'Réussite':
            $decision = 'OUI';
            break;
        case 'Restriction':
            $decision = 'NON';
            break;
        default:
            $decision = 'NOSE';
            break;
    }
    $smarty->assign('decision', $decision);

    $doc4PDF = $smarty->fetch('../../templates/direction/recap2pdf.tpl');
    $html2pdf->WriteHTML($doc4PDF);

}

$nomFichier = sprintf('recapitulatif_%s.pdf', $classe);

// création éventuelle du répertoire au nom de l'utlilisateur
$chemin = INSTALL_DIR."/upload/$acronyme/bulletin/";
if (!(file_exists($chemin))) {
    mkdir(INSTALL_DIR."/upload/$acronyme/bulletin/", 0700, true);
}

$html2pdf->Output($chemin.$nomFichier, 'F');

$smarty->assign('nomFichier', 'bulletin/'.$nomFichier);
$link = $smarty->fetch('../../templates/direction/lienDocument.tpl');
echo $link;
