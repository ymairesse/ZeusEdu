<?php
if ($userStatus == 'admin'){
	switch ($mode) {
		case 'listUsers':
			$adesUsersList = $Ades->adesUsersList($module);
			$smarty->assign('usersList', $adesUsersList);
			$smarty->assign('corpsPage', 'usersList');
			break;
		case 'delUser':
		
			break;
		case 'editUser':
		
			break;
		case 'addUser':
		
			break;
		default:
			// wtf
			break;
	}
}
?>