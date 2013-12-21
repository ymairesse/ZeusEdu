<?php
require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");
$flashInfo = new flashInfo();
switch ($mode) {
	case 'edit':
		switch ($etape) {
			case 'enregistrer':
				$data = $_POST;
				// il faudrait vérifier le contenu de $_POST
				$data['application'] = $module;
				$nb = $flashInfo->saveFlashInfo($data);
				$smarty->assign('action','news');
				$smarty->assign('mode','');
				$smarty->assign("message", array(
							'title'=>"Enregistrement",
							'texte'=>"$nb nouvelle(s) enregistrée(s)")
							);
				$smarty->assign("flashInfos", $flashInfo->listeFlashInfos($module));
				$smarty->assign("corpsPage", "news");
				break;
			default:		// mode édition
				$flashInfo = $flashInfo->getData($id);
				$smarty->assign("flashInfo",$flashInfo);
				$smarty->assign("action","news");
				$smarty->assign("mode","edit");
				$smarty->assign("etape","enregistrer");
				$smarty->assign("corpsPage", "editFlashInfo");
				break;
			}
		break;
	default:
		$smarty->assign("flashInfos", $flashInfo->listeFlashInfos ($module));
		$smarty->assign("corpsPage", "news");
		break;
	}
?>
