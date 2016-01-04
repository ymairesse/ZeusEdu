<?php

$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;

switch ($etape) {
	case 'show':
		// le niveau a été choisi dans le sélecteur; on prépare un formulaire pour le niveau $niveau
		if ($niveau != Null) {
			$notification = $Thot->newNotification('niveau',$user->acronyme(),$niveau);
			$smarty->assign('notification',$notification);
			$smarty->assign('corpsPage','notification/formNotification');
			}
		break;
	case 'enregistrer':
		// l'$id est celui de la nouvelle notification créée dans la BD
		$id = $Thot->enregistrerNotification($_POST);
		if ($id != Null) {
			// $nbMails = 0;
			// $nbAccuses = 0;
			$listeEleves = $Ecole->listeElevesNiveaux($_POST['destinataire']);
			$texte = sprintf("Notification aux %d élèves de %s e enregistrée ",count($listeEleves), $_POST['destinataire']);


			// ok pour la notification en BD, passons éventuellement à l'envoi de mail
			if (isset($_POST['mail']) && $_POST['mail'] == 1) {

				$listeMailing = $Ecole->detailsDeListeEleves($listeEleves);
				$objetMail = file_get_contents('templates/notification/objetMail.tpl');
				$texteMail = file_get_contents('templates/notification/texteMail.tpl');
				$signatureMail = file_get_contents('templates/notification/signatureMail.tpl');
				// la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
				$listeMatricules = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
				$nbMails = count($listeMatricules);
				$texte .= sprintf("<br>%d envoyés ",$nbMails);
				}

			// voyons si un accusé de lecture est souhaité
			if (isset($_POST['accuse']) && $_POST['accuse'] == 1) {
				$nbAccuses = $Thot->setAccuse($id, $listeEleves);
				$texte .= sprintf("<br>%d demande(s) d'accusé de lecture envoyée(s) ",$nbAccuses);
				}

			$smarty->assign('message', array(
					'title'=>SAVE,
					'texte'=> $texte,
					'urgence'=>'success')
					);

			$notification = $_POST;
			$smarty->assign('notification',$notification);
			$smarty->assign('corpsPage','notification/formNotification');
			}
		break;
	default:
		$notification = Null;
		break;
}


$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

// informations pour le sélecteur 'selectNiveau'
$smarty->assign('listeNiveaux',$Ecole->listeNiveaux());
$smarty->assign('niveau',$niveau);
$smarty->assign('selecteur', 'selecteurs/selectNiveau');
