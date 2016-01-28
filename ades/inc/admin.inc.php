<?php
switch ($mode) {
	case 'users':
		if ($userStatus == 'admin') {
		switch ($etape) {
			case 'addUser':
				$acronyme = $_POST['acronyme'];
				$statut = $_POST['statut'];
				if (($acronyme != '') && ($statut != '')) {
					$nb = $Application->changeStatut($acronyme, 'ades',$statut);
					$smarty->assign("message", array(
						'title'=> MODIF,
						'texte'=>sprintf(NBSAVE,$nb),
						'urgence'=> 'info'
						));
					}
				break;
			case 'delUser':
				$acronyme = $_POST['acronyme'];
				if ($acronyme != '') {
					$nb = $Application->changeStatut($acronyme, 'ades','none');
					$smarty->assign("message", array(
						'title'=> MODIF,
						'texte'=>sprintf(NBDEL,$nb),
						'urgence'=>'warning'
						));
					}
				break;
			case 'editUser':
				$acronyme = $_POST['acronyme'];
				$statut = $_POST['statut'];
				if (($acronyme != '') && ($statut != '')) {
				$nb = $Application->changeStatut($acronyme, 'ades',$statut);
				$smarty->assign("message", array(
					'title'=> MODIF,
					'texte'=>sprintf(NBSAVE,$nb),
					'urgence'=>'success'
					));
					}
				break;
			default:
				// wtf
				break;
		}
		$listeProfs = $Ecole->listeProfs();
		$adesUsersList = $Ades->adesUsersList($module);
		$listeStatuts = $Application->listeStatuts();
		$smarty->assign('listeStatuts', $listeStatuts);
		$smarty->assign('usersList', $adesUsersList);
		$smarty->assign('listeProfs',$listeProfs);
		$smarty->assign('corpsPage', 'usersList');
		break;
		}
	case 'remAuto':
		$smarty->assign('listeMemos',$Ades->listeMemos($user->acronyme()));
		$smarty->assign('acronyme',$acronyme);
		$smarty->assign('corpsPage','gestionMemos');
		break;
}

?>