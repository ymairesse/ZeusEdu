<?php

if (isset($matricule) && ($matricule != '')) {
	$Eleve = new eleve($matricule);
	$detailsEleve = $Eleve->getDetailsEleve();
	$smarty->assign('detailsEleve',$detailsEleve);
	}

if ($etape == 'showEleve') {
	if (isset($matricule) && ($matricule != '')) {
		$smarty->assign('notification',$Thot->newNotification('eleves',$user->acronyme(),$matricule));
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('corpsPage','formNotification');
		}
	}
if ($etape == 'enregistrer') {
	$resultat = $Thot->enregistrerNotification($_POST);
	if ($resultat != Null) {
		// une seule adresse dans la liste des mails
		$listeMails = array($detailsEleve['user'].'@'.$detailsEleve['mailDomain']);
		$smarty->assign('message', array(
				'title'=>SAVE,
				'texte'=>"Notification à ".$resultat['destinataire']." enregistrée",
				'urgence'=>'success')
				);
		$smarty->assign('notification',$resultat);
		$smarty->assign('corpsPage','syntheseNotification');
		}
	}

$smarty->assign('classe',$classe);
$smarty->assign('matricule',$matricule);

$listeClasses = $Ecole->listeClasses();
$smarty->assign('listeClasses',$listeClasses);

$listeEleves=($classe!= Null)?$Ecole->listeEleves($classe,'groupe'):Null;

$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('etape','envoyer');
$smarty->assign('selecteur', 'selectClasseEleve');
?>
