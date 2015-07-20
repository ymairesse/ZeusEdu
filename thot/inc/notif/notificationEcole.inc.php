<?php

$smarty->assign('notification',$Thot->newNotification('ecole',$user->acronyme(),'ecole'));
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('corpsPage','formNotification');

if ($etape == 'enregistrer') {
	$resultat = $Thot->enregistrerNotification($_POST);
	if ($resultat != Null) {
		$smarty->assign('message', array(
				'title'=>SAVE,
				'texte'=>"Notification aux élèves de l'école enregistrée",
				'urgence'=>'success')
				);
		$smarty->assign('notification',$_POST);
		$smarty->assign('corpsPage','syntheseNotification');
		}
	}

?>
