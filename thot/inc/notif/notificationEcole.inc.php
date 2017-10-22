<?php

$notification = $Thot->newNotification('ecole',$user->acronyme(),'ecole');

switch ($etape) {
	case 'enregistrer':
		// enregistrement de la notification avec retour de la liste des identifiants correspondants
		// dans le cas d'une notification à l'école entière, la liste ne contient qu'une seule notification
		// (il n'est pas possible de cibler quelques élèves)
		$listeId = $Thot->enregistrerNotification($_POST);
		// enregistrement éventuel des PJ
		if (isset($_POST['files']) && count($_POST['files']) > 0) {
			require_once INSTALL_DIR.'/inc/classes/class.Files.php';
			$Files = new Files();
			$nb = $Files->linkFilesNotifications($listeId, $_POST);
			}

		if (count($listeId) > 0) {
			// liste de tous les élèves du cours
			$listeEleves = $Ecole->listeElevesEcole();
			$texte = sprintf("Notification aux %d élèves de l'école enregistrée", count($listeEleves));
			$smarty->assign('listeMatricules', Null);

			// le code qui suit a été supprimé: il n'est pas souhaitable d'envoyer tant de mails
			// ----------------------------------------------------------------------------------
			// ok pour la notification en BD, passons éventuellement à l'envoi de mail
            // if (isset($_POST['mail']) && $_POST['mail'] == 1) {
            //     if ($type == 'eleves') {
            //         // quelques élèves
            //         // retrouver les détails pour les élèves sélectionnés
            //         $listeElevesSelect = $Ecole->detailsDeListeEleves($matriculesSelect);
            //         $listeMailing = $Ecole->detailsDeListeEleves($listeElevesSelect);
            //     } else {
            //         // tous les élèves de l'école
            //         // $listeEleves contient les données principales élèves indexées sur le matricule
            //         $listeMailing = $Ecole->detailsDeListeEleves($listeEleves);
            //     }
            //     $smarty->assign('THOTELEVE', THOTELEVE);
            //     $smarty->assign('ECOLE', ECOLE);
            //     $smarty->assign('VILLE', VILLE);
            //     $smarty->assign('ADRESSE', ADRESSE);
            //     $objetMail = $smarty->fetch('templates/notification/objetMail.tpl');
            //     $texteMail = $smarty->fetch('templates/notification/texteMail.tpl');
            //     $signatureMail = $smarty->fetch('templates/notification/signatureMail.tpl');
            //     // la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
            //     $listeEnvois = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
            //     $nbMails = count($listeEnvois);
            //     $texte .= sprintf('<br> %d mails envoyés', $nbMails);
            // }

			// voyons si un accusé de lecture est souhaité
			if (isset($_POST['accuse']) && $_POST['accuse'] == 1) {
				$nbAccuses = $Thot->setAccuse($id, $listeEleves);
				$texte .= sprintf("<br>%d demande(s) d'accusé de lecture envoyée(s) ",$nbAccuses);
				}
			$smarty->assign('message', array(
					'title'=>SAVE,
					'texte'=> $texte,
					'urgence'=>SUCCES)
					);

			$notification = $_POST;
			$smarty->assign('notification',$notification);
			$smarty->assign('corpsPage', 'notification/syntheseNotification');
			}
		break;
	default:
		$notification = $Thot->newNotification('ecole',$user->acronyme(),'ecole');
		$smarty->assign('notification',$notification);
		$smarty->assign('corpsPage','notification/formNotification');
		break;
	}

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

// pas de sélecteur
