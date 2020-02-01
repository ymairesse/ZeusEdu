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
	setcookie('coursGrp',$coursGrp,$unAn,null,null,false,true);
	}
	else $coursGrp = isset($_COOKIE['coursGrp'])?$_COOKIE['coursGrp']:Null;

$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;

$annee = substr($coursGrp,0,1);

$smarty->assign('bulletin',$bulletin);
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('tableErreurs',Null);

$smarty->assign('COTEABS',COTEABS);
$smarty->assign('COTENULLE',COTENULLE);

// y compris les élèves dont la SECTION  n'est pas précisée
$sections = '"'.implode('","', explode(",", SECTIONS)).'"'.',""';

$listeCours = $user->listeCoursProf($sections, true);
$smarty->assign('listeCours',$listeCours);

// le cours actif appartient-il bien à l'utilisateur actif?
if ($coursGrp && in_array($coursGrp, array_keys($listeCours))) {
	// quels sont ses élèves
	$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
	// quelles sont les pondérations par période pour ce cours
	$ponderations = $Bulletin->getPonderations($coursGrp, $bulletin);
	// quelle est la liste des compétences pour ce cours
	$listeCompetences = $Bulletin->listeCompetences($coursGrp);
	// est-ce une période avec délibération?
	$isDelibe = in_array($bulletin, explode(',', PERIODESDELIBES));

	if ($mode == 'enregistrer') {

		// organiser les données: cotes, attitudes, commentaires dans des tableaux séparés
		$dataFromBulletin = $Bulletin->organiserData($_POST);

		$tableErreurs = $Bulletin->enregistrerBulletin($dataFromBulletin, $coursGrp, $bulletin);
		$smarty->assign('tableErreurs', $tableErreurs);

		// -------------------------------------------------------------------------------------
		// recalculs APRES ENREGISTREMENT ------------------------------------------------------
		// recherche de la liste des nouvelles cotes par élève, par compétence et par type (form ou cert) dans le bulletion indiqué
		$listeCotes = $Bulletin->listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);

		// recherche de la liste des cotes globales pour la période, en tenant compte de la pondération
		$listeGlobalPeriodePondere = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);

		// recherche la liste des situations de tous les élèves du cours, pour tous les bulletins existants dans la BD
		$listeSituationsAvant = $Bulletin->listeSituationsCours($listeEleves, $coursGrp, null, $isDelibe);

		// calcule les nouvelles situations pour tous les bulletins, à partir des situations existantes et du globalPeriode
		$listeSituations = $Bulletin->calculeNouvellesSituations($listeSituationsAvant, $listeGlobalPeriodePondere, $bulletin);

		$Bulletin->enregistrerSituations($listeSituations, $bulletin);
		}

	// liste des élèves EBS
	$listeEBS = $Ecole->getEBS($coursGrp, 'coursGrp');
	$smarty->assign('listeEBS', $listeEBS);

	// recherche la liste des situations de tous les élèves du cours, pour tous les bulletins existants dans la BD
	// cette liste doit être re-générée après l'enregistrement qui vient (éventuellement) d'avoir lieu
	$listeSituations = $Bulletin->listeSituationsCours($listeEleves, $coursGrp, null, $isDelibe);


	// recherche de la liste des cotes par élève, par compétence et par type (form ou cert) dans le bulletion indiqué
	if (!(isset($listeCotes)))  // si on a enregistré, on a déjà la liste des cotes; alors, on saute cette étape
		$listeCotes = $Bulletin->listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);

	// recherche de la liste des cotes globales pour la période, en tenant compte de la pondération	-----------------------------
	if (!(isset($listeGlobalPeriodePondere))) // si on a enregistré, on a déjà la liste des cotes; alors, on saute cette étape
		$listeGlobalPeriodePondere = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);


	// ---------------------------------------------------------------------------------------------------------------------------
	// cote étoilée: le certificatif est supérieur à l'ensemble formatif+certificatif --------------------------------------------
	$listeSommesFormCert = $Bulletin->listeSommesFormCert($listeCotes);
	$listeCotesEtoilees = $Bulletin->listeCotesEtoilees($listeSommesFormCert, $listeSituations, $coursGrp, $bulletin);
	$smarty->assign('listeCotesEtoilees', $listeCotesEtoilees);
	// ---------------------------------------------------------------------------------------------------------------------------

	// ---------------------------------------------------------------------------------------------------------------------------
	// calcul de la situation sans tenir compte de la première année du degré (uniquement pour les années d'études concernées) ---
	if (in_array($annee,explode(',',ANNEEDEGRE))
		&& ($bulletin == NBPERIODES)) {  // uniquement pour la dernière période de l'année
		$sitDeuxiemesAnnee = $Bulletin->situationsDeuxieme($listeEleves, $coursGrp, $bulletin);
		}
		else $sitDeuxiemesAnnee = Null;
	$smarty->assign('sitDeuxiemes', $sitDeuxiemesAnnee);
	// ---------------------------------------------------------------------------------------------------------------------------

	// ---------------------------------------------------------------------------------------------------------------------------
	// liste des cotes de l'épreuve externe pour ce cours  seulement en juin (dernière période de l'année)) ------------------------------------------------------------------------
	if ($bulletin == NBPERIODES)  // uniquement pour la dernière période de l'année scolaire
		$listeCotesExternes = $Bulletin->listeCotesEprExterne($coursGrp, ANNEESCOLAIRE);
		else $listeCotesExternes = Null;
	$smarty->assign('listeCotesExternes',$listeCotesExternes);
	// ---------------------------------------------------------------------------------------------------------------------------

	// pour le premier degré seulement, classes de 1e et 2e
	if ($annee < 3)  // À FAIRE: prévoir un point de configuration plutôt que ce forçage en dur
		$listeAttitudes = $Bulletin->listeAttitudes($listeEleves, $coursGrp, $bulletin);
		else $listeAttitudes = Null;

	$situationsPrecedentes = $Bulletin->situationsPrecedentes($listeSituations, $bulletin);

	$smarty->assign('situationsPrecedentes', $situationsPrecedentes);
	$smarty->assign('listeEleves', $listeEleves);
	$smarty->assign('listeCotes',$listeCotes);

	$smarty->assign('listeVerrous', $Bulletin->listeLocksBulletin($listeEleves, $coursGrp, $bulletin));
	$smarty->assign('listeCommentaires', $Bulletin->listeCommentaires($listeEleves, $coursGrp));
	$smarty->assign('action','gestEncodageBulletins');
	$smarty->assign('intituleCours', $Bulletin->intituleCours($coursGrp));
	$smarty->assign('listeClasses', $Bulletin->classesDansCours($coursGrp));
	$smarty->assign('listeCompetences', $listeCompetences);
	$smarty->assign('listeSommesFormCert', $listeSommesFormCert);
	$smarty->assign('listeAttitudes', $listeAttitudes);
	$smarty->assign('listeGlobalPeriodePondere', $listeGlobalPeriodePondere);
	$smarty->assign('ponderations', $ponderations);
	$smarty->assign('listeSituations', $listeSituations);


	$smarty->assign('PERIODESDELIBES', explode(',',PERIODESDELIBES));
	$smarty->assign('listeElevesSuivPrec', $Bulletin->listeElevesSuivPrec($listeEleves));
	$smarty->assign('matricule', $matricule);

	$readonly = ($bulletin < PERIODEENCOURS)?"readonly":"";
	// PERMETTRE AUX ADMIN DE PASSER OUTRE LE READONLY
	if ($user->userStatus($module) == 'admin')
		$readonly = "";
	$smarty->assign('readonly', $readonly);
	$smarty->assign('corpsPage', 'encodageBulletin');
	}

// par défaut
$smarty->assign('mode','encodage');
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('selecteur', 'selecteurs/selectBulletinCours');
$smarty->assign('action','gestEncodageBulletins');
