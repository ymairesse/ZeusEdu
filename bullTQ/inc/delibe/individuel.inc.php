<?php

$smarty->assign('etape', 'showEleve');
$smarty->assign('selecteur', 'selecteurs/selectClasseEleve');
switch ($etape) {
    case 'enregistrer':
        $nb = $BullTQ->enregistrerDelibe($_POST);
        $nb = $BullTQ->enregistrerDecision($_POST);
        $smarty->assign('message', array(
        'title' => SAVE,
        'texte' => "Enregistrement de $nb mentions",
        'urgence' => 'success', )
        );
        // break;  pas de break: on continue sur la présentation de la fiche d'élève
    default:
        if (($matricule == '') || ($classe == '')) {
            break;
        } else {
                $smarty->assign('nomPrenomClasse', $Ecole->nomPrenomClasse($matricule));
                // on établit autant de sous-tableaux qu'il existe de périodes
                // dans chaque sous-tableau, toutes les cotes d'une même période
                $cotesParPeriode = $BullTQ->cotesEleve($matricule, $listePeriodes);

                $statistiquesGlobales = $BullTQ->tableauStatistique($cotesParPeriode, '');
                $statistiquesStage = $BullTQ->tableauStatistique($cotesParPeriode, 'STAGE');
                $statistiquesOG = $BullTQ->tableauStatistique($cotesParPeriode, 'OG');

                $decision = $BullTQ->listeDecisions($matricule);
                $decision = $decision[$matricule];

                $mentionsPossibles = array('E', 'TB', 'B', 'AB', 'S', 'I', 'TI');
                $smarty->assign('mentions', $mentionsPossibles);
                $smarty->assign('statGlobales', $statistiquesGlobales);
                $smarty->assign('statStage', $statistiquesStage);
                $smarty->assign('statOG', $statistiquesOG);

                $smarty->assign('decision', $decision);

                // établir trois sous-tableaux par type de cours
                // les cours de type OG, les cours de type 'STAGE', les autres cours
                // les trois sous-tableaux portent les noms:
                // ['cours'] pour le tout-venant
                // [leNomDuType] pour les autres (soit 'OG' ou 'STAGE', ici)
                $cotesParTypes = $BullTQ->cotesParTypes($cotesParPeriode, array('OG', 'STAGE'));
                $smarty->assign('listeCotes', $cotesParTypes);

                // classement de l'ensemble des cours de l'élève par type
                $listeCours = $Ecole->listeCoursListeEleves($matricule);
                $listeCours = $BullTQ->listeCoursParType($listeCours[$matricule], array('OG', 'STAGE'));
                $smarty->assign('listeCours', $listeCours);

                $qualification = $BullTQ->mentionsQualif($matricule);
                $smarty->assign('qualification', $qualification);
                $mentionsManuelles = $BullTQ->mentionsManuelles($matricule);
                $smarty->assign('mentionsManuelles', $mentionsManuelles);

                $smarty->assign('anneeScolaire', ANNEESCOLAIRE);
                $smarty->assign('etape', 'enregistrer');
                $smarty->assign('corpsPage', 'delibeIndividuel');

                break;
            }
        break;
}
