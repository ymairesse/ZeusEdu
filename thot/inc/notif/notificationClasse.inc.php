<?php

if ($etape == 'showClasse') {
	if (isset($classe) && ($classe != '')) {
		$smarty->assign('notification',$Thot->newNotification('classes',$user->acronyme(),$classe));
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('corpsPage','formNotification');
		}
	}
if ($etape == 'enregistrer') {
	$resultat = $Thot->enregistrerNotification($_POST);
	if ($resultat != Null) {
		$smarty->assign('message', array(
				'title'=>SAVE,
				'texte'=>"Notification à ".$resultat['destinataire']." enregistrée",
				'urgence'=>'success')
				);
		$smarty->assign('notification',$_POST);
		$smarty->assign('corpsPage','syntheseNotification');
		}
	}

$smarty->assign('etape','envoyer');
$smarty->assign('listeClasses',$Ecole->listeGroupes());
$smarty->assign('classe',$classe);
$smarty->assign('selecteur', 'selectClasse');
?>
