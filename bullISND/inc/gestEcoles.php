<?php
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$mode = isset($_REQUEST['ecole'])?$_REQUEST['ecole']:Null;
$niveau = isset($_REQUEST['niveau'])?$_REQUEST['niveau']:Null;
$ecole = isset($_POST['ecole'])?$_POST['ecole']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;

$smarty->assign("selecteur","selectBulletinNiveauEcole");
$smarty->assign("listeNiveaux",$Ecole->listeNiveaux());
$smarty->assign("nbBulletins", NBPERIODES);
$smarty->assign("etape", "show");
$smarty->assign("niveau", $niveau);
$smarty->assign("action", "parEcole");
$smarty->assign("bulletin", $bulletin);
$smarty->assign("ecole", $ecole);

if (isset($niveau)) 
	$smarty->assign("listeEcoles", $Bulletin->listeEcoles($niveau));

if (isset($niveau) && isset($ecole)) {
	$detailsEcole = $Bulletin->ecole($ecole);
	// liste des élèves de ce niveau pour l'école sélectionnée
	$listeEleves = $Bulletin->listeElevesEcoleNiveau($niveau, $ecole);
	// liste de tous les cours suivis par les élèves dont la liste est fournie (tous les élèves ne suivant pas forcément tous les cours)
	$listeCoursGroupeEleves = $Ecole->listeCoursGrpEleves($listeEleves);
	// liste des situations sur 100 au bulletin mentionné pour la liste des élèves fournie
	$listeSituations100 = $Bulletin->getSituations100($bulletin, $listeEleves);
	$smarty->assign("detailsEcole", $detailsEcole);
	$smarty->assign("listeEleves", $listeEleves);
	$smarty->assign("listeCoursEleves", $listeCoursGroupeEleves);
	$smarty->assign("listeSituations", $listeSituations100);
	$smarty->assign("corpsPage", "grilleEcole");
	}
	
?>
