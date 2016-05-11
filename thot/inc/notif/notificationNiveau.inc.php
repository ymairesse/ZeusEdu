<?php

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;

switch ($etape) {
    case 'show':
        // le niveau a été choisi dans le sélecteur; on prépare un formulaire pour le niveau $niveau
        if ($niveau != null) {
            $notification = $Thot->newNotification('niveau', $user->acronyme(), $niveau);
            $smarty->assign('notification', $notification);
            $smarty->assign('corpsPage', 'notification/formNotification');
        }
        break;
    case 'enregistrer':
        // l'$id est celui de la nouvelle notification créée dans la BD
        $listeId = $Thot->enregistrerNotification($_POST);
        if (count($listeId) > 0) {

            $listeEleves = $Ecole->listeElevesNiveaux($niveau);
			// on extrait la liste des matricules
			$matriculesTous = array_keys($listeEleves);

			$nbEleves = count($matriculesTous);

            $texte = sprintf('Notification aux %d élèves de %s e enregistrée ', $nbEleves, $niveau);
            $smarty->assign('listeMatricules', Null);

			// ok pour la notification en BD, passons éventuellement à l'envoi de mail
			// if (isset($_POST['mail']) && $_POST['mail'] == 1) {
			// 	if ($type == 'eleves') {
			// 		// quelques élèves
			// 		// retrouver les détails pour les élèves sélectionnés
			// 		$listeElevesSelect = $Ecole->detailsDeListeEleves($matriculesSelect);
			// 		$listeMailing = $Ecole->detailsDeListeEleves($listeElevesSelect);
			// 	} else {
			// 		// tous les élèves du niveau
			// 		// $listeEleves contient les données principales élèves indexées sur le matricule
			// 		$listeMailing = $Ecole->detailsDeListeEleves($listeEleves);
			// 	}
			// 	$smarty->assign('THOTELEVE', THOTELEVE);
			// 	$smarty->assign('ECOLE', ECOLE);
			// 	$smarty->assign('VILLE', VILLE);
			// 	$smarty->assign('ADRESSE', ADRESSE);
			// 	$objetMail = $smarty->fetch('templates/notification/objetMail.tpl');
			// 	$texteMail = $smarty->fetch('templates/notification/texteMail.tpl');
			// 	$signatureMail = $smarty->fetch('templates/notification/signatureMail.tpl');
			// 	// la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
			// 	$listeEnvois = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
			// 	$nbMails = count($listeEnvois);
			// 	$texte .= sprintf('<br> %d mails envoyés', $nbMails);
			// }

            // voyons si un accusé de lecture est souhaité
            if (isset($_POST['accuse']) && $_POST['accuse'] == 1) {
                $nbAccuses = $Thot->setAccuse($listeId, $matriculesTous, 'groupe');
                $texte .= sprintf("<br>%d demande(s) d'accusé de lecture envoyée(s) ", $nbAccuses);
            }

            $smarty->assign('message', array(
                    'title' => SAVE,
                    'texte' => $texte,
                    'urgence' => 'success', )
                    );

            $notification = $_POST;
			// remise en état de "$notification" si des élèves particuliers avaient été sélectionnés
			// $notification['type'] = 'niveau';
			// $notification['destinataire'] = $niveau;
			// $smarty->assign('type', 'niveau');

            $smarty->assign('notification', $notification);
            // $smarty->assign('corpsPage', 'notification/formNotification');
            $smarty->assign('corpsPage', 'notification/syntheseNotification');
        }
        break;
    default:
        $notification = null;
        break;
}

$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

// informations pour le sélecteur 'selectNiveau'
$smarty->assign('listeNiveaux', $Ecole->listeNiveaux());
$smarty->assign('niveau', $niveau);
$smarty->assign('selecteur', 'selecteurs/selectNiveau');
