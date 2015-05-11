<?php
if ($mode == 'Enregistrer') {
	if (isset($matricule)) {
		$padEleve = new padEleve($matricule, $acronyme);
		$nb = $padEleve->savePadEleve($_POST);
		$texte = ($nb>0)?"$nb enregistrement(s) réussi(s)":"Pas de modification";
		$smarty->assign('message', array(
			'title'=>"Enregistrement",
			'texte'=>$texte,
			'urgence'=>'success'
			)
			);
		}
	}

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
$smarty->assign('selecteur','selectEleve')
?>
