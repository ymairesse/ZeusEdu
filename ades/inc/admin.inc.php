<?php
if ($userStatus == 'admin'){
	switch ($mode) {
		case 'users':
			switch ($etape) {
				case 'addUser':
					
					break;
				case 'delUser':
		
					break;
				case 'editUser':
		
					break;
				case 'addUser':
		
					break;
				default:
					$adesUsersList = $Ades->adesUsersList($module);
					$smarty->assign('usersList', $adesUsersList);
					$smarty->assign('corpsPage', 'usersList');
					break;
			}

		case 'dateDebut':
			$smarty->assign('corpsPage','dateDebut');
			break;
		
		default:
			// wtf
			break;
	}
}
?>