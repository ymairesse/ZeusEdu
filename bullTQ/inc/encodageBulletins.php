<?php

$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$bulletin = isset($_REQUEST['bulletin'])?$_REQUEST['bulletin']:PERIODEENCOURS;
$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$smarty->assign('matricule',$matricule);
if ($mode == 'enregistrer') {
    $data = $BullTQ->organiserData($_POST);
    $nb = $BullTQ->enregistrer($data, $coursGrp, $bulletin);
    }

if (isset($coursGrp)) {
    $smarty->assign('bulletin', $bulletin);
    $listeEleves = $Ecole->listeElevesCours($coursGrp);
    $libelleCours = $BullTQ->intituleCours($coursGrp);
    $smarty->assign('libelleCours', $libelleCours);
    $smarty->assign('listeEleves', $listeEleves);
    $smarty->assign('coursGeneral', $BullTQ->estGeneral($coursGrp));

    $listeCommentaires = $BullTQ->listeCommentaires($listeEleves, $coursGrp);
    $smarty->assign('listeCommentaires', $listeCommentaires);

    $cours = $BullTQ->coursDeCoursGrp($coursGrp);
    $listeCompetences = $BullTQ->listeCompetencesListeCours($cours);
    $smarty->assign('listeCompetences', $listeCompetences);

    $listeCotesGlobales = $BullTQ->listeCotesGlobales($coursGrp, $bulletin);
    $listeCotesGlobales = isset($listeCotesGlobales[$bulletin][$coursGrp])?$listeCotesGlobales[$bulletin][$coursGrp]:Null;
    $smarty->assign('cotesGlobales', $listeCotesGlobales);

    $listeCotesGeneraux = $BullTQ->toutesCotesCoursGeneraux($coursGrp, $listeEleves, $bulletin);
    $listeCotesGeneraux = isset($listeCotesGeneraux[$bulletin])?$listeCotesGeneraux[$bulletin]:Null;
    $smarty->assign('cotesCoursGeneraux', $listeCotesGeneraux);

    $smarty->assign('corpsPage','encodageBulletin');
    }
$listeCours = $user->listeCoursProf("'TQ'");

$smarty->assign('listeCours',$listeCours);
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('bulletin', $bulletin);

$smarty->assign('action',$action);
$smarty->assign('selecteur', 'selecteurs/selectBulletinCours');
