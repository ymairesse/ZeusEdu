<?php

$etape = isset($_POST['etape']) ? $_POST['etape'] : Null;
$id = isset($_POST['id']) ? $_POST['id'] : Null;

$module = $Application->repertoireActuel();

require_once INSTALL_DIR."/inc/classes/classFlashInfo.inc.php";
$FlashInfo = new flashInfo();

switch ($etape) {
	case 'del':
		$nb = $flashInfo->delFlashInfo($id, $module);
		$smarty->assign('message',array(
			'title' => DELETE,
			'texte' => sprintf("%d nouvelle(s) supprimée(s)", $nb),
			'urgence' => 'warning'
			));
		$smarty->assign('flashInfos', $flashInfo->listeFlashInfos($module));
		$smarty->assign('corpsPage', 'news');
		break;
	case 'save':
		$data = $_POST;
		$data['application'] = $module;
		$nb = $FlashInfo->saveFlashInfo($data);
		$smarty->assign('flashInfos', $FlashInfo->listeFlashInfos($module));
		$smarty->assign('corpsPage', 'flashInfo/news');
		break;
	case 'edit':
		$flashInfo = $flashInfo->getData($id);
		$smarty->assign('flashInfo', $flashInfo);
		$smarty->assign('corpsPage','flashInfo/editFlashInfo');
		break;
	default:
		// new
		$smarty->assign('flashInfo', $FlashInfo->getData());
		$smarty->assign('corpsPage','flashInfo/editFlashInfo');
		break;
	}
