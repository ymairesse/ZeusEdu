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
	// l'$id est celui de la nouvelle notification créée dans la BD
	$id = $Thot->enregistrerNotification($_POST);
	if ($id != Null) {
		$nbMails = 0;
		$nbAccuses = 0;
		$texte = sprintf("Notification à %s enregistrée ", $detailsEleve['prenom'].' '.$detailsEleve['nom']);
		$listeEleves = $matricule;
		// ok pour la notification en BD, passons éventuellement à l'envoi de mail
		if (isset($_POST['mail']) && $_POST['mail'] == 1) {
			// une seule adresse dans la liste des mails
			$listeMailing = $Ecole->detailsDeListeEleves($listeEleves);
			$objetMail = file_get_contents('templates/notification/objetMail.tpl');
			$texteMail = file_get_contents('templates/notification/texteMail.tpl');
			$signatureMail = file_get_contents('templates/notification/signatureMail.tpl');
			$listeMatricules = $Thot->mailer($listeMailing, $objetMail, $texteMail, $signatureMail);
			$nbMails = $count($listeMatricules);
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
				'urgence'=>'success')
				);
		$smarty->assign('nbMails',$nbMails);
		$smarty->assign('nbAccuses',$nbAccuses);
		$smarty->assign('notification',$_POST);
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
