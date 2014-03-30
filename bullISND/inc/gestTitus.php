<?php
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$classe = isset($_REQUEST['classe'])?$_REQUEST['classe']:Null;
$annee = ($classe != Null)?SUBSTR($classe,0,1):Null;

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();
$smarty->assign("listeClasses", $listeTitus);
$smarty->assign("matricule", $matricule);
$smarty->assign('annee',$annee);
$smarty->assign("classe", $classe);
$smarty->assign("bulletin", $bulletin);
$smarty->assign("nbBulletins", NBPERIODES);
$smarty->assign("listePeriodes", $Bulletin->listePeriodes(NBPERIODES));

$smarty->assign("action",$action);

switch ($mode) {
	case 'verrous':
		$smarty->assign ("selecteur", "selectBulletinClasse");
		$smarty->assign("mode", "verrous");
		$smarty->assign("etape", "showVerrous");
		switch ($etape) {
			case 'enregistrer':
				$nbEnregistrements = $Bulletin->saveLocksBulletin($_POST, $bulletin);
				$smarty->assign("message", array(
									'title'=>"Enregistrement des verrous",
									'texte'=>"$nbEnregistrements verrous activés")
									);
				// pas de break;
			default:
				if ($classe && $bulletin) {
					$listeEleves = $Ecole->listeEleves($classe,'groupe');
					$listeCoursGrpClasse = $Ecole->listeCoursGrpClasse($classe);
					$listeCoursGrpEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
					$listeVerrous = $Bulletin->listeLocksBulletin($listeEleves, $listeCoursGrpClasse, $bulletin);
					$smarty->assign("listeEleves", $listeEleves);
					$smarty->assign("listeCoursGrpEleves", $listeCoursGrpEleves);
					$smarty->assign("listeCoursGrpClasse", $listeCoursGrpClasse);
					$smarty->assign("listeVerrous", $listeVerrous);
					$smarty->assign("corpsPage", "feuilleVerrous");					
					}
				break;
			}
		break;
	case 'remarques':
		$smarty->assign ("selecteur", "selectBulletinClasseEleve");
		$smarty->assign("mode",$mode);
		$smarty->assign("etape", "showEleve");
		if (isset($classe)) {
			$listeEleves = $Ecole->listeEleves($classe,'groupe');
			$smarty->assign("listeEleves", $listeEleves);
			$prevNext = $Ecole->prevNext($matricule, $listeEleves);
			$smarty->assign('prevNext',$prevNext);	
		}

		switch ($etape) {
			case 'enregistrer':
				$commentaire = isset($_POST['commentaire'])?$_POST['commentaire']:Null;
				$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
				$nbResultats = $Bulletin->enregistrerRemarque($commentaire, $matricule, $bulletin);
				// PAS DE BREAK;
			case 'showEleve':
				$annee = $Ecole->anneeDeClasse($classe);
				$eleve = new Eleve($matricule);
				$infoPersoEleve = $eleve->getDetailsEleve();

				// liste de tous les cours suivis par l'élève, y compris ceux qu'il ne suit plus (pas d'historique)
				$listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin);
				$listeCoursGrp = $listeCoursGrp[$matricule];

				$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);

				// pas d'indication de numéro de période, afin de les avoir toutes
				$commentairesProfs = $Bulletin->listeCommentairesTousCours($matricule, Null);
				$mentions = $Bulletin->listeMentions($matricule, Null, $annee);
				$ficheEduc = $Bulletin->listeFichesEduc($matricule, $bulletin);			
				
				// recherche des cotes de situation et délibé éventuelle pour toutes les périodes de l'année en cours
				$listeCoursActuelle = $Bulletin->listeFullCoursGrpActuel($matricule);
				$listeCoursActuelle = $listeCoursActuelle[$matricule];
				
				// cotes de gobal période pour le bulletin $bulletin
				$sommesTjCert = $Bulletin->sommesTJCertEleves($matricule, $bulletin);
				$ponderations = $Bulletin->getPonderationsBulletin($listeCoursGrp, $bulletin);
				$cotesPeriode = $Bulletin->cotesPeriodePonderees($sommesTjCert, $ponderations);
				$smarty->assign('cotesPeriode',$cotesPeriode);				
				
				
				$syntheseCotes4Titu = $Bulletin->syntheseAnneeEnCours($listeCoursActuelle, $matricule);

				// pas d'indication de numéro de période, afin de les avoir toutes
				$listeRemarquesTitulaire = $Bulletin->remarqueTitu($matricule, Null);
				// s'il y a des remarques (possible qu'il n'y en ait pas à la période 1, avant le bulletin)
				$remarqueTitulaire = isset($listeRemarquesTitulaire[$matricule])?$listeRemarquesTitulaire[$matricule]:Null;

				// pas d'indication de bulletin afin de les avoir tous
				$tableauAttitudes = $Bulletin->tableauxAttitudes($matricule, Null);
				$smarty->assign('matricule', $matricule);
				$smarty->assign('infoPerso', $infoPersoEleve);
				$smarty->assign('listeCoursGrp', $listeCoursGrp);
				$smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);
				$smarty->assign('commentairesProfs', $commentairesProfs);
				
				$smarty->assign('syntheseCotes', $syntheseCotes4Titu);
				$smarty->assign('attitudes', $tableauAttitudes);
				$smarty->assign('ficheEduc', $ficheEduc);
				$smarty->assign('listeRemarquesTitu', $listeRemarquesTitulaire);
				$smarty->assign('remarqueTitu', $remarqueTitulaire[$bulletin]);
				$smarty->assign('mentions',$mentions);

				$smarty->assign('corpsPage', 'commentairesTitu');
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
