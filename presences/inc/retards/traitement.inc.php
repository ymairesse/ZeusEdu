<?php

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;

$debut = Application::postOrCookie('debut', $unAn);
if ($debut == Null) {
	$anDebut = explode('-', ANNEESCOLAIRE)[0];
	$debut = '01/09/'.$anDebut;
}

$fin = Application::postOrCookie('fin', $unAn);
if ($fin == Null)
	$fin = date('d/m/Y');

// mise en ordre éventuelle des dates de début et de fin
$dateDebut = strptime($debut,'%d/%m/%Y');
$dateFin = strptime($fin,'%d/%m/%Y');
$timestamp1 = mktime(0, 0, 0, $dateDebut['tm_mon']+1, $dateDebut['tm_mday'], $dateDebut['tm_year']+1900);
$timestamp2 = mktime(0, 0, 0, $dateFin['tm_mon']+1, $dateFin['tm_mday'], $dateFin['tm_year']+1900);
if ($timestamp1 > $timestamp2) {
	$swap = $debut;
	$debut = $fin;
	$fin = $swap;
	}

$smarty->assign('debut', $debut);
$smarty->assign('fin', $fin);

$listeClasses = $Ecole->listeGroupes();

$listeNiveaux = Ecole::listeNiveaux();
$smarty->assign('listeNiveaux', $listeNiveaux);

$smarty->assign('corpsPage', 'retards/pageTraitement');
