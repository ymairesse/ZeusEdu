<?php

$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('selecteur','selectClasseEleve');
$smarty->assign('action','delibes');
$smarty->assign('mode','individuel');
switch ($etape) {
    case 'enregistrer':
        $nb = $Bulletin->enregistrerMentions($_POST);
        $nb = $Bulletin->enregistrerDecision($_POST);
        $smarty->assign('message', array(
                            'title'=>SAVE,
                            'texte'=>sprintf('%d mention(s) enregistrée(s)', $nb),
                            'urgence'=>'success')
                            );
        // pas de break;
    case 'showEleve':
        $listeCoursEleve = current($Bulletin->listeCoursGrpEleves($matricule, $bulletin, true));

        // recension des situations dans les différents cours pour l'élève concerné
        $listeSituations = current($Bulletin->listeSituationsCours($matricule, array_keys($listeCoursEleve), null, true));

        // calcul de la moyenne des cotes de situation pour l'élève concerné pour les périodes avec délibération
        $listePeriodesDelibe = explode(',',str_replace(' ','',PERIODESDELIBES));
        $moyenneSituations = $Bulletin->moyennesSituations($listeSituations, $listePeriodesDelibe);

        // sur la base de la moyenne des situations, détermination de la mention (grade) méritée avant délibération
        $mentionsJuinDec = $Bulletin->calculeMentionsDecJuin($moyenneSituations);

        // recherche toutes les mentions effectivement attribuées par le Conseil de Classe, durant l'année scolaire en cours pour l'élève concerné
        $listeMentions = $Bulletin->listeMentions($matricule,Null,$annee,ANNEESCOLAIRE);

        // recherche toutes les décisions prises en délibération, y compris les infos nécessaires à la notification de l'élève $matricule
        $decision = $Bulletin->listeDecisions($matricule);
        $decision = $decision[$matricule];

        // liste doublement liée des élèves de la classe (pour suivant et précédent)
        $prevNext = $Bulletin->prevNext($matricule,$listeEleves);
        // liste de tous les commentaires de titulaires de différents cours
        $remarques = $Bulletin->listeCommentairesTousCours($matricule, $listePeriodesDelibe);

        $estTitulaire = in_array($classe,$user->listeTitulariats());
        $smarty->assign('decision',$decision);
        $smarty->assign('estTitulaire',$estTitulaire);
        $smarty->assign('listeCours',$listeCoursEleve);
        $smarty->assign('listeSituations',$listeSituations);
        $smarty->assign('listeRemarques',$remarques);
        $smarty->assign('prevNext',$prevNext);
        $smarty->assign('eleve',$Ecole->nomPrenomClasse($matricule));
        $smarty->assign('mentions',$mentionsJuinDec);
        $smarty->assign('decision',$decision);
        $smarty->assign('delibe',$moyenneSituations);
        $smarty->assign('mentionsAttribuees',$listeMentions);
        $smarty->assign('ANNEESCOLAIRE',ANNEESCOLAIRE);
        $smarty->assign('NBPERIODES',NBPERIODES);
        $smarty->assign('listePeriodes',$listePeriodesDelibe);
        $smarty->assign('corpsPage','delibe/delibeIndividuel');
        break;
    default:
        // wtf
        break;
    }
