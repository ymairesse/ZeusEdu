<?php

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;
$niveauEleves = isset($_POST['niveauEleves']) ? $_POST['niveauEleves'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
$cours = isset($_POST['cours']) ? $_POST['cours'] : null;
$bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : PERIODEENCOURS;
$periode = isset($_POST['periode']) ? $_POST['periode'] : PERIODEENCOURS;
$classe = isset($_POST['classe']) ? $_POST['classe'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : null;
$etape = isset($_POST['etape']) ? $_POST['etape'] : null;

switch ($mode) {
    case 'verrouTabs':
        if (isset($niveau) && ($niveau != '')) {
            $listeClasses = $Ecole->listeClassesNiveau($niveau);
        }
        else $listeClasses = Null;
        $listeNiveaux = $Ecole->listeNiveaux();
        $listePeriodes = $Bulletin->listePeriodes(NBPERIODES);
        $arrayNomsPeriodes = explode(',', NOMSPERIODES);
        $smarty->assign('listePeriodes', $listePeriodes);
        $smarty->assign('nomsPeriodes', $arrayNomsPeriodes);
        $smarty->assign('listeClasses', $listeClasses);
        $smarty->assign('listeNiveaux', $listeNiveaux);
        $smarty->assign('niveau', $niveau);
        $smarty->assign('periode', $periode);
        $smarty->assign('selecteur', 'selecteurs/selectNiveauPeriode');
        $smarty->assign('corpsPage', 'admin/verrouTabs');
        break;

    case 'eprExternes':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        // sélection d'un cours pour lequel il faut initialiser la table des épreuves externes
        // Sélection du niveau d'étude pour ce cours...
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('listeNiveaux', Ecole::listeNiveaux());
        $smarty->assign('niveau', $niveau);
        $smarty->assign('selecteur', 'selectNiveau');
        // établir la liste de tous les cours possibles pour ce niveau d'étude
        if (($niveau != null)) {
            // liste de tous les cours suivis par des élèves à ce niveau
            $smarty->assign('listeCoursNiveau', $Bulletin->listeCoursSuivisNiveau($niveau));

            $smarty->assign('etape', 'enregistrement');

            // recherche de tous les coursGrp pour le cours sélectionné	et initialisation de la table pour le cours choisi
            if (isset($cours) && ($etape == 'enregistrement')) {
                $listeElevesCoursGrp = $Bulletin->elevesCoursGrpDeCours($cours);
                // initisalisation de la table dans laquelle les profs pourront rapporter les
                // résultats des épreuves externes
                $nb = $Bulletin->initEpreuvesExternes($listeElevesCoursGrp, ANNEESCOLAIRE);
                $smarty->assign('message', array(
                                'title' => 'Enregistrement',
                                'texte' => sprintf('%d enregistrement(s) effectué(s)', $nb),
                                'urgence' => 'success', )
                                );
            }

            // liste des cours à épreuve externe défjà définis, pour affichage sur la page
            $smarty->assign('listeCours', $Bulletin->listeCoursEpreuveExterne($niveau, ANNEESCOLAIRE));
            // nombre de cotes déjà attribuées par coursGrp (nécessaire pour savoir si la suppression est possible)
            $smarty->assign('nbCotesExtCoursGrp', $Bulletin->nbCotesExtCoursGrp($niveau));
            $smarty->assign('cours', $cours);
            $smarty->assign('corpsPage', 'initEprExternes');
        }
        break;

    case 'remplacants':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        $profsParCours = $Ecole->listeCoursGrpProf($Ecole->listeNiveaux());
        $listeRemplacements = $Ecole->listeRemplacants($profsParCours);
        $listeProfs = $Ecole->listeProfs();
        $smarty->assign('listeRemplacements', $listeRemplacements);
        $smarty->assign('listeProfs', $listeProfs);
        $smarty->assign('listeCoursEleves', $Ecole->listeCours($Ecole->listeNiveaux()));
        $smarty->assign('corpsPage', 'remplacants');
        break;

    case 'interim':
        if ($etape == 'enregistrer') {
            $interim = isset($_POST['interim']) ? $_POST['interim'] : null;
            $listeCours = isset($_POST['cours']) ? $_POST['cours'] : null;
            $nb = $Ecole->saveInterim($interim, $listeCours);
            $smarty->assign('message', array(
                            'title' => SAVE,
                            'texte' => sprintf('%d enregistrement(s) effectué(s)', $nb),
                            'urgence' => 'success', )
                            );
        }
        $listeProfs = $Application->listeProfs(true);
        $listeInterims = $Application->listeProfs(false);
        $smarty->assign('listeProfs', $listeProfs);
        $smarty->assign('listeInterims', $listeInterims);

        $smarty->assign('corpsPage', 'users/interim');
        break;

    case 'attributionsProfs':
        if ($userStatus != 'admin') {
            die('get out of here');
        }

        $etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
        switch ($etape) {
            case 'addProfs':
                $addProf = isset($_POST['addProf']) ? $_POST['addProf'] : null;
                $virtuel = $Ecole->isVirtuel($coursGrp);
                $nbInsert = $Ecole->ajouterProfsCoursGrp($addProf, $coursGrp, $virtuel);
                $smarty->assign('message', array(
                                    'title' => 'Enregistrement',
                                    'texte' => "$nbInsert modification(s)",
                                    'urgence' => 'info', )
                                );
                break;
            case 'supprProfs':
                $supprProf = isset($_POST['supprProf']) ? $_POST['supprProf'] : null;
                $nbSuppressions = $Ecole->supprimerProfsCoursGrp($supprProf, $coursGrp);
                $smarty->assign('message', array(
                                    'title' => 'Enregistrement',
                                    'texte' => "$nbSuppressions suppression(s)",
                                    'urgence' => 'info', )
                                    );
                break;
            }

            if ($niveau) {
                $listeCoursGrp = $Ecole->listeCoursGrp($niveau);
                $smarty->assign('listeCoursGrp', $listeCoursGrp);
            }
            if ($coursGrp) {
                $smarty->assign('coursGrp', $coursGrp);
                $listeEleves = $Ecole->listeElevesCours($coursGrp);
                $smarty->assign('listeEleves', $listeEleves);
                $listeTousProfs = $Ecole->listeProfs();
                $smarty->assign('listeTousProfs', $listeTousProfs);
            }

        // quels sont les niveaux d'étude dans l'école
        $smarty->assign('listeNiveaux', $Ecole->listeNiveaux());
        $smarty->assign('niveau', $niveau);

        // qui sont les profs titulaires de ce cours?
        $listeProfsTitulaires = $Ecole->listeProfsCoursGrp($coursGrp);
        $smarty->assign('listeProfsTitulaires', $listeProfsTitulaires);

        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('selecteur', 'selecteurs/selectNiveauCoursGrp');
        $smarty->assign('corpsPage', 'showProfsCours');
        break;

    case 'attributionsEleves':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        if ($etape == 'enregistrer') {
            $listeElevesAdd = isset($_POST['listeElevesAdd']) ? array_flip($_POST['listeElevesAdd']) : null;
            $listeElevesDel = isset($_POST['listeElevesDel']) ? array_flip($_POST['listeElevesDel']) : null;
            $listeCoursGrp = array($coursGrp => $coursGrp);
            $nb = 0;
            if ((isset($listeElevesAdd) || isset($listeElevesDel)) && isset($coursGrp) && isset($bulletin)) {
                if (isset($listeElevesAdd)) {
                    $nb += $Ecole->addListeElevesListeCoursGrp($listeElevesAdd, $listeCoursGrp, $bulletin);
                }
                if (isset($listeElevesDel)) {
                    $nb += $Ecole->delListeElevesListeCoursGrp($listeElevesDel, $listeCoursGrp, $bulletin);
                }
                $smarty->assign('message', array(
                                'title' => 'Enregistrement',
                                'texte' => "$nb enregistrement(s) effectué(s)",
                                'urgence' => 'info', ));
            }
        }

        $smarty->assign('cours', $cours);
        $smarty->assign('coursGrp', $coursGrp);
        $smarty->assign('bulletin', $bulletin);
        if (!(isset($niveau)) && (isset($cours))) {
            $niveau = substr($cours, 0, 1);
        }
        $smarty->assign('niveau', $niveau);
        $listeNiveaux = $Ecole->listeNiveaux();
        $smarty->assign('listeNiveaux', $listeNiveaux);
        $smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
        $smarty->assign('listeCours', $Ecole->listeCours($listeNiveaux));

        $listeCoursGrp = isset($cours) ? $Ecole->listeCoursGrpDeCours($cours) : null;

        $smarty->assign('listeCoursGrp', $listeCoursGrp);

        $profs = isset($coursGrp) ? $Ecole->listeProfsCoursGrp($coursGrp) : null;
        $smarty->assign('profs', $profs);

        $listeElevesDel = isset($coursGrp) ? $Ecole->listeElevesCours($coursGrp, 'alpha') : null;
        $smarty->assign('listeElevesDel', $listeElevesDel);

        $listeElevesAdd = ($niveau != '') ? $Ecole->listeElevesNiveaux($niveau) : null;

        $smarty->assign('listeElevesAdd', $listeElevesAdd);

        $smarty->assign('mode', $mode);
        $smarty->assign('action', $action);
        $smarty->assign('selecteur', 'selectMatieres');
        $smarty->assign('corpsPage', 'showAttributionsEleves');
        break;

    case 'programmeEleve':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        $smarty->assign('listeClasses', $Ecole->listeClasses());
        $smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));

        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('classe', $classe);
        $smarty->assign('selecteur', 'selecteurs/selectClasseEleve');
        if (isset($classe)) {
            $listeEleves = $Ecole->listeEleves($classe, 'groupe');
            $smarty->assign('listeEleves', $listeEleves);
        }
        if (isset($matricule)) {
            $eleve = new Eleve($matricule);
            $smarty->assign('eleve', $eleve->getDetailsEleve());
            $smarty->assign('matricule', $matricule);
            $etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
            switch ($etape) {
                case 'supprimer':
                    // recherche des coursGrp à supprimer pour l'élève actuel
                    $listeCoursGrp = isset($_POST['listeCoursGrp']) ? $_POST['listeCoursGrp'] : null;

                    if (isset($listeCoursGrp)) {
                        // produire une liste dont les clefs sont les noms des cours plutôt qu'une suite de numéros sans signification
                        $listeCoursGrp = array_fill_keys($listeCoursGrp, null);
                        // la fonction delListeElevesListeCoursGrp attend un tableau indexé sur le matricule; on le lui fournit gentiment avec un seul matricule pour clef, le contenu n'a pas d'importance
                        $listeEleves = array($matricule => 'wtf');

                        $nb = $Ecole->delListeElevesListeCoursGrp($listeEleves, $listeCoursGrp, $bulletin);

                        $smarty->assign('etape', '');
                        $smarty->assign('message', array(
                            'title' => 'Enregistrement',
                            'texte' => "$nb modification(s) enregistrée(s)",
                            'urgence' => 'info', ));
                    }
                    break;
                case 'ajouter':
                    if (isset($coursGrp)) {
                        $listeEleves = array($matricule => $matricule);
                        $listeCoursGrp = array($coursGrp => $coursGrp);
                        $nb = $Ecole->addListeElevesListeCoursGrp($listeEleves, $listeCoursGrp, $bulletin);
                    }
                        $smarty->assign('message', array(
                            'title' => 'Enregistrement',
                            'texte' => "$nb modification(s) enregistrée(s)",
                            'urgence' => 'info', ));
                    break;
                default:
                    // wtf;
                    break;
                }
            $historiqueCours = $Ecole->historiqueCoursEleve($matricule);
            $smarty->assign('historiqueCours', $historiqueCours);
            $listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin);
            $listeCoursGrp = isset($listeCoursGrp[$matricule]) ? $listeCoursGrp[$matricule] : null;
            $smarty->assign('listeCoursGrp', $listeCoursGrp);

            $listeTousCours = $Ecole->listeCoursGrp($Ecole->listeNiveaux());
            $listeStruct = array();
            foreach ($listeTousCours as $coursGrp => $details) {
                $cours = $details['cours'];
                $listeStruct[$cours][] = $details;
            }
            $smarty->assign('listeTousCours', $listeStruct);
            $smarty->assign('corpsPage', 'programmeEleve');
        }
        break;

    case 'poserVerrous':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        $etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
        switch ($etape) {
            case 'enregistrer':
                $nb = $Bulletin->saveLocksAdmin($_POST, $bulletin);
                $smarty->assign('message', array(
                            'title' => "Verrouillage des bulletins n0 $bulletin",
                            'texte' => "$nb verrous posés ou supprimés",
                            'urgence' => 'success', )
                            );
                //pas de break;
            case 'voir':
                $smarty->assign('etape', 'voir');
                $listeClasses = $Bulletin->listeStructClasses();
                $smarty->assign('listeClasses', $listeClasses);
                $smarty->assign('corpsPage', 'poserVerrous');
                break;
            default:
                $smarty->assign('etape', 'voir');
                break;
            }

        $verrou = isset($_POST['verrou']) ? $_POST['verrou'] : null;
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('verrou', $verrou);
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('nbBulletins', NBPERIODES);
        $smarty->assign('selecteur', 'selecteurs/selectBulletin');
        break;

    case 'verrouClasseCoursEleve':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        $verrouiller = isset($_POST['verrouiller']) ? $_POST['verrouiller'] : 0;
        if ($etape == 'enregistrer') {
            $nb = $Bulletin->saveLocksClasseCoursEleve($_POST);
            $stxt = ($verrouiller >= 1) ? 'posés' : 'supprimés';
            $smarty->assign('message', array(
                        'title' => "Verrouillage des bulletins n0 $bulletin",
                        'texte' => "$nb verrous $stxt",
                        'urgence' => 'success', )
                        );
        }
        // liste des verrous à inverser
        $listeVerrous = $Bulletin->listeLocksPeriode($bulletin, $niveau, $verrouiller);
        $listeProfs = $Ecole->listeCoursGrpProf($niveau);
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('niveau', $niveau);
        $smarty->assign('verrouiller', $verrouiller);
        $smarty->assign('listeVerrous', $listeVerrous);
        $smarty->assign('listeProfs', $listeProfs);

        $smarty->assign('nbBulletins', NBPERIODES);
        $smarty->assign('listeNiveaux', $Ecole->listeNiveaux());
        $smarty->assign('niveau', $niveau);
        $smarty->assign('bulletin', $bulletin);

        $smarty->assign('selecteur', 'selecteurs/selectBulletinNiveauVerrou');
        $smarty->assign('corpsPage', 'verrousOuverts');
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        break;

    case 'competences':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        $listeNiveaux = $Ecole->listeNiveaux();
        $smarty->assign('listeNiveaux', $listeNiveaux);
        if (isset($niveau)) {
            $smarty->assign('niveau', $niveau);
            $listeCoursComp = $Bulletin->listeCoursNiveaux($niveau);
            $smarty->assign('listeCoursComp', $listeCoursComp);
        }

        if (isset($cours)) {
            $listeCompetences = $Bulletin->listeCompetencesListeCours($cours);
            $listeUsedCompetences = $Bulletin->getUsedCompetences($listeCompetences[$cours]);
            $smarty->assign('cours', $cours);
            $smarty->assign('listeCompetences', $listeCompetences);
            $smarty->assign('listeUsedCompetences', $listeUsedCompetences);
            $smarty->assign('corpsPage', 'adminCompetences');
        }

        $smarty->assign('selecteur', 'selecteurs/selectNiveauCours');
        break;

    case 'situations':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('etape', 'showCotes');
        $smarty->assign('nbBulletins', NBPERIODES);
        $smarty->assign('bulletin', $bulletin);
        $smarty->assign('listeClasses', $Ecole->listeClasses());
        // sélecteur incluant la période '0' pour les élèves de 2e
        $smarty->assign('selecteur', 'selectBulletin0Classe');
        $etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;

        switch ($etape) {
            case 'enregistrer':
                if (isset($classe)) {
                    $nb = $Bulletin->enregistrerSituationsClasse($_POST);
                    // recalcul des cotes de situation du bulletin suivant
                    $listeSitActuelles = $Bulletin->recalculSituationsClasse($bulletin + 1, $classe);
                    $nb2 = $Bulletin->enregistrerSituationsRecalc($listeSitActuelles, $bulletin + 1);
                    $smarty->assign('message', array(
                        'title' => 'Modification des situations',
                        'texte' => "$nb situations enregistrées",
                        'urgence' => 'success', )
                        );
                    $smarty->assign('etape', 'showCotes');
                }
                // pas de break;
            case 'showCotes':
                if ($classe) {
                    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
                    $listeSituations = $Bulletin->getSituations($bulletin, $listeEleves);
                    $listeCoursClasse = $Ecole->listeCoursClasse($classe);
                    $listeCoursEleves = $Bulletin->listeCoursEleves($listeEleves);

                    $smarty->assign('etape', 'enregistrer');
                    $smarty->assign('classe', $classe);
                    $smarty->assign('listeSituations', $listeSituations);
                    $smarty->assign('listeCoursClasse', $listeCoursClasse);
                    $smarty->assign('listeCoursEleves', $listeCoursEleves);
                    $smarty->assign('listeEleves', $listeEleves);
                    $smarty->assign('corpsPage', 'grilleSituations');
                }
                break;
            default:
                // wtf;
                break;
        }

        break;
    case 'alias':
        if ($userStatus != 'admin') {
            die('get out of here');
        }
        $etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
        switch ($etape) {
            case 'enregistrer':
                if ($acronyme == null) {
                    die('missing user');
                }
                $qui = $Application->changeUserAdmin($acronyme);
                if ($qui == '') {
                    die('unknown user');
                }
                $texte = "Vous avez pris l'alias <strong>$qui</strong>";
                $smarty->assign('message', array(
                    'title' => 'Alias',
                    'texte' => $texte,
                    'urgence' => 'info', )
                    );
                $smarty->assign('redirection', 'index.php');
                $smarty->assign('time', 1000);
                $smarty->assign('corpsPage', 'redirect');
                break;
            default:
                $listeProfs = $Ecole->listeProfs();
                $smarty->assign('listeProfs', $listeProfs);
                $smarty->assign('selecteur', 'selectProf');
                $smarty->assign('action', $action);
                $smarty->assign('mode', $mode);
                $smarty->assign('etape', 'enregistrer');
                break;
            }
        break;

    case 'nommerCours':
        $acronyme = $user->getAcronyme();
        if ($etape == 'enregistrer') {
            $nb = $Bulletin->enregistrerNomsCours($_POST, $acronyme);
            $smarty->assign('message', array(
                        'title' => SAVE,
                        'texte' => sprintf('%d enregistrement(s) dans la base de données', $nb),
                        'urgence' => 'success', )
                        );
        }

        $listeCours = $Ecole->listeCoursProf($acronyme, true);
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('etape', 'enregistrer');
        $smarty->assign('listeCours', $listeCours);
        $smarty->assign('corpsPage', 'nomCours');
        break;

    case 'titulaires':
        switch ($etape) {
            case 'supprimer':
                if (isset($_POST['listeAcronymes'])) {
                    $listeAcronymes = $_POST['listeAcronymes'];
                    $nb = $Ecole->supprTitulariat($classe, $listeAcronymes);
                    $smarty->assign('message', array(
                                'title' => 'Suppression',
                                'texte' => sprintf('%d modification(s) enregistrée(s).', $nb),
                                'urgence' => 'info', )
                                );
                }
                break;
            case 'ajouter':
                if (isset($_POST['listeAcronymes'])) {
                    $listeAcronymes = $_POST['listeAcronymes'];
                    $nb = $Ecole->addTitulariat($classe, $listeAcronymes, Null);
                    $smarty->assign('message', array(
                                'title' => 'Ajouts',
                                'texte' => sprintf('%d modification(s) enregistrée(s).', $nb),
                                'urgence' => 'info', )
                                );
                    }
                break;
            }  // switch ($etape)

        // si une classe a été choisie, on montre la page de sélection/désélection
        // des titulaires
        if (isset($classe)) {
            $listeProfs = $Ecole->listeProfs();
            $listeTitusGroupe = $Ecole->titusDeGroupe($classe);
            $smarty->assign('classe', $classe);
            $smarty->assign('listeProfs', $listeProfs);
            $smarty->assign('listeTitusGroupe', $listeTitusGroupe);
        }
        // dans tous les cas, on montre le sélecteur de groupe/classe
        $listeTitus = $Ecole->listeTitus();
        $listeClasses = $Ecole->listeGroupes();
        $smarty->assign('listeTitus', $listeTitus);
        $smarty->assign('listeClasses', $listeClasses);

        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('etape', 'choixTitulaires');
        $smarty->assign('selecteur', 'selectClasse');
        $smarty->assign('corpsPage', 'choixTitu');
        break;

    case 'statutCadre':
        if ($etape == 'enregistrer') {
            $nb = $Bulletin->saveStatutsCadres($_POST);
            $smarty->assign('message', array(
                        'title' => SAVE,
                        'texte' => sprintf('%d statut(s) enregistré(s).', $nb),
                        'urgence' => 'success', )
                        );
        }
        $statutsCadres = $Bulletin->getStatutsCadres();
        $smarty->assign('statutsCadres', $statutsCadres);
        $smarty->assign('corpsPage', 'admin/statutsCadres');
        break;

    case 'ponderations':
        require_once 'inc/init/viewPonderations.inc.php';
        break;
    default: 'missing mode';
        break;
    }
