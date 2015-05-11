<?php
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;
$id = isset($_POST['id'])?$_POST['id']:Null;
$mode = isset($_REQUEST['mode'])?$_REQUEST['mode']:Null;

require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");

switch ($mode) {
	case 'del':
		$flashInfo = flashInfo::getData($id);
		$titre = $flashInfo['titre'];
		$smarty->assign("titre",$titre);
		$smarty->assign("id",$id);
		$smarty->assign("etape","demander");
		
		$smarty->assign("corpsPage","delEditNews");
		break;
	case 'edit':
		switch ($etape) {
			case 'enregistrer':
				$data = $_POST;
				$application = Application::repertoireActuel();
				$data['application'] = $application;
				$nb = flashInfo::saveFlashInfo($data);
				$smarty->assign("flashInfos", flashInfo::listeFlashInfos ($application));
				$smarty->assign("corpsPage", "news");
				break;
			default:
				$flashInfo = flashInfo::getData($id);
				$smarty->assign("flashInfo",$flashInfo);
				$smarty->assign("action","news");
				$smarty->assign("mode","edit");
				$smarty->assign("etape","enregistrer");
				$smarty->assign("corpsPage", "editFlashInfo");
				break;
		}
		break;
	case 'new':
		echo "new";
		break;
	default: 
		die("bIbo");
		break;
	}
	
?>
