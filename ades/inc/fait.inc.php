<?php

	$idfait = isset($_REQUEST['idfait'])?$_REQUEST['idfait']:Null;
	$type = isset($_REQUEST['type'])?$_REQUEST['type']:Null;
	switch ($mode) {
	case 'suppr':
		if ($idfait != Null) {
		$nb = $ficheDisc->supprFait($idfait);
		$smarty->assign('message', array(
			'title'=>DELETE,
			'texte'=>"Effacement de: $nb fait(s)",
			'urgence'=>'danger'));
		$ficheDisc->relireFaitsDisciplinaires($matricule);
		$afficherEleve = true;
		}
		break;
	case 'new':
		$prototype = $Ades->prototypeFait($type);
		$faitVide = $ficheDisc->faitVide($prototype,$type,$user->identite());
		$smarty->assign('anneeScolaire',ANNEESCOLAIRE);
		$smarty->assign('fait',$faitVide);
		$smarty->assign('type',$type);
		// break;  pas de break, on poursuit sur l'édition du fait vide
	case 'edit':
		if (isset($idfait)) {
			// on ne vient pas du case 'new', il faut assigner le $fait et le $type
			$fait = $ficheDisc->lireUnFait($idfait);
			$smarty->assign('fait',$fait);
			$type = $fait['type'];
			$smarty->assign('type',$type);
		}

		// liste nécessaire pour obtenir une liste des profs à l'origine du signalement du fait
		$smarty->assign('listeProfs',$Ecole->listeProfs(false));
		// acronyme de l'utilisateur pour indiquer qui a pris note du fait
		$smarty->assign('acronyme',$user->acronyme());

		$prototype = $Ades->prototypeFait($type);
		$smarty->assign('prototype', $prototype);
		$listeRetenues = $Ades->listeRetenues($prototype['structure']['typeRetenue'], true);
		$smarty->assign('listeRetenues', $listeRetenues);
		$smarty->assign('listeMemos',$Ades->listeMemos($user->acronyme()));

		$smarty->assign('action',$action);
		$smarty->assign('mode','enregistrer');
		$smarty->assign('classe',$classe);
		$smarty->assign('matricule',$matricule);
		$smarty->assign('corpsPage','editFaitDisciplinaire');
		break;
	case 'enregistrer':
		$type=isset($_POST['type'])?$_POST['type']:Null;
		$oldIdretenue = isset($_POST['oldIdretenue'])?$_POST['oldIdretenue']:Null;
		// s'il n'y a pas de idretenue mais qu'on a un oldIdretenue, c'est que la date de retenue n'est plus accessible (cachée)
		// dans la liste déroulante; alors, on prend l'ancien idretenue comme base
		$idretenue = (isset($_POST['idretenue']) && $_POST['idretenue'] != '')?$_POST['idretenue']:$oldIdretenue;
		$prototype = $Ades->prototypeFait($type);
		$retenue = ($prototype['structure']['typeRetenue'] != 0)?$Ades->detailsRetenue($idretenue):Null;
		$nb = $ficheDisc->enregistrerFaitDisc($_POST, $prototype, $retenue);
		$smarty->assign('message', array(
			'title'=>SAVE,
			'texte'=>"Enregistrement de: $nb fait(s)",
			'urgence'=>'success'));
		$ficheDisc->relireFaitsDisciplinaires($matricule);
		$afficherEleve = true;
		$action = Null; $mode= Null;
		break;
	}
?>
