<?php

$bulletin = isset($_POST['bulletin']) ? $_POST['bulletin'] : PERIODEENCOURS;
$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$classe = isset($_REQUEST['classe']) ? $_REQUEST['classe'] : null;

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $BullTQ->tituTQ($acronyme);
if (!(in_array($classe, $listeTitus))) {
    if (count($listeTitus == 1)) {
        $classe = current($listeTitus);
    } else {
        $classe = '';
    }
}

$smarty->assign('listeClasses', $listeTitus);
$smarty->assign('matricule', $matricule);
$smarty->assign('classe', $classe);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('PERIODESDELIBES', explode(',', PERIODESDELIBES));
$smarty->assign('listePeriodes', $Application->listePeriodes(NBPERIODES));

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);
$smarty->assign('selecteur', 'selecteurs/selectBulletinClasseEleve');

switch ($mode) {
    case 'verrous':

        break;
    case 'remarques':

        if ($etape == 'enregistrer') {
            $commentaire = isset($_POST['commentaire']) ? $_POST['commentaire'] : null;
            $matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
            $nbResultats = $BullTQ->enregistrerRemarque($commentaire, $matricule, $bulletin);
        }

        if (isset($classe)) {
            $listeElevesClasse = $Ecole->listeEleves($classe, 'groupe', false);
            $smarty->assign('listeElevesClasse', $listeElevesClasse);

            if (isset($matricule)) {
                $eleve = new Eleve($matricule);
                $infoPersoEleve = $eleve->getDetailsEleve();
                $smarty->assign('infoPerso', $infoPersoEleve);

                // liste de tous les cours suivis par l'élève (pas d'historique)
                $listeCoursGrp = $BullTQ->listeCoursGrpEleves($matricule);
                $listeCoursGrp = $listeCoursGrp[$matricule];
                $smarty->assign('listeCoursGrp', $listeCoursGrp);

                $listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);
                $smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);

                // liste des commentaires des profs des différents cours
                // pas d'indication de néuméro de période, afin de les avoir toutes
                $commentairesProfs = $BullTQ->listeCommentairesTousCours($matricule, null);
                $smarty->assign('commentairesProfs', $commentairesProfs);

                $listeMentions = $BullTQ->mentionsGlobalesFinales($matricule);
                $listeMentions = isset($listeMentions[$matricule])?$listeMentions[$matricule]:Null;;
                $smarty->assign('listeMentions', $listeMentions);

                // recherche des cotes globales éventuelle pour toutes les périodes de l'année en cours
                $syntheseCotes4Titu = $BullTQ->globalAnneeEnCours($listeCoursGrp, $matricule);
                $smarty->assign('syntheseCotes', $syntheseCotes4Titu);

                // liste de toutes les remarques du titulaire pas d'indication de numéro de période, afin de les avoir toutes
                $listeRemarquesTitulaire = $BullTQ->remarqueTitu($matricule, null);
                $smarty->assign('listeRemarquesTitu', $listeRemarquesTitulaire);

                $smarty->assign('matricule', $matricule);
                $smarty->assign('corpsPage', 'commentairesTitu');
            }
        }

        break;
    }
