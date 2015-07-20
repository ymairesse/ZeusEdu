<?php

if ($mode == 'niveau') {
	if (isset($niveau) && ($niveau != '')) {
		$smarty->assign('notification',$Thot->newNotification('niveau',$user->acronyme(),$niveau));
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
				'texte'=>"Notification aux élèves de ".$niveau."e enregistrée",
				'urgence'=>'success')
				);
		$smarty->assign('notification',$_POST);
		$smarty->assign('corpsPage','syntheseNotification');
		}
	}

$smarty->assign('etape','envoyer');
$smarty->assign('listeNiveaux',$Ecole->listeNiveaux());
$smarty->assign('niveau',$niveau);
$smarty->assign('selecteur', 'selectNiveau');
?>
