<?php

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);
if (isset($classe)) {
    $listeEleves = $Ecole->listeEleves($classe, 'groupe');
    $smarty->assign('listeEleves', $listeEleves);
}

if (isset($matricule) && ($matricule != '')
    && (in_array($matricule, array_keys($listeEleves)))  // le matricule fait partie de la classe sélectionnée
    && ($matricule != 'all')) {  // le cookie pourrait contenir la valeur 'all' qui n'aurait pas de sens ici
    // si un matricule est donné, on aura sans doute besoin des données de l'élève
    $eleve = new Eleve($matricule);

    // initialisation du texte libre dans le bloc-notes
    require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
    $padEleve = new padEleve($matricule, $acronyme);

    // initialisation des données Athena dans le bloc-notes
    require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
    $Athena = new Athena();
    $listeSuivi = $Athena->getSuiviEleve($matricule);
    $smarty->assign('listeSuivi', $listeSuivi);

    // informations médicales
    require_once INSTALL_DIR.'/infirmerie/inc/classes/classInfirmerie.inc.php';
    $infirmerie = new eleveInfirmerie($matricule);
    $smarty->assign('medicEleve', $infirmerie->getMedicEleve($matricule));
    $smarty->assign('consultEleve', $infirmerie->getVisitesEleve($matricule));


    // initialisation des données ADES dans le bloc-notes
    require_once INSTALL_DIR.'/ades/inc/classes/classEleveAdes.inc.php';
    $EleveAdes = new EleveAdes();
    $listeTousFaits = $EleveAdes->getListeFaits($matricule, ANNEESCOLAIRE);
    $smarty->assign('listeTousFaits', $listeTousFaits);

    require_once INSTALL_DIR."/ades/inc/classes/classAdes.inc.php";
    $Ades = new Ades();
    $listeTypesFaits = $Ades->getTypesFaits();
    $smarty->assign('listeTypesFaits', $listeTypesFaits);
    $listeChamps = $Ades->listeChamps();
    $smarty->assign('descriptionChamps', $listeChamps);
    $listeRetenuesEleve = $EleveAdes->getListeRetenuesEleve($matricule);
    $smarty->assign('listeRetenuesEleve', $listeRetenuesEleve);
    $nbFaits = $EleveAdes->nbFaits($matricule, ANNEESCOLAIRE);
    $smarty->assign('nbFaits', $nbFaits);

    // recherche des données de présences pour l'élève
    require_once INSTALL_DIR.'/presences/inc/classes/classPresences.inc.php';
    $Presences = new Presences();
    $listePresences = $Presences->listePresencesEleve($matricule);
    $smarty->assign('listePresences', $listePresences);
    // liste des périodes de cours sur la journée
    $listePeriodesCours = $Presences->lirePeriodesCours();
    $smarty->assign('listePeriodesCours', $listePeriodesCours);
    // liste des statuts d'absences possibles
    $statutsAbs = $Presences->listeJustificationsAbsences();
    $smarty->assign('statutsAbs', $statutsAbs);
    // résumé absences et retards
    $nbJoursAvecAbsence = $Presences->nbJoursAvecAbsence($listePresences);
    $smarty->assign('nbJoursAvecAbsence', $nbJoursAvecAbsence);
    $nbRetards = $Presences->nbRetards($listePresences);
    $smarty->assign('nbRetards', $nbRetards);

    // déclaration de l'année scolaire en cours
    $smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

    // affectation de tous les textes libres pour l'élève
    // s'il n'existe pas, un pad est créé pour l'utilisateur $acronyme et l'élève $matricule
    $smarty->assign('padsEleve', $padEleve->getPads());

    // recherche des infos personnelles de l'élève
    $smarty->assign('eleve', $eleve->getDetailsEleve());

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
    $smarty->assign('listeCoursActuelle', $listeCoursActuelle);

    // ----------------------------------------------------------------------
    // matières à problèmes pour le pad "coordinateur"
    $listeMatieres = $padEleve->getMatieres4pad($matricule);
    $smarty->assign('listeMatieres', $listeMatieres);

    // rubriques de suivi scolaire pour le pad "coordinateur"
    $suivi4pad = $padEleve->getSuivi4pad($matricule);
    $smarty->assign('suivi4pad', $suivi4pad);
    // liste des années scolaires et périodes existantes pour cet élève
    $tabsAnsPeriodes = $padEleve->getAnPeriode();
    $smarty->assign('tabsAnsPeriodes', $tabsAnsPeriodes);

    // liste des périodes de l'année scolaire avec leur nom
    $listePeriodes = $Bulletin->listePeriodes(NBPERIODES);
    $smarty->assign('listePeriodes', $listePeriodes);
    $smarty->assign('NOMSPERIODES', explode(',', NOMSPERIODES));

    $smarty->assign('PERIODESDELIBES', explode(',', PERIODESDELIBES));


    $smarty->assign('epreuvesExternes', $Bulletin->cotesExternesPrecedentes($matricule));
    $smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);

    $mentions = $Bulletin->listeMentions($matricule);
    $smarty->assign('mentions', $mentions);

    // détermination du nombre max de période de délibé
    $maxPeriodes = 0;
    if ($mentions != Null) {
        foreach ($mentions[$matricule] AS $anScol => $dataAnnee) {
            foreach ($dataAnnee AS $annee => $data) {
                if (count($data) > $maxPeriodes)
                    $maxPeriodes = count($data);
                }
            }
        }
    $smarty->assign('maxPeriodes', $maxPeriodes);


    // affichage de l'horaire EDT
    $directory = INSTALL_DIR.'/edt/eleves/';
    if (is_dir($directory)) {
        $horaireEDT = $padEleve->getHoraire($directory, $matricule);
        }
        else $horeaireEDT = Null;
        $smarty->assign('horaireEDT', $horaireEDT);

    // affectation de la liste doublement liée d'élèves
    $prevNext = $Bulletin->prevNext($matricule, $listeEleves);
    $smarty->assign('prevNext', $prevNext);
    // recherche et affectation du titulaire
    $titulaires = $eleve->titulaires($matricule);
    $smarty->assign('titulaires', $titulaires);

    $smarty->assign('matricule', $matricule);

    // $smarty->assign('etape', 'enregistrer');
    $smarty->assign('corpsPage', 'direction/ficheEleve');
}

$smarty->assign('selecteur', 'selecteurs/selectClasseEleve');
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);
