<?php

$eleve = new Eleve($matricule);
$dataEleve = $eleve->getDetailsEleve();
$smarty->assign('eleve', $dataEleve);

$classe = $dataEleve['groupe'];
$smarty->assign('classe', $classe);

$listeEleves = $Ecole->listeEleves($classe, 'groupe');
$smarty->assign('listeEleves', $listeEleves);

$prevNext = $Ecole->prevNext($matricule, $listeEleves);
$smarty->assign('prevNext', $prevNext);

$titulaires = $eleve->titulaires($matricule);
$smarty->assign('titulaires', $titulaires);

require_once INSTALL_DIR.'/infirmerie/inc/classes/classInfirmerie.inc.php';
$infirmerie = new eleveInfirmerie($matricule);

$smarty->assign('medicEleve', $infirmerie->getMedicEleve($matricule));
$smarty->assign('consultEleve', $infirmerie->getVisitesEleve($matricule));

$smarty->assign('noBulletin', PERIODEENCOURS);
$smarty->assign('listeBulletins', range(0, PERIODEENCOURS));

require_once INSTALL_DIR.'/ades/inc/classes/classEleveAdes.inc.php';
$EleveAdes = new EleveAdes();
$ficheDisciplinaire = $EleveAdes->getListeFaits($matricule);
$listeRetenuesEleve = $EleveAdes->getListeRetenuesEleve($matricule);

$smarty->assign('listeTousFaits', $ficheDisciplinaire);
$smarty->assign('listeRetenuesEleve', $listeRetenuesEleve);

$smarty->assign('nbFaits', $EleveAdes->nbFaits($matricule, ANNEESCOLAIRE));

require_once INSTALL_DIR.'/ades/inc/classes/classAdes.inc.php';
$Ades = new Ades();

$smarty->assign('listeTypesFaits', $Ades->listeTypesFaits());
$smarty->assign('descriptionChamps', $Ades->listeChamps());

require_once INSTALL_DIR.'/bullISND/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$athena = new Athena(null, $matricule);

switch ($mode) {
    case 'new':
        $smarty->assign('visite', null);
        $smarty->assign('listeProfs', $Ecole->listeProfs());
        $smarty->assign('proprietaire', $acronyme);
        $smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
        $smarty->assign('corpsPage', 'modifVisite');
        break;
    case 'edit':
        $id = isset($_POST['id']) ? $_POST['id'] : null;
        $visite = $athena->getDetailsSuivi($id, $acronyme);
        $smarty->assign('visite', $visite);
        $smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
        $smarty->assign('listeProfs', $Ecole->listeProfs());
        $smarty->assign('proprietaire', $acronyme);
        $smarty->assign('corpsPage', 'modifVisite');
        break;
    case 'enregistrer':
        $nb = $athena->saveSuiviEleve($_POST);
        $smarty->assign('message', array(
            'title' => SAVE,
            'texte' => sprintf("%d note(s) enregistrée(s)", $nb),
            'urgence' => 'success',
            ));
        $listeSuivi = $athena->getSuiviEleve($matricule);
        $smarty->assign('listeSuivi', $listeSuivi);
        $smarty->assign('listeProfs', $Ecole->listeProfs());
        $smarty->assign('corpsPage', 'ficheEleve');
        break;
    case 'delete':
        $nb = $athena->delSuiviEleve($_POST);
        $smarty->assign('message', array(
            'title' => DELETE,
            'texte' => "$nb note supprimée",
            'urgence' => 'warning',
            ));
        $listeSuivi = $athena->getSuiviEleve($matricule);
        $smarty->assign('listeSuivi', $listeSuivi);
        $smarty->assign('corpsPage', 'ficheEleve');
        break;
    default:
        $smarty->assign('listeProfs', $Ecole->listeProfs());
        $smarty->assign('ANNEEENCOURS', ANNEESCOLAIRE);

        $listeSuivi = $athena->getSuiviEleve($matricule);
        $smarty->assign('listeSuivi', $listeSuivi);
        if ($Bulletin->listeFullCoursGrpActuel($matricule) != Null) {
            $listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule)[$matricule];
            $smarty->assign('listeCoursGrp', $listeCoursActuelle);

            $syntheseAnneeEnCours = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);
            $smarty->assign('anneeEnCours', $syntheseAnneeEnCours);
        }
        else {
            $smarty->assign('listeCoursGrp', Null);
            $smarty->assign('anneeEnCours', Null);
        }
        $syntheseToutesAnnees = $Bulletin->syntheseToutesAnnees($matricule);
        $smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);

        $smarty->assign('ecoles', $eleve->ecoleOrigine());
        $smarty->assign('corpsPage', 'ficheEleve');
        break;
    }
