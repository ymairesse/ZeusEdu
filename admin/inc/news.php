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
				$smarty->assign('flashInfo',$flashInfo);
				$smarty->assign('action','news');
				$smarty->assign('mode','edit');
				$smarty->assign('etape','enregistrer');
				$smarty->assign('corpsPage', 'editFlashInfo');
				break;
			}
		break;
	case 'del':
		if (in_array($userStatus, array('admin','educ'))) {
			$id = isset($_POST['id'])?$_POST['id']:Null;;
			$module = $Application->repertoireActuel();
			$nb = $flashInfo->delFlashInfo($id,$module);
			$smarty->assign('message',array(
				'title'=>DELETE,
				'texte'=>"$nb nouvelle(s) supprimée(s)",
				'urgence'=>'success'
				));
		}	
		// break;  pas de break
	default:
		$smarty->assign('flashInfos', $flashInfo->listeFlashInfos ($module));
		$smarty->assign('corpsPage', 'news');
		break;
	}
?>
