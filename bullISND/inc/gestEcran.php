<?php

$etape = isset($_REQUEST['etape']) ? $_REQUEST['etape'] : Null;
$bulletin = isset($_REQUEST['bulletin']) ? $_REQUEST['bulletin'] : PERIODEENCOURS;

$unAn = time() + 365 * 24 * 3600;
$classe = Application::postOrCookie('classe', $unAn);
$smarty->assign('classe', $classe);

$matricule = Application::postOrCookie('matricule', $unAn);
$smarty->assign('matricule',$matricule);

// liste des élèves si une classe a été sélectionnée
if ($classe != Null)
	$listeEleves = $Ecole->listeEleves($classe, 'groupe', false);
	else $listeEleves = Null;
$smarty->assign('listeEleves', $listeEleves);

// préparation du sélecteur pour l'étape suivante
$smarty->assign('action', 'ecran');
$smarty->assign('mode', 'bulletinIndividuel');
$smarty->assign('etape', 'showEleve');
// numéro du bulletin en cours, numéro de la période
$smarty->assign('bulletin', $bulletin);
// nombre de bulletions pour la création de la liste des périodes
$smarty->assign('nbBulletins', NBPERIODES);
// liste des classes pour le sélecteur en haut de page
$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('selecteur', 'selectBulletinClasseEleve');

if ($etape == 'showEleve') {
	$annee = $Ecole->anneeDeClasse($classe);
	$eleve = new Eleve($matricule);
	$infoPersoEleve = $eleve->getDetailsEleve();
	// liste de tous les cours suivis par cet élève durant la période $bulletin (historique pris en compte)
	$listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin, true);
	// il n'y a qu'un élève, il n'y aura donc qu'une seule liste de pondérations
	if ($listeCoursGrp) {
		// liste des cours avec sous-groupe de l'élève
		$listeCoursGrp = $listeCoursGrp[$matricule];
		// liste des profs pour les cours de l'élève
		$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);
		// situation en points au bulletin précédent
		$listeSituations = $Bulletin->listeSituationsCours($matricule, array_keys($listeCoursGrp), Null, true);
		$sitPrecedentes = $Bulletin->situationsPrecedentes($listeSituations,$bulletin);
		// situation en points pour la période en cours
		$sitActuelles = $Bulletin->situationsPeriode($listeSituations, $bulletin);
		// liste des compétences pour les cours de l'élève
		$listeCompetences = $Bulletin->listeCompetencesListeCoursGrp($listeCoursGrp);
		$listeCotes = $Bulletin->listeCotes($matricule, $listeCoursGrp, $listeCompetences, $bulletin);
		// liste des cotes tenant compte de la pondération pour la période
		$ponderations = $Bulletin->getPonderations($listeCoursGrp, $bulletin);
		$cotesPonderees = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);
		// commentaires des profs pour les différents cours de l'élève
		$commentairesCotes = $Bulletin->listeCommentairesTousCours($matricule, $bulletin);
		// mention attribuée à l'élève (en période de délibération)
		$mentions = $Bulletin->listeMentions($matricule, $bulletin);
		// commentaires des éducateurs de l'élève
		$commentairesEducs = $Bulletin->listeCommentairesEduc($matricule, $bulletin);
		$commentairesEducs = isset($commentairesEducs[$matricule][$bulletin]) ? $commentairesEducs[$matricule][$bulletin] : Null;
		// commentaire du prof titulaire de l'élève
		$remarqueTitulaire = $Bulletin->remarqueTitu($matricule, $bulletin);
		if ($remarqueTitulaire != Null)
			$remarqueTitulaire = $remarqueTitulaire[$matricule][$bulletin];
		// notice pour la poursuite du parcours scolaire
		$noticeParcours = $Bulletin->getNoticesParcours($matricule, $annee);
		$noticeParcours = isset($noticeParcours[$annee]) ? $noticeParcours[$annee] : Null;
		// liste des attitudes attendues pour l'élève
		$tableauAttitudes = $Bulletin->tableauxAttitudes($matricule, $bulletin);
		// note de la direction
		$noticeDirection = $Bulletin->noteDirection($annee, $bulletin);

		// année d'étude: premier caractère de la classe ou du groupe
		$smarty->assign('annee', $annee);
		// année scolaire sous la forme XXXX-YYYY Ex: 2020-2021
		$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);
		$smarty->assign('infoPerso', $infoPersoEleve);
		// liste des cours avec sous-groupe de l'élève
		$smarty->assign('listeCoursGrp', $listeCoursGrp);
		// liste des profs pour les cours de l'élève
		$smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);
		// situation en points au bulletin précédent
		$smarty->assign('sitPrecedentes', $sitPrecedentes);
		// situation en points pour la période en cours
		$smarty->assign('sitActuelles', $sitActuelles);
		// liste des cotes prises en compte pour le calcul de la situation actuelle
		$smarty->assign('listeCotes', $listeCotes);
		// liste des compétences pour les cours de l'élève
		$smarty->assign('listeCompetences', $listeCompetences);
		// liste des cotes tenant compte de la pondération pour la période
		$smarty->assign('cotesPonderees', $cotesPonderees);
		// commentaires des profs pour les différents cours de l'élève
		$smarty->assign('commentaires', $commentairesCotes);
		// commentaires des profs pour les différents cours de l'élève
		$smarty->assign('attitudes', $tableauAttitudes);
		// commentaires des éducateurs de l'élève
		$smarty->assign('commentairesEducs', $commentairesEducs);
		// notice pour la poursuite du parcours scolaire
		$smarty->assign('noticeParcours', $noticeParcours);
		// commentaire du prof titulaire de l'élève
		$smarty->assign('remTitu', $remarqueTitulaire);
		// mention attribuée à l'élève (en période de délibération
		$smarty->assign('mention', $mentions);
		// note de la direction
		$smarty->assign('noticeDirection', $noticeDirection);
	}
	$smarty->assign('corpsPage', 'bulletinEcran');
}
