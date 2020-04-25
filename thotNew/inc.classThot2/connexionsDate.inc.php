<?php
if ($etape == 'showConnexions') {
	$dateDebut = isset($_POST['dateDebut'])?$_POST['dateDebut']:Null;
	$dateFin = isset($_POST['dateFin'])?$_POST['dateFin']:Null;
	$dateDebutSQL = implode("-",array_reverse(explode("/",$dateDebut)));
	$dateFinSQL = implode("-",array_reverse(explode("/",$dateFin)));
	$smarty->assign("dateDebut", $dateDebut);
	$smarty->assign("dateFin", $dateFin);
	if ($dateDebut && $dateFin && ($dateDebutSQL <= $dateFinSQL)) {
		$listeConnexions = $Thot->listeConnexionsParDate($dateDebutSQL, $dateFinSQL);

		$smarty->assign('listeConnexions', $listeConnexions);
		$smarty->assign('corpsPage', 'listesParDates');
		}

}

$smarty->assign('etape','showConnexions');
$smarty->assign('selecteur', 'selecteurs/selectPeriode');
