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

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('nbBulletins',NBPERIODES);
$smarty->assign('bulletin',$bulletin);
$smarty->assign('COTEABS',COTEABS);
$smarty->assign('COTENULLE',COTENULLE);
$smarty->assign('NOMSPERIODES',explode(',',NOMSPERIODES));

$listeCours = $user->listeCoursProf();
$smarty->assign('listeCours',$listeCours);

switch ($mode) {
	case 'gererCotes':
		switch ($etape) {
			case 'recordEnteteCote':
				$nb = $Bulletin->recordEnteteCote($_POST);
				$smarty->assign('message', array(
					'title'=>'Enregistrement',
					'texte'=>"$nb modification(s) enregistrée(s)",
					'urgence'=>'success')
					);
				break;
			case 'recordCotes':
				$listeErreurs = $Bulletin->recordCotes($_POST);
				$smarty->assign('listeErreurs', $listeErreurs);
				$smarty->assign('message', array(
					'title'=>'Enregistrement',
					'texte'=>count($listeErreurs).' erreur(s)',
					'urgence'=>'success')
					);
				break;
			case 'delCote':
				$listeCours = $user->listeCoursProf("'G','TT','S'");
				$nb = $Bulletin->effacementLiciteCarnet($idCarnet, $listeCours);
				$smarty->assign('message', array(
					'title'=>'Effacement',
					'texte'=>'Cette cote a été effacée',
					'urgence'=>'warning')
					);
				break;
			}
		$smarty->assign('selecteur','selectBulletinCours');
		if (isset($coursGrp) && in_array($coursGrp, array_keys($user->listeCoursProf()))) {
			$identite = $user->identite();
			$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
			$listeTravaux = $Bulletin->listeTravaux($coursGrp,$bulletin);
			$module = Application::repertoireActuel();
			$listeCompetences = current($Bulletin->listeCompetences($coursGrp));
			$listeCotes = ($listeTravaux != Null)?$Bulletin->listeCotesCarnet($listeTravaux):Null;
			$listeMoyennes = $Bulletin->listeMoyennesCarnet($listeCotes);
			$smarty->assign('identite',$identite);
			$smarty->assign('acronyme',$acronyme);
			$smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('listeTravaux', $listeTravaux);
			$smarty->assign('listeCotes', $listeCotes);
			$smarty->assign('listeMoyennes', $listeMoyennes);
			$smarty->assign('listeCompetences', $listeCompetences);
			$smarty->assign('module',$module);
			$smarty->assign ('corpsPage', 'showCarnet');
			}
		break;

	case 'oneClick':
		$effaceDetails = isset($_POST['effaceDetails'])?true:Null;
		$smarty->assign('effaceDetails',$effaceDetails);
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
						// effacement préalable du bulletin si souhaité
						if ($effaceDetails == true) {
							$Bulletin->effaceDetailsBulletin($bulletin,current($listeCompetences),$coursGrp, $listeLocks,$listeEleves);
							}
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
						$listeSituations = $Bulletin->listeSituationsCours($listeEleves, $coursGrp, null, true);

						$texte = sprintf('%d cotes enregistré(s)<br>%d cotes refusées', $Res['ok'],$Res['ko']);
						if ($Res['ko']>0) {
							$texte .= ' (bulletin verrouillé?)';
							$erreurVerrou = true;
							$smarty->assign('erreurVerrou',$erreurVerrou);
							}
							else {
								$texte .= '<br>Le bulletin complété est <a href="index.php?action=gestEncodageBulletins">à votre disposition</a>';
								$smarty->assign('noError',true);
								}

						$smarty->assign('texte',$texte);
					}
				// pas de break;
			default:
				$listeColonnes = $Bulletin->colonnesCotesBulletin($coursGrp, $bulletin);
				// s'il n'y a pas de cotes, on arrête là...
				if (count($listeColonnes) == 0) {
						$smarty->assign('erreurTransfert', true);
						$smarty->assign('corpsPage', 'noTransfert');
						}
					else {
					$smarty->assign('erreurTransfert',false);
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

				break;
			}
		break;
	case 'poidsCompetences':
		if ($etape == 'enregistrer') {
			if ($coursGrp && in_array($coursGrp, array_keys($listeCours))) {
				$nbResultats = $Bulletin->recordPoidsCompetences($_POST);
				$smarty->assign('message', array(
					'title'=>'Enregistrement',
					'texte'=> sprintf('%d poids enregistré(s)',$nbResultats),
					'urgence'=>'success')
					);
				}
			}
		$sommesPonderations = $Bulletin->sommesPonderations($coursGrp);
		$listeTravaux = $Bulletin->listeTravaux($coursGrp,$bulletin);
		$listeCompetences = current($Bulletin->listeCompetences($coursGrp));
		$tableauPoids = $Bulletin->listePoidsCompetences($coursGrp, $listeCompetences);
		$listeCotes = ($listeTravaux != Null)?$Bulletin->listeCotesCarnet($listeTravaux):Null;
		$smarty->assign('ponderations', $sommesPonderations);
		$smarty->assign('listeCompetences', $listeCompetences);
		$smarty->assign('tableauPoids', $tableauPoids);
		$smarty->assign('selecteur', 'selectCours');
		$smarty->assign('corpsPage', 'showPoidsCompetences');
		break;

	}
?>
