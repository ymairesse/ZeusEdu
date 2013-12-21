<?php
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
$notice = isset($_POST['notice'])?$_POST['notice']:Null;

$listeNiveaux = $Ecole->listeNiveaux();
$smarty->assign("niveau", $niveau);
$smarty->assign("listeNiveaux", $listeNiveaux);	
$smarty->assign("nbBulletins", NBPERIODES);

switch ($etape) {
	case 'enregistrer':
		if ($niveau && $bulletin) {
			$nb = $Bulletin->saveNoticeCoordinateurs($niveau, $bulletin, $notice);
			$smarty->assign("bulletin", $bulletin);
			$smarty->assign("message", array(
					'title'=>"Enregistrement",
					'texte'=>"$nb modification(s) enregistrée(s)")
					);			
			}
		// pas de break	
	case 'showNiveau':
		$smarty->assign("selecteur", "selectBulletinNiveau");
		$smarty->assign("bulletin", $bulletin);
		$smarty->assign("action", "nota");
		if ($niveau && $bulletin) {
			$notice = $Bulletin->noticeCoordinateurs($bulletin, $niveau);
			$smarty->assign("notice", $notice);
			$smarty->assign("corpsPage", "formNotas");
			}
		break;
	
	default: 
		$listeNiveaux = $Ecole->listeNiveaux();
		$smarty->assign("selecteur", "selectBulletinNiveau");
		$smarty->assign("bulletin", $bulletin);
		$smarty->assign("action", "nota");
		$smarty->assign("mode", "redaction");
		break;
	}
?>
