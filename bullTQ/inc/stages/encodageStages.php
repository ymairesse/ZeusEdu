<?php

$listeStagiaires = $BullTQ->listeStagesSuivis($acronyme);

// ventiler les stagiaires par classe (groupe)
$listeStagiaires4groupe = array();
foreach ($listeStagiaires as $matricule => $data){
    $groupe = $data['groupe'];
    $listeStagiaires4groupe[$groupe][$matricule] = $data;
}

$listeCotesQualifPargroupe = array();
foreach ($listeStagiaires as $matricule => $data){
    $listeCotesQualifPargroupe[$matricule] = $BullTQ->mentionsQualif($matricule);
}

$listeEpreuves = $BullTQ->listeEpreuvesQualif();

// Application::afficher($listeCotesQualifPargroupe);
// Application::afficher($listeStagiaires);

$smarty->assign('listeStagiaires', $listeStagiaires);
$smarty->assign('listeEpreuves', $listeEpreuves);
$smarty->assign('listeCotesQualifPargroupe', $listeCotesQualifPargroupe);
$smarty->assign('listeStagiaires4groupe', $listeStagiaires4groupe);

$smarty->assign('corpsPage', 'stages/encodageStages');
