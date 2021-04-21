<?php

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);

// la liste d'élèves de la classe
if (isset($classe))
	$listeEleves = $Ecole->listeEleves($classe, 'groupe');
$smarty->assign('listeEleves',$listeEleves);

if (isset($matricule)) {
	// la "class élève" a été définie dans /entetes.inc.php
	// si un matricule est donné, on aura sans doute besoin des données de l'élève
	$eleve = new Eleve($matricule);
	// $detailsEleve = Eleve::staticGetDetailsEleve($matricule);
	$detailsEleve = $eleve->getDetailsEleve();

	$smarty->assign('eleve', $detailsEleve);
	$titulaires = $eleve->titulaires($matricule);
	$smarty->assign('titulaires', $titulaires);

	$padEleve = new padEleve($matricule, $acronyme);

	$smarty->assign('padsEleve', $padEleve->getPads());
	$smarty->assign('acronyme',$acronyme);
	$smarty->assign('corpsPage','ficheEleve');
	}
$smarty->assign('selecteur','selectClasseEleve');
