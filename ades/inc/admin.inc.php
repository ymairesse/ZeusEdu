<?php
if ($userStatus == 'admin') {
	switch ($mode) {
		case 'users':
			switch ($etape) {
				case 'addUser':
					$acronyme = $_POST['acronyme'];
					$statut = $_POST['statut'];
					if (($acronyme != '') && ($statut != '')) {
						$nb = $Application->changeStatut($acronyme, 'ades',$statut);
						$smarty->assign("message", array(
							'title'=> MODIF,
							'texte'=>sprintf(NBSAVE,$nb)
							));
						}
					break;
				case 'delUser':
					$acronyme = $_POST['acronyme'];
					if ($acronyme != '') {
						$nb = $Application->changeStatut($acronyme, 'ades','none');
						$smarty->assign("message", array(
							'title'=> MODIF,
							'texte'=>sprintf(NBSAVE,$nb)
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
						'texte'=>sprintf(NBSAVE,$nb)
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
}

?>