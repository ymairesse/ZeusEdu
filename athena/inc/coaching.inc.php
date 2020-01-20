<?php

$smarty->assign('classe', $classe);
$listeEleves = ($classe != null) ? $Ecole->listeEleves($classe, 'groupe') : null;
$smarty->assign('action', 'ficheEleve');
$smarty->assign('mode', 'wtf');
$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

$tri = isset($_COOKIE['tri']) ? $_COOKIE['tri'] : 'chrono';

// liste des élèves suivis par l'utililisateur courant
$elevesSuivis = Athena::getEleveUser($acronyme, null, null, $tri);

$smarty->assign('elevesSuivis', $elevesSuivis);
// liste des élèves sans RV
$elevesSansRV = Athena::getEleveUser($acronyme, null, null, $tri, null, true);
$smarty->assign('elevesSansRV', $elevesSansRV);

// liste de tous les élèves suivis par tous les utilisateurs
$clients = Athena::clientCoaching();
$smarty->assign('clients', $clients);

$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);
$smarty->assign('listeEleves', $listeEleves);

$anneesScolaires = $Athena->getListeAnneesScolaires();
$smarty->assign('anneesScolaires', $anneesScolaires);

$smarty->assign('tri', $tri);

$smarty->assign('selecteur', 'selectClasseEleve');
$smarty->assign('corpsPage', 'elevesSuivis');

