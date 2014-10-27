<?php
$unAn = time() + 365*24*3600;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;

if (isset($_POST['coursGrp'])) {
	$coursGrp = $_POST['coursGrp'];
	setcookie('coursGrp',$coursGrp,$unAn, null, null, false, true);
	}
	else $coursGrp = (isset($_COOKIE['coursGrp']))?$_COOKIE['coursGrp']:Null;
$smarty->assign('coursGrp', $coursGrp);

if (isset($_POST['tri'])) {
	$tri = $_POST['tri'];
	setcookie('tri',$tri,$unAn, null, null, false, true);
	}
	else $tri = (isset($_COOKIE['tri']))?$_COOKIE['tri']:Null;
$smarty->assign('tri', $tri);

$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$idCarnet = isset($_POST['idCarnet'])?$_POST['idCarnet']:Null;

$smarty->assign('action','carnet');
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('bulletin',$bulletin);
$smarty->assign('COTEABS',COTEABS);
$smarty->assign('COTENULLE',COTENULLE);
$smarty->assign('NOMSPERIODES',explode(',',NOMSPERIODES));

switch ($mode) {
	case 'gererCotes':
		$smarty->assign('selecteur', 'selectBulletinCours');
		$smarty->assign('mode','gererCotes');

		switch ($etape) {
			case 'recordEnteteCote':
				$nb = $Bulletin->recordEnteteCote($_POST);
				$smarty->assign('message', array(
					'title'=>'Enregistrement',
					'texte'=>"$nb modification(s) enregistrée(s)")
					);
				break;
			case 'recordCotes':
				$listeErreurs = $Bulletin->recordCotes($_POST);
				$smarty->assign('listeErreurs', $listeErreurs);
				$smarty->assign('message', array(
					'title'=>'Enregistrement',
					'texte'=>count($listeErreurs).' erreur(s)')
					);
				break;
			case 'delCote':
				$listeCours = $user->listeCoursProf("'G','TT','S'");
				$nb = $Bulletin->effacementLiciteCarnet($idCarnet, $listeCours);
				$smarty->assign('message', array(
					'title'=>'Effacement',
					'texte'=>'cote effacée')
					);
				break;
			}
		if ($coursGrp && in_array($coursGrp, array_keys($user->listeCoursProf()))) {
			$smarty->assign ('corpsPage', 'showCarnet');
			$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
			$listeTravaux = $Bulletin->listeTravaux($coursGrp,$bulletin);
			$listeCompetences = current($Bulletin->listeCompetences($coursGrp));
			$listeCotes = ($listeTravaux != Null)?$Bulletin->listeCotesCarnet($listeTravaux):Null;
			$listeMoyennes = $Bulletin->listeMoyennesCarnet($listeCotes);
			$smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('listeTravaux', $listeTravaux);
			$smarty->assign('listeCotes', $listeCotes);
			$smarty->assign('listeMoyennes', $listeMoyennes);
			$smarty->assign('listeCompetences', $listeCompetences);
			}
		break;
	case 'oneClick':
		$smarty->assign('mode','oneClick');
		$smarty->assign('selecteur', 'selectBulletinCours');
		switch ($etape) {
			case 'transfert':
				$listeCompetences = $Bulletin->listeCompetences($coursGrp);
				// vérifier que des poids ont été attribués aux compétences			
				$listePoidsOK = $Bulletin->poidsCompetencesOK($coursGrp,$bulletin,$listeCompetences);
				if ($listePoidsOK['tutti'] == false) {
					$smarty->assign('erreursPoids',$listePoidsOK['details']);
					}
					else {
						$listeEleves = $Ecole->listeElevesCours($coursGrp);
						$listeLocks = $Bulletin->listeLocksBulletin($listeEleves, $coursGrp, $bulletin);
						$Res = $Bulletin->transfertCarnetCotes($_POST, $listeLocks);
						
						// -------------------------------------------------------------------------------------
						// recalculs APRES ENREGISTREMENT ------------------------------------------------------
						// recherche de la liste des nouvelles cotes par élève, par compétence et par type (form ou cert) 
						// dans le bulletion indiqué
						$ponderations = $Bulletin->getPonderations($coursGrp, $bulletin);
						$listeCotes = $Bulletin->listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);
						// recherche de la liste des cotes globales pour la période, en tenant compte de la pondération		
						$listeGlobalPeriodePondere = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);
						// recherche la liste des situations de tous les élèves du cours, pour tous les bulletins existants dans la BD
						$listeSituationsAvant = $Bulletin->listeSituationsCours($listeEleves, $coursGrp, null, true);
						// calcule les nouvelles situations pour ce bulletin, à partir des situations existantes et du globalPeriode
						$listeSituations = $Bulletin->calculeNouvellesSituations($listeSituationsAvant, $listeGlobalPeriodePondere, $bulletin);
						$Bulletin->enregistrerSituations($listeSituations, $bulletin);
						$smarty->assign('message', array(
								'title'=>'Enregistrement',
								'texte'=>sprintf('%d cotes enregistré(s)<br>%d cotes refusées (bulletin verrouillé?)', $Res['ok'],$Res['ko'])
								));
						$listeSituations = $Bulletin->listeSituationsCours($listeEleves, $coursGrp, null, true);
					}
				// pas de break;
			default:
				$listeColonnes = $Bulletin->colonnesCotesBulletin ($coursGrp, $bulletin);
				// s'il n'y a pas de cotes, on arrête là...
				if (count($listeColonnes) > 0) {
					$listeCompetences = $Bulletin->listeCompetencesBulletin ($coursGrp, $bulletin);
					$listeCotesEleves = $Bulletin->listeCotesCompFormCert ($listeColonnes);
					$sommesBrutesCotes = $Bulletin->sommesBruteCotes($listeColonnes, $listeCotesEleves);
					$poidsCompetencesBulletin = $Bulletin->poidsCompetencesBulletin($coursGrp, $bulletin);
					$listeCotesBulletin = $Bulletin->cotesBulletinCalculees($sommesBrutesCotes, $poidsCompetencesBulletin);
					$smarty->assign('poidsCompetences', $poidsCompetencesBulletin);
					$smarty->assign('listeCompetences', $listeCompetences);
					$smarty->assign('listeEleves', $Ecole->listeElevesCours($coursGrp,$tri));
					$smarty->assign('tableauBulletin', $listeCotesBulletin);
					$smarty->assign('sommesCotes', $sommesBrutesCotes);
					$smarty->assign('corpsPage', 'syntheseOneClick');
					}
					else {
						$smarty->assign('erreurTransfert', true);
						$smarty->assign('corpsPage', 'noTransfert');
						}
				break;
			}
		break;
	case 'poidsCompetences':
		$smarty->assign('selecteur', 'selectCours');
		$smarty->assign('mode', 'poidsCompetences');
		if ($coursGrp && in_array($coursGrp, array_keys($user->listeCoursProf()))) {
			switch ($etape) {
				case 'enregistrer':
					$nbResultats = $Bulletin->recordPoidsCompetences($_POST);
					$smarty->assign('message', array(
						'title'=>'Enregistrement',
						'texte'=> "$nbResultats poids enregistré(s)")
						);
				// pas de break;
				// break;
				default: 
					$listePonderations = current($Bulletin->getPonderations($coursGrp));
					$listeTravaux = $Bulletin->listeTravaux($coursGrp,$bulletin);
					$listeCompetences = current($Bulletin->listeCompetences($coursGrp));
					$tableauPoids = $Bulletin->listePoidsCompetences($coursGrp, $listeCompetences);
					$listeCotes = ($listeTravaux != Null)?$Bulletin->listeCotesCarnet($listeTravaux):Null;
					$smarty->assign('ponderations', $listePonderations);
					$smarty->assign('listeCompetences', $listeCompetences);
					$smarty->assign('tableauPoids', $tableauPoids);
					$smarty->assign('etape', 'enregistrer');
					$smarty->assign('corpsPage', 'showPoidsCompetences');
					break;
			}
		break;
		}
	}
?>
