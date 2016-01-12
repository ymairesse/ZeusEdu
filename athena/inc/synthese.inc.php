<?php
if ($etape == 'showliste') {
	$dateDebut = $_POST['dateDebut'];
	$dateFin = $_POST['dateFin'];
	$dateDebutSQL = implode("-",array_reverse(explode("/",$dateDebut)));
	$dateFinSQL = implode("-",array_reverse(explode("/",$dateFin)));
	$smarty->assign("dateDebut", $dateDebut);
	$smarty->assign("dateFin", $dateFin);
	if ($dateDebut && $dateFin && ($dateDebutSQL <= $dateFinSQL)) {
		$listeVisites = visiteInfirmerie::listeVisitesParDate($dateDebutSQL, $dateFinSQL);
		$smarty->assign('listevisites', $listeVisites);
		$smarty->assign('corpsPage', 'listesParDates');
		}
	}
$smarty->assign('etape','showliste');
$smarty->assign('selecteur','selectPeriode');

?>