<?php

$smarty->assign('classe', $classe);
$listeEleves = ($classe != null) ? $Ecole->listeEleves($classe, 'groupe') : null;
$smarty->assign('action', 'ficheEleve');
$smarty->assign('mode', 'wtf');
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

// liste des élèves suivis par l'utililisateur courant
$elevesSuivis = Athena::getEleveUser($acronyme);
$smarty->assign('elevesSuivis', $elevesSuivis);
// liste des élèves sans RV
$elevesSansRV = Athena::getEleveUser($acronyme, null, null, 'chrono', null, true);
$smarty->assign('elevesSansRV', $elevesSansRV);

// liste de tous les élèves suivis par tous les utilisateurs
$clients = Athena::clientCoaching();
$smarty->assign('clients', $clients);

$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$smarty->assign('corpsPage', 'elevesSuivis');
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('selecteur', 'selectClasseEleve');
