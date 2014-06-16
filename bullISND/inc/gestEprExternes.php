<?php
$unAn = time() + 365*24*3600;

if (isset($_POST['tri'])) {
	$tri = $_POST['tri'];
	setcookie('tri',$tri,$unAn, null, null, false, true);
	}
	else $tri = $_COOKIE['tri'];
$smarty->assign('tri', $tri);

// la liste de tous les cours du prof
$listeCoursProf = $user->listeCoursProf("'G','S','TT'");;
// on ne retient que les cours qui se trouvent aussi dans la table des épreuves externes
$listeCours = $Bulletin->listeCoursEprExterne($listeCoursProf);
$smarty->assign('listeCours', $listeCours);

$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('etape',$etape);

$smarty->assign('COTEABS', COTEABS);

if ($coursGrp) {
	if ($etape == 'enregistrer') {
		$resultat = $Bulletin->enregistrerEprExternes($_POST);
		$tableErreurs = $resultat['erreurs'];
		$smarty->assign('tableErreurs',$tableErreurs);
		$smarty->assign("message", array(
				'title'=>"Enregistrement",
				'texte'=>$resultat['nb']." enregistrements modifiées")
				);
		}
	$listeEleves = $Ecole->listeElevesCours($coursGrp, $tri);
	$listeCotes = $Bulletin->listeCotesEprExterne($coursGrp);
	$listeSituationsBulletin = $Bulletin->listeSituationsCours($listeEleves,$coursGrp,NBPERIODES);
	$smarty->assign('listeSituations', $listeSituationsBulletin);
	$smarty->assign('NBPERIODES',NBPERIODES);
	$smarty->assign('listeEleves', $listeEleves);
	$smarty->assign('listeCotes',$listeCotes);
	$smarty->assign('etape','enregistrer');
		
	$smarty->assign('intituleCours',$Bulletin->intituleCours($coursGrp));
	$smarty->assign('listeClasses',$Bulletin->classesDansCours($coursGrp));

	//$readonly = ($bulletin < PERIODEENCOURS)?'readonly':'';
	//// PERMETTRE AUX ADMIN DE PASSER OUTRE LE READONLY
	//if ($user->userStatus($module) == 'admin')
	//	$readonly = '';
	//$smarty->assign('readonly', $readonly);
	$smarty->assign('corpsPage', 'gestEprExternes');
	}
	
// par défaut

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('selecteur','selectCours');
$smarty->assign('action','gestEprExternes');

?>
