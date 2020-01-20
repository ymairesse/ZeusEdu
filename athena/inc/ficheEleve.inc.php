<?php

$eleve = new Eleve($matricule);
$dataEleve = $eleve->getDetailsEleve();
$smarty->assign('eleve', $dataEleve);

$titulaires = $eleve->titulaires($matricule);
$smarty->assign('titulaires', $titulaires);

// informations médicales
require_once INSTALL_DIR.'/infirmerie/inc/classes/classInfirmerie.inc.php';
$infirmerie = new eleveInfirmerie($matricule);

$smarty->assign('medicEleve', $infirmerie->getMedicEleve($matricule));
$smarty->assign('consultEleve', $infirmerie->getVisitesEleve($matricule));

$smarty->assign('noBulletin', PERIODEENCOURS);
$smarty->assign('listeBulletins', range(0, PERIODEENCOURS));

$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

// // informations disciplinaires
require_once INSTALL_DIR.'/ades/inc/classes/classEleveAdes.inc.php';
$EleveAdes = new EleveAdes();
$smarty->assign('nbFaits', $EleveAdes->nbFaits($matricule, ANNEESCOLAIRE));

// le bulletin
require_once INSTALL_DIR.'/bullISND/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$athena = new Athena(null, $matricule);

// va-t-on exposer les informations de l'élève $matricule?
$getDataEleve = false;

switch ($mode) {
    case 'new':
        $visite = Null;
        $smarty->assign('listeProfs', $Ecole->listeProfs());
        $smarty->assign('proprietaire', $acronyme);
        $smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
        $smarty->assign('visite', $visite);
        $smarty->assign('corpsPage', 'modifVisite');
        break;
    case 'edit':
        $id = isset($_POST['id']) ? $_POST['id'] : null;
        $visite = $athena->getDetailsSuivi($id, $acronyme);
        $smarty->assign('listeProfs', $Ecole->listeProfs());
        $smarty->assign('proprietaire', $acronyme);
        $smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
        $smarty->assign('visite', $visite);
        $smarty->assign('corpsPage', 'modifVisite');
        break;

    case 'delete':
        $nb = $athena->delSuiviEleve($_POST);
        $smarty->assign('message', array(
            'title' => DELETE,
            'texte' => "$nb note supprimée",
            'urgence' => 'warning',
            ));
        $getDataEleve = true;
        break;
        
    case 'enregistrer':
        $nb = $athena->saveSuiviEleve($_POST);
        $smarty->assign('message', array(
            'title' => SAVE,
            'texte' => sprintf("%d note(s) enregistrée(s)", $nb),
            'urgence' => 'success',
            ));
        $getDataEleve = true;
        break;
    default:
        $getDataEleve = true;
        break;
    }

if ($getDataEleve == true) {
    $smarty->assign('listeProfs', $Ecole->listeProfs());

    $listeSuivi = $athena->getSuiviEleve($matricule);
    $smarty->assign('listeSuivi', $listeSuivi);

    // Élèves à besoins spécifiques
    $infoEBS = $athena->getEBSeleve($matricule);

    $listeTroubles = $athena->getTroublesEBS();
    $listeAmenagements = $athena->getAmenagementsEBS();
    $smarty->assign('infoEBS', $infoEBS);
    $smarty->assign('listeTroubles', $listeTroubles);
    $smarty->assign('listeAmenagements', $listeAmenagements);

    $smarty->assign('corpsPage', 'ficheEleve');
}
