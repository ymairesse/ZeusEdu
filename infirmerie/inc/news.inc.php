<?php
// seuls les statuts forts peuvent accéder aux news
$autorise = array('educ','admin');
if (in_array($user->userStatus($module), $autorise)) {
	require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");
	$flashInfo = new flashInfo();

	$id = isset($_REQUEST['id'])?$_REQUEST['id']:Null;

	switch ($mode) {
		case 'edit':
			$flashInfo = $flashInfo->getData($id);
			$smarty->assign('application',$module);
			$smarty->assign('flashInfo',$flashInfo);
			$smarty->assign('action',$action);
			$smarty->assign('mode','save');
			$smarty->assign('corpsPage','editFlashInfo');
			break;
		case 'save':
			if ($id != Null) {
				$nb = $flashInfo->saveFlashInfo($_POST);
				$smarty->assign('message',array(
					'title'=>SAVE,
					'texte'=>sprintf(NBSAVE,$nb),
					'urgence'=>'success'
					));
				}
			break;
		case 'del':
			if ($id != Null) {
				// on vérifie que le "flashInfo" appartient bien au module courant
				$nb = $flashInfo->delFlashInfo($id,$module);
				$smarty->assign('message', array(
						'title'=>SAVE,
						'texte'=>sprintf(NBDEL,$nb),
						'urgence'=>'warning'
						));
				}
		}
	
}
?>