<?php

// la liste d'élèves d'un cours
if (isset($coursGrp)) {
	$listeEleves = $Ecole->listeElevesCours($coursGrp);
	$smarty->assign('listeEleves', $listeEleves);
	}

if (isset($matricule)) {
	// si un matricule est donné, on aura sans doute besoin des données de l'élève
	$eleve = new Eleve($matricule);
	$smarty->assign('eleve', $eleve->getDetailsEleve());
	$titulaires = $eleve->titulaires($matricule);
	$smarty->assign('titulaires', $titulaires);
	$padEleve = new padEleve($matricule, $acronyme);
	$smarty->assign('padsEleve', $padEleve->getPads());
	$smarty->assign('corpsPage','ficheEleve');
	}

$listeCoursGrp = $user->getListeCours($acronyme);

$smarty->assign('listeCoursGrp', $listeCoursGrp);
$smarty->assign('selecteur','selectCoursEleve');
