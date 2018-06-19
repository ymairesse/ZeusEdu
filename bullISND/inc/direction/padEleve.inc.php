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

    require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
    $padEleve = new padEleve($matricule, $acronyme);

    require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
    $Athena = new Athena();
    $listeSuivi = $Athena->getSuiviEleve($matricule);
    $smarty->assign('listeSuivi', $listeSuivi);

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

    if (isset($etape) && ($etape == 'enregistrer')) {
        $nb = $padEleve->savePadEleve($_POST);
        $texte = ($nb > 0) ? "$nb enregistrement(s) réussi(s)" : 'Pas de modification';
        $smarty->assign('message', array(
            'title' => SAVE,
            'texte' => $texte,
            'urgence' => 'success', )
            );
    }

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
    $listeCoursActuelle = $listeCoursActuelle[$matricule];
    $smarty->assign('listeCoursGrp', $listeCoursActuelle);
    $syntheseAnneeEnCours = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);
    $smarty->assign('anneeEnCours', $syntheseAnneeEnCours);
    $smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

    // tableau de synthèse de toutes les cotes de situation pour toutes les années scolaires
    $syntheseToutesAnnees = $Bulletin->syntheseToutesAnnees($matricule);
    $smarty->assign('listeCoursActuelle', $listeCoursActuelle);

    $smarty->assign('epreuvesExternes', $Bulletin->cotesExternesPrecedentes($matricule));
    $smarty->assign('syntheseToutesAnnees', $syntheseToutesAnnees);
    $smarty->assign('listePeriodes', $Bulletin->listePeriodes(NBPERIODES));
    $smarty->assign('mentions', $Bulletin->listeMentions($matricule, null, null, null));
    $prevNext = $Bulletin->prevNext($matricule, $listeEleves);
    $titulaires = $eleve->titulaires($matricule);
    $smarty->assign('matricule', $matricule);
    $smarty->assign('titulaires', $titulaires);

    $smarty->assign('prevNext', $prevNext);
    $smarty->assign('etape', 'enregistrer');
    $smarty->assign('corpsPage', 'direction/ficheEleve');
}

$smarty->assign('selecteur', 'selecteurs/selectClasseEleve');
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);
