<?php

$unAn = time() + 365*24*3600;
$bulletin = isset($_REQUEST['bulletin'])?$_REQUEST['bulletin']:PERIODEENCOURS;
if (isset($_POST['tri'])) {
	$tri = $_POST['tri'];
	setcookie('tri',$tri,$unAn, null, null, false, true);
	}
	else $tri = isset($_COOKIE['tri'])?$_COOKIE['tri']:Null;
$smarty->assign('tri', $tri);

if (isset($_POST['coursGrp'])) {
	$coursGrp = $_POST['coursGrp'];
	setcookie('coursGrp',$coursGrp,$unAn, null, null, false, true);
	}
	else $coursGrp = isset($_COOKIE['coursGrp'])?$_COOKIE['coursGrp']:Null;

$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;

$smarty->assign('bulletin', $bulletin);
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('tableErreurs',Null);

$smarty->assign('COTEABS',COTEABS);
$smarty->assign('COTENULLE',COTENULLE);

if ($coursGrp && in_array($coursGrp, array_keys($user->listeCoursProf()))) {
	$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
	$ponderations = $Bulletin->getPonderations($coursGrp, $bulletin);
	$listeCompetences = $Bulletin->listeCompetences($coursGrp);
	// est-ce une période avec délibération?
	$isDelibe = in_array($bulletin, explode(',', PERIODESDELIBES));
	switch ($mode) {
		case 'enregistrer':
			// organiser les données: cotes, attitudes, commentaires dans des tableaux séparés
			$dataFromBulletin = $Bulletin->organiserData($_POST);
			$tableErreurs = $Bulletin->enregistrerBulletin($dataFromBulletin, $coursGrp, $bulletin);
			$smarty->assign("tableErreurs", $tableErreurs);
			
			// -------------------------------------------------------------------------------------
			// recalculs APRES ENREGISTREMENT ------------------------------------------------------
			// recherche de la liste des nouvelles cotes par élève, par compétence et par type (form ou cert) dans le bulletion indiqué
			$listeCotes = $Bulletin->listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);
			// recherche de la liste des cotes globales pour la période, en tenant compte de la pondération		
			$listeGlobalPeriodePondere = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);
			// recherche la liste des situations de tous les élèves du cours, pour tous les bulletins existants dans la BD
			$listeSituationsAvant = $Bulletin->listeSituationsCours($listeEleves, $coursGrp, null, $isDelibe);
			// calcule les nouvelles situations pour ce bulletin, à partir des situations existantes et du globalPeriode
			$listeSituations = $Bulletin->calculeNouvellesSituations($listeSituationsAvant, $listeGlobalPeriodePondere, $bulletin);
			$Bulletin->enregistrerSituations($listeSituations, $bulletin);
			// break;  pas de break, on continue
		default:
			// recherche la liste des situations de tous les élèves du cours, pour tous les bulletins existants dans la BD
			$listeSituations = $Bulletin->listeSituationsCours($listeEleves, $coursGrp, null, $isDelibe);

			// recherche de la liste des cotes par élève, par compétence et par type (form ou cert) dans le bulletion indiqué
			if (!(isset($listeCotes)))
				$listeCotes = $Bulletin->listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);
			// recherche de la liste des cotes globales pour la période, en tenant compte de la pondération	
			if (!(isset($listeGlobalPeriodePondere)))
				$listeGlobalPeriodePondere = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);
			break;
		}

	$situationsPrecedentes = $Bulletin->situationsPrecedentes($listeSituations, $bulletin);
	$listeLockElevesCours = $Bulletin->listeLocksBulletin($listeEleves, $coursGrp, $bulletin);
	$annee = substr($coursGrp,0,1);
	// pour le premier degré seulement, classes de 1e et 2e
	if ($annee < 3)
		$listeAttitudes = $Bulletin->listeAttitudes($listeEleves, $coursGrp, $bulletin);
		else $listeAttitudes = Null;
	// calcul de la situation sans tenir compte de la première année
	if (($annee == 2) && ($bulletin == NBPERIODES))
		$sitDeuxiemes = $Bulletin->situationsDeuxieme ($listeEleves, $coursGrp, $bulletin);
		else $sitDeuxiemes = Null;

	$smarty->assign('situationsPrecedentes', $situationsPrecedentes);
	$smarty->assign('listeEleves', $listeEleves);
	$smarty->assign('listeCotes',$listeCotes);
	
	$smarty->assign('listeVerrous',$Bulletin->listeLocksBulletin($listeEleves, $coursGrp, $bulletin));
	$smarty->assign('listeCommentaires', $Bulletin->listeCommentaires($listeEleves, $coursGrp));
	$smarty->assign('action','gestEncodageBulletins');
	$smarty->assign('intituleCours',$Bulletin->intituleCours($coursGrp));
	$smarty->assign('listeClasses', $Bulletin->classesDansCours($coursGrp));
	$smarty->assign('listeCompetences', $listeCompetences);
	$smarty->assign('listeSommesFormCert', $Bulletin->listeSommesFormCert($listeCotes));
	$smarty->assign('listeAttitudes', $listeAttitudes);
	$smarty->assign('listeGlobalPeriodePondere', $listeGlobalPeriodePondere);
	$smarty->assign('ponderations', $ponderations);
	$smarty->assign('listeSituations', $listeSituations);
	$smarty->assign('sitDeuxiemes', $sitDeuxiemes);
	
	$smarty->assign('PERIODESDELIBES', explode(',',PERIODESDELIBES));
	$smarty->assign('listeElevesSuivPrec', $Bulletin->listeElevesSuivPrec($listeEleves));
	$smarty->assign('matricule', $matricule);
	
	$readonly = ($bulletin < PERIODEENCOURS)?"readonly":"";
	// PERMETTRE AUX ADMIN DE PASSER OUTRE LE READONLY
	if ($user->userStatus($module) == 'admin')
		$readonly = "";
	$smarty->assign("readonly", $readonly);	
	$smarty->assign("corpsPage", "encodageBulletin");
	}
	
// par défaut
$smarty->assign('mode','encodage');
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('selecteur', 'selectBulletinCours');
$smarty->assign('action','gestEncodageBulletins');

?>
