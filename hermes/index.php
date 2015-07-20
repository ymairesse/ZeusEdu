<?php
require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$onglet = isset($_POST['onglet'])?$_POST['onglet']:0;
$smarty->assign('onglet',$onglet);

// ----------------------------------------------------------------------------
//
require_once("inc/classes/classHermes.inc.php");
$hermes = new hermes;

$acronyme = $user->getAcronyme();
$smarty->assign('acronyme',$acronyme);
switch ($action) {
	case 'Envoyer':
		$ok = $hermes->send_mail($_POST, $_FILES);
		$smarty->assign('message',array(
			'title'=>"Envoi d'un mail",
			'texte'=>$ok==true?MAILOK:MAILKO,
			'urgence'=>$ok==true?'success':'danger'
			));

		// traiter le cas de l'expéditeur NOREPLY
		$mailExpediteur = $_POST['mailExpediteur'];
		$_POST['nomExpediteur'] = ($mailExpediteur == NOREPLY)?NOMNOREPLY:$_POST['nomExpediteur'];

		// création du groupe éventuellement créé durant l'envoi du mail
		$hermes->archiveMail($acronyme, $_POST, $_FILES);
		if ($_POST['groupe'] != '') {
			$hermes->creerGroupe($acronyme,$_POST['groupe'],$_POST['mails']);
			}

		// la liste des destinataires est dans $_POST sous forme mail#nom
		// la liste des fichiers joints est dans $_FILES
		$smarty->assign('detailsMail', array('post'=>$_POST,'files'=>$_FILES));
		// éclater la liste des destinataires sur le #
		// chaque destinataire est de la forme  "Prenom Nom#pnom@ecole.org"
		$destinataires = $hermes->listeNomsFromDestinataires($_POST['mails']);
		$smarty->assign('destinatairesString', implode(', ',$destinataires));
		$smarty->assign('corpsPage','confirmMail');
		break;
	case 'archives':
		if ($mode == 'delArchive') {
			$idArchive = isset($_POST['idArchive'])?$_POST['idArchive']:Null;
			$mail = $hermes->archive($idArchive);
			// suppression des pièces jointes
			$PJ = explode(',',$mail['PJ']);
			foreach ($PJ as $unePJ) {
				$unePJ = trim($unePJ);
				if ($unePJ != '')
					@unlink("upload/$acronyme/$unePJ");
				}
			// suppression de la référence dans la BD
			$n = $hermes->delArchive($idArchive);
			$smarty->assign('message', array(
				'title'=>DELETE,
				'texte'=>"$n courriel(s) supprimé(s)",
				'urgence'=>'warning')
				);
			}
		$beginList = isset($_POST['debut'])?$_POST['debut']:0;
		$nb = isset($_POST['nb'])?$_POST['nb']:10;
		$listeArchives = $hermes->listeArchives($acronyme, $beginList, $nb);
		$nbArchives = $hermes->nbArchives($acronyme);
		$smarty->assign('acronyme',$acronyme);
		$smarty->assign('debut',$beginList);
		$smarty->assign('nb',$nb);
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('listeArchives',$listeArchives);
		$smarty->assign('nbArchives',$nbArchives);
		$smarty->assign('corpsPage','archives');
		break;
	case 'gestion':
		switch ($mode) {
			case 'delete':
				$mailingDel = array();
				$listeDel = array();
				foreach ($_POST as $name=>$value) {
					// membres des listes de mailing à supprimer
					if (substr($name,0,7) == 'mailing') {
						$nom = explode('_',$name);
						$idListe = explode('-',$nom[0]);
						$idListe = $idListe[1];
						$qui = $value;
						$mailingDel[] = array('id'=>$idListe,'acronyme'=>$qui);
						}

					// listes de mailing à supprimer
					if (substr($name,0,5) == 'liste') {
						$idListe = explode('-',$name);
						$idListe = $idListe[1];
						$listeDel[] = $idListe;
						}
					}
				// effacements effectifs des membres des listes et des listes vides
				$nbMailing = $hermes->delMembresListe($mailingDel);
				$nbListes = $hermes->delListes($listeDel, $acronyme);
				$smarty->assign('message',array(
						'title'=>DELETE,
						'texte'=> "$nbMailing destinataire(s) supprimé(s)<br>$nbListes liste(s) vide(s) supprimée(s)<br>Les listes non vides ne sont pas supprimées",
						'urgence'=>'warning'));
				break;
			case 'creationListe':
				$nomListe = isset($_POST['nomListe'])?$_POST['nomListe']:Null;
				$idListe = $hermes->creerGroupe($acronyme,$nomListe);
				$smarty->assign('nomListe',$nomListe);
				$smarty->assign('message', array(
					'title'=>SAVE,
					'texte'=>"La liste $nomListe a été créée",
					'urgence'=>'success'));
				break;
			case 'ajoutMembres':
				$listeMembres = isset($_POST['mails'])?$_POST['mails']:Null;
				$idListe = isset($_POST['idListe'])?$_POST['idListe']:Null;
				if (isset($listeMembres) && isset($idListe)) {
					$nb = $hermes->addMembresListe ($idListe,$listeMembres);
					$smarty->assign("message", array(
						'title'=>SAVE,
						'texte'=>"$nb membres(s) ajouté(s)",
						'urgence'=>'success'));
					}
				break;
			case 'statutListe':
				$nb = $hermes->saveListStatus($_POST, $acronyme);
				$smarty->assign("message", array(
					'title'=>SAVE,
					'texte'=>"$nb modification(s) enregistrée(s)",
					'urgence'=>'success'));
				break;
			case 'abonnement':
				$nb = $hermes->gestAbonnements($_POST, $acronyme);
				$smarty->assign("message", array(
					'title'=>SAVE,
					'texte'=>"$nb abonnement(s) modifié(s)",
					'urgence'=>'success'));
				break;
			default:
				// wtf
				break;
			break;
			}
		$listeProfs = $hermes->listeMailingProfs();
		$smarty->assign('listeProfs', $listeProfs);

		$autresListes = $hermes->listesPerso($acronyme, true);
		$listes = array();
		foreach ($autresListes as $nomListe=>$laListe)
			$listes[$nomListe] = $laListe;
		$listePublie = $hermes->listesDisponibles($acronyme, 'publie');
		$listeAbonne = $hermes->listesDisponibles($acronyme, 'abonne');
		$abonnesDe = $hermes->abonnesDe($acronyme);
		$smarty->assign('listePublie', $listePublie);
		$smarty->assign('listeAbonne', $listeAbonne);
		$smarty->assign('abonnesDe',$abonnesDe);
		$smarty->assign('action',$action);
		$smarty->assign('listesPerso',$listes);
		$smarty->assign('corpsPage','gestion');
		break;
	case 'preferences':
		if ($mode == 'enregistrer') {
			$signature = $_POST['signature'];
			$nb = file_put_contents ('templates/signature.tpl', $signature);
			if ($nb != false) {
				$texte = "$nb octet(s) enregistré(s)";
				$urgence = 'success';
				}
				else {
					$texte = "Échec de l'enregistrement";
					$urgence = 'danger';
					}
			$smarty->assign("message", array(
					'title'=>SAVE,
					'texte'=>$texte,
					'urgence'=>$urgence));
			}
			else $signature = file_get_contents('templates/signature.tpl');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('signature',$signature);
		$smarty->assign('corpsPage','editSignature');
		break;
	default:
		$listeProfs = $hermes->listeMailingProfs();
		$listeTitus = $hermes->listeMailingTitulaires();
		$listesAutres = $hermes->listesPerso($acronyme);
		$listeDirection = $hermes->listeDirection();
		$smarty->assign('listeProfs',$listeProfs);
		$smarty->assign('listeTitus',$listeTitus);
		$smarty->assign('listesAutres',$listesAutres);
		$smarty->assign('listeDirection',$listeDirection);
		$smarty->assign('nbPJ', range(0,9));	// nombre max de pièces jointes autorisées
		$smarty->assign('NOREPLY', NOREPLY);
		$smarty->assign('NOMNOREPLY', NOMNOREPLY);
		$smarty->assign('action','Envoyer');
		$smarty->assign('corpsPage','envoiMail');
	}

//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(),6));
$smarty->display('index.tpl');

?>
