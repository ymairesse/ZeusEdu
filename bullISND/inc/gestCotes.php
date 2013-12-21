<?php
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$coursGrp = isset($_REQUEST['coursGrp'])?$_REQUEST['coursGrp']:Null;
$bulletin = isset($_REQUEST['bulletin'])?$_REQUEST['bulletin']:PERIODEENCOURS;

switch ($mode) {
	case 'voir':
		$smarty->assign("selecteur", "selectBulletinCours");
		$smarty->assign("nbBulletins", NBPERIODES);
		$smarty->assign("bulletin", $bulletin);
		$smarty->assign("action", "gestionCotes");
		$smarty->assign("mode","voir");
		if ($etape == 'showCotes') {
			$listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha');
			$ponderations = $Bulletin->getPonderations($coursGrp, $bulletin);
			$listeCompetences = $Bulletin->listeCompetences($coursGrp);
			$listeCotes = $Bulletin->listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);
			$smarty->assign("coursGrp", $coursGrp);
			$smarty->assign("listeCompetences", $listeCompetences);
			$smarty->assign("cours", $Bulletin->intituleCours($coursGrp));
			$smarty->assign("cotesCours", $Bulletin->recapCotesCours($listeEleves, $listeCompetences, $coursGrp, $bulletin));
			$smarty->assign("ponderations", $ponderations);
			$smarty->assign("listeGlobalPeriodePondere", $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin));
			$smarty->assign("corpsPage", "showCotesCours");
		}
		break;
	default: die ("missing mode");
	}
?>
