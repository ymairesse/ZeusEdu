<?php

$classe = isset($_GET['classe'])?$_GET['classe']:Null;

switch ($etape) {
	case 'showClasse':
		// la classe a été choisie dans le sélecteur; on prépare un formulaire pour la classe $classe
		if ($classe != Null) {
			$notification = $Thot->newNotification('classes',$user->acronyme(),$classe);
			$smarty->assign('notification',$notification);
			$smarty->assign('corpsPage','notification/formNotification');
			}
		break;
	case 'enregistrer':
		// l'$id est celui de la nouvelle notification créée dans la BD
		$id = $Thot->enregistrerNotification($_POST);
		if ($id != Null) {
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

// informations our le sélecteur 'selectClasse'
$smarty->assign('listeClasses',$Ecole->listeGroupes());
$smarty->assign('classe',$classe);
$smarty->assign('selecteur', 'selecteurs/selectClasse');
