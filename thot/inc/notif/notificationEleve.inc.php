<?php

$matricule = isset($_GET['matricule'])?$_GET['matricule']:Null;

switch ($etape) {
	case 'showEleve':
		// l'élève a été choisi dans le sélecteur; on prépare un formulaire pour l'élève $matricule
		if ($matricule != Null) {
			$notification = $Thot->newNotification('eleves',$user->acronyme(),$matricule);
			$Eleve = new eleve($matricule);
			$detailsEleve = $Eleve->getDetailsEleve();
			$smarty->assign('detailsEleve',$detailsEleve);

			$smarty->assign('notification',$notification);
			$smarty->assign('corpsPage','notification/formNotification');
			}
		break;

	case 'enregistrer':
	// l'$id est celui de la nouvelle notification créée dans la BD
	$id = $Thot->enregistrerNotification($_POST);
	if ($id != Null) {
		$matricule = $_POST['destinataire'];
		$Eleve = new eleve($matricule);
		$detailsEleve = $Eleve->getDetailsEleve();
		$smarty->assign('detailsEleve',$detailsEleve);

		$texte = sprintf("Notification à %s enregistrée ", $detailsEleve['prenom'].' '.$detailsEleve['nom']);
		$listeEleves = $matricule;

		// ok pour la notification en BD, passons éventuellement à l'envoi de mail
		if (isset($_POST['mail']) && $_POST['mail'] == 1) {
			// une seule adresse dans la liste des mails
			$listeMailing = $Ecole->detailsDeListeEleves($listeEleves);
			$objetMail = file_get_contents('templates/notification/objetMail.tpl');
			$texteMail = file_get_contents('templates/notification/texteMail.tpl');
			$signatureMail = file_get_contents('templates/notification/signatureMail.tpl');
			// la fonction $Thot->mailer() revient avec la liste des matricules des élèves auxquels un mail a été envoyé
			$listeMatricules = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
			$nbMails = count($listeMatricules);
			$texte .= sprintf("<br>%d mail envoyé ",$nbMails);
			}
		// voyons si un accusé de lecture est souhaité
		if (isset($_POST['accuse']) && $_POST['accuse'] == 1) {
			$listeEleves = array($matricule=>$matricule);
			$nbAccuses = $Thot->setAccuse($id, $listeEleves);
			$texte .= sprintf("<br>%d demande d'accusé de lecture envoyée ",$nbAccuses);
			}

		$nom = $detailsEleve['prenom'].' '.$detailsEleve['nom'];
		$smarty->assign('message', array(
				'title'=>SAVE,
				'texte'=> $texte,
				'urgence'=>SUCCES)
				);

		$notification = $_POST;
		}
		$smarty->assign('notification',$notification);
		$smarty->assign('corpsPage','notification/formNotification');
		break;
	default:
		$notification = Null;
		break;
	}

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

// informations pour le sélecterur "selecClasseEleve"
$smarty->assign('classe',$classe);
$smarty->assign('matricule',$matricule);
$smarty->assign('listeClasses',$Ecole->listeClasses());
$listeEleves=($classe!= Null)?$Ecole->listeEleves($classe,'groupe'):Null;
$smarty->assign('listeEleves', $listeEleves);
$smarty->assign('selecteur', 'selecteurs/selectClasseEleve');
