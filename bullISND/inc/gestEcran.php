<?php

$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$bulletin = isset($_REQUEST['bulletin'])?$_REQUEST['bulletin']:PERIODEENCOURS;

$unAn = time() + 365 * 24 * 3600;
$classe = Application::postOrCookie('classe', $unAn);
$smarty->assign('classe', $classe);

$matricule = Application::postOrCookie('matricule', $unAn);
$smarty->assign('matricule',$matricule);

switch ($mode) {
	case 'bulletinIndividuel':
		$listeClasses = $Ecole->listeGroupes(array('G','TT'));

		if ($classe != Null)
			$listeEleves = $Ecole->listeEleves($classe, 'groupe', false);
			else $listeEleves = Null;

		$smarty->assign('selecteur', 'selectBulletinClasseEleve');
		$smarty->assign('etape','showEleve');
		$smarty->assign('listeClasses', $listeClasses);
		$smarty->assign('listeEleves', $listeEleves);
		$smarty->assign('nbBulletins', NBPERIODES);
		$smarty->assign('bulletin', $bulletin);
		$smarty->assign('action', 'ecran');
		$smarty->assign('mode', 'bulletinIndividuel');
		if ($etape == 'showEleve') {
			$annee = $Ecole->anneeDeClasse($classe);
			$eleve = new Eleve($matricule);
			$infoPersoEleve = $eleve->getDetailsEleve();
			// liste de tous les cours suivis par cet élève durant la période $bulletin (historique pris en compte)
			$listeCoursGrp = $Bulletin->listeCoursGrpEleves($matricule, $bulletin);
			// il n'y a qu'un élève, il n'y aura donc qu'une seule liste de pondérations
			if ($listeCoursGrp) {
				$listeCoursGrp = $listeCoursGrp[$matricule];
				$listeProfsCoursGrp = $Ecole->listeProfsListeCoursGrp($listeCoursGrp);
				$listeSituations = $Bulletin->listeSituationsCours($matricule, array_keys($listeCoursGrp), Null, true);
				$sitPrecedentes = $Bulletin->situationsPrecedentes($listeSituations,$bulletin);
				$sitActuelles = $Bulletin->situationsPeriode($listeSituations, $bulletin);
				$listeCompetences = $Bulletin->listeCompetencesListeCoursGrp($listeCoursGrp);
				$listeCotes = $Bulletin->listeCotes($matricule, $listeCoursGrp, $listeCompetences, $bulletin);

				$ponderations = $Bulletin->getPonderations($listeCoursGrp, $bulletin);
				$cotesPonderees = $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin);

				$commentairesCotes = $Bulletin->listeCommentairesTousCours($matricule, $bulletin);
				$mentions = $Bulletin->listeMentions($matricule, $bulletin);

				$commentairesEducs = $Bulletin->listeCommentairesEduc($matricule, $bulletin);
				$commentairesEducs = isset($commentairesEducs[$matricule][$bulletin]) ? $commentairesEducs[$matricule][$bulletin] : Null;

				$remarqueTitulaire = $Bulletin->remarqueTitu($matricule, $bulletin);
				if ($remarqueTitulaire != Null)
					$remarqueTitulaire = $remarqueTitulaire[$matricule][$bulletin];
				$tableauAttitudes = $Bulletin->tableauxAttitudes($matricule, $bulletin);
				$noticeDirection = $Bulletin->noteDirection($annee, $bulletin);

				$smarty->assign('annee',$annee);
				$smarty->assign('ANNEESCOLAIRE',ANNEESCOLAIRE);
				$smarty->assign('infoPerso', $infoPersoEleve);
				$smarty->assign('listeCoursGrp', $listeCoursGrp);
				$smarty->assign('listeProfsCoursGrp', $listeProfsCoursGrp);
				$smarty->assign('sitPrecedentes', $sitPrecedentes);
				$smarty->assign('sitActuelles', $sitActuelles);
				$smarty->assign('listeCotes', $listeCotes);
				$smarty->assign('listeCompetences', $listeCompetences);

				$smarty->assign('cotesPonderees', $cotesPonderees);
				$smarty->assign('commentaires', $commentairesCotes);
				$smarty->assign('attitudes', $tableauAttitudes);
				$smarty->assign('commentairesEducs', $commentairesEducs);
				$smarty->assign('remTitu', $remarqueTitulaire);
				$smarty->assign('mention',$mentions);
				$smarty->assign('noticeDirection', $noticeDirection);
			}
			$smarty->assign('corpsPage', 'bulletinEcran');
		}
		break;
	default: die ('missing mode');
	}
