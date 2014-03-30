<?php
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$classe = isset($_REQUEST['classe'])?$_REQUEST['classe']:Null;

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();
$smarty->assign("listeClasses", $listeTitus);
$smarty->assign("matricule", $matricule);
$smarty->assign("classe", $classe);
$smarty->assign("bulletin", $bulletin);
$smarty->assign("nbBulletins", NBPERIODES);
$smarty->assign("listePeriodes", $Application->listePeriodes(NBPERIODES));

$smarty->assign("action", "titu");

switch ($mode) {
	case 'verrous':
	
		break;
	case 'remarques':
		$smarty->assign ("selecteur", "selectBulletinClasseEleve");
		$smarty->assign("mode", "remarques");
		$smarty->assign("etape", "showEleve");

		if (isset($classe)) {
			$listeElevesClasse = $Ecole->listeEleves($classe,'groupe', false);
			$smarty->assign("listeElevesClasse", $listeElevesClasse);
			}

		switch ($etape) {
			case 'enregistrer':
				$commentaire = isset($_POST['commentaire'])?$_POST['commentaire']:Null;
				$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
				$nbResultats = $BullTQ->enregistrerRemarque($commentaire, $matricule, $bulletin);
				// PAS DE BREAK;
			case 'showEleve':
				$eleve = new Eleve($matricule);
				$infoPersoEleve = $eleve->getDetailsEleve();

				// liste de tous les cours suivis par l'élève (pas d'historique)
				$listeCoursGrp = $BullTQ->listeCoursGrpEleves($matricule);
				$listeCoursGrp = $listeCoursGrp[$matricule];
				$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);
				
				// liste des commentaires des profs des différents cours
				// pas d'indication de néuméro de période, afin de les avoir toutes
				$commentairesProfs = $BullTQ->listeCommentairesTousCours($matricule, Null);
				
				// ***********************************************************
				// à faire ***************************************************
				// $mentions = $BullTQ->listeMentions($matricule, Null);
				// ***********************************************************
				// ***********************************************************
				
				// recherche des cotes globales éventuelle pour toutes les périodes de l'année en cours
				$syntheseCotes4Titu = $BullTQ->globalAnneeEnCours($listeCoursGrp, $matricule);

				// liste de toutes les remarques du titulaire pas d'indication de numéro de période, afin de les avoir toutes
				$listeRemarquesTitulaire = $BullTQ->remarqueTitu($matricule, Null);
				
				// s'il y a des remarques (possible qu'il n'y en ait pas à la période 1, avant le bulletin)

				$smarty->assign("matricule", $matricule);
				$smarty->assign("infoPerso", $infoPersoEleve);
				$smarty->assign("listeCoursGrp", $listeCoursGrp);
				$smarty->assign("listeProfsCoursGrp", $listeProfsCoursGrp);
				$smarty->assign("commentairesProfs", $commentairesProfs);
				$smarty->assign("syntheseCotes", $syntheseCotes4Titu);

				$smarty->assign("listeRemarquesTitu", $listeRemarquesTitulaire);

				$smarty->assign("corpsPage", "showEleve");
				$smarty->assign("corpsPage", "commentairesTitu");
				break;
			
			default:
				
				break;
			}
		break;
	default: 
		echo "bad mode $mode";
		break;
	}
?>
