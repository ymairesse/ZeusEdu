<?php
$unAn = time() + 365*24*3600;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$bulletin = isset($_REQUEST['bulletin'])?$_REQUEST['bulletin']:PERIODEENCOURS;

if (isset($_POST['coursGrp'])) {
	$coursGrp = $_POST['coursGrp'];
	setcookie('coursGrp',$coursGrp,$unAn, null, null, false, true);
	}
	else $coursGrp = $_COOKIE['coursGrp'];
$smarty->assign('coursGrp', $coursGrp);

if (isset($_POST['tri'])) {
	$tri = $_POST['tri'];
	setcookie('tri',$tri,$unAn, null, null, false, true);
	}
	else $tri = $_COOKIE['tri'];
$smarty->assign('tri', $tri);

switch ($mode) {
	case 'voir':
		$smarty->assign('selecteur', 'selectBulletinCours');
		$smarty->assign('nbBulletins', NBPERIODES);
		$smarty->assign('bulletin', $bulletin);
		$smarty->assign('action', 'gestionCotes');
		$smarty->assign('mode','voir');
		if ($etape == 'showCotes') {
			$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
			$ponderations = $Bulletin->getPonderations($coursGrp, $bulletin);
			$listeCompetences = $Bulletin->listeCompetences($coursGrp);
			$listeCotes = $Bulletin->listeCotes($listeEleves, $coursGrp, $listeCompetences, $bulletin);
			$smarty->assign('listeCompetences', $listeCompetences);
			$smarty->assign('cours', $Bulletin->intituleCours($coursGrp));
			$smarty->assign('cotesCours', $Bulletin->recapCotesCours($listeEleves, $listeCompetences, $coursGrp, $bulletin));
			$smarty->assign('ponderations', $ponderations);
			$smarty->assign('listeGlobalPeriodePondere', $Bulletin->listeGlobalPeriodePondere($listeCotes, $ponderations, $bulletin));
			$smarty->assign('corpsPage', 'showCotesCours');
		}
		break;
	default: die ('missing mode');
	}
?>
