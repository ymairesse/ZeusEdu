<?php
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$mode = isset($_REQUEST['mode'])?$_REQUEST['mode']:Null;
$id = isset($_REQUEST['id'])?$_REQUEST['id']:Null;

$module = $Application->repertoireActuel();

require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");
$flashInfo = new flashInfo();

switch ($mode) {
	case 'del':
		$nb = $flashInfo->delFlashInfo($id,$module);
		$smarty->assign('message',array(
			'title'=>DELETE,
			'texte'=>"$nb nouvelle(s) supprimée(s)",
			'urgence'=>'warning'
			));
		$smarty->assign('flashInfos', $flashInfo->listeFlashInfos($module));
		$smarty->assign('corpsPage', 'news');
		break;
	case 'edit':
		$smarty->assign('application',$application);
		switch ($etape) {
			case 'enregistrer':
				$data = $_POST;
				$data['application'] = $module;
				$nb = $flashInfo->saveFlashInfo($data);
				$smarty->assign('flashInfos', $flashInfo->listeFlashInfos($module));
				$smarty->assign('corpsPage', 'news');
				break;
			default:
				$lesFlashInfo = $flashInfo->getData($id);
				$smarty->assign('flashInfo',$lesFlashInfo);
				$smarty->assign('action',$action);
				$smarty->assign('mode',$mode);
				$smarty->assign('etape','enregistrer');
				$smarty->assign('corpsPage','editFlashInfo');
				break;
			}
		break;
	}
	
?>
