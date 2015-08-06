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
	// l'$id est celui de la nouvelle notification créée dans la BD
	$id = $Thot->enregistrerNotification($_POST);
	if ($id != Null) {
		$nbMails = 0;
		$nbAccuses = 0;
		$listeEleves = $Ecole->listeElevesClasse($_POST['destinataire']);
		$texte = sprintf("Notification aux %d élèves de la classe %s enregistrée ",count($listeEleves), $_POST['destinataire']);

		// ok pour la notification en BD, passons éventuellement à l'envoi de mail
		if (isset($_POST['mail']) && $_POST['mail'] == 1) {
			$listeMailing = $Ecole->detailsDeListeEleves($listeEleves);
			$objetMail = file_get_contents('templates/notification/objetMail.tpl');
			$texteMail = file_get_contents('templates/notification/texteMail.tpl');
			$signatureMail = file_get_contents('templates/notification/signatureMail.tpl');
			// la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
			$listeMatricules = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
			$nbMails = count($listeMatricules);
			$texte .= sprintf("<br> %d mails envoyés",$nbMails);
			}

		// voyons si un accusé de lecture est souhaité
		if (isset($_POST['accuse']) && $_POST['accuse'] == 1) {
			$nbAccuses = $Thot->setAccuse($id, $listeEleves);
			$texte .= sprintf("<br>%d demande(s) d'accusé de lecture envoyée(s)",$nbAccuses);
			}

		$smarty->assign('message', array(
				'title'=>SAVE,
				'texte'=>$texte,
				'urgence'=>SUCCES)
				);
		// on prie pour que tout se soit bien passé et on avertit l'utilisateur que tout ce qui a été passé en POST a été pris en compte
		$smarty->assign('nbMails',$nbMails);
		$smarty->assign('nbAccuses',$nbAccuses);
		$smarty->assign('notification',$_POST);
		$smarty->assign('corpsPage','syntheseNotification');
		}
	}

$smarty->assign('etape','envoyer');
$smarty->assign('listeClasses',$Ecole->listeGroupes());
$smarty->assign('classe',$classe);
$smarty->assign('selecteur', 'selectClasse');
?>
