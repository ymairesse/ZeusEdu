<?php
require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

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
		if ($ok == true)
			$texte = MAILOK;
			else $texte = MAILKO;
		// traiter le cas de l'expéditeur NOREPLY
		$mailExpediteur = $_POST['mailExpediteur'];
		$_POST['nomExpediteur'] = ($mailExpediteur == NOREPLY)?NOMNOREPLY:$_POST['nomExpediteur'];

		$hermes->archiveMail($acronyme, $_POST, $_FILES);
		if ($_POST['groupe'] != '') {
			$hermes->creerGroupe($acronyme,$_POST['groupe'],$_POST['mails']);
			}
		$smarty->assign('reussite',$texte);
		$smarty->assign('detailsMail', array('post'=>$_POST,'files'=>$_FILES));
		$destinataires = $hermes->listeNomsFromDestinataires($_POST['mails']);
		$smarty->assign('destinatairesString', implode(', ',$destinataires));
		$smarty->assign('corpsPage','confirmMail');
		break;
	case 'archives':
		$debut = isset($_POST['debut'])?$_POST['debut']:0;
		$nb = isset($_POST['nb'])?$_POST['nb']:10;
		$listeArchives = $hermes->listeArchives($acronyme, $debut, $nb);
		$nbArchives = $hermes->nbArchives($acronyme);
		$smarty->assign('acronyme',$acronyme);
		$smarty->assign('debut',$debut);
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

				$smarty->assign('deleted', array('nbMailing'=>$nbMailing, 'nbListes'=>$nbListes));
				break;
			case 'creationListe':
				$nomListe = isset($_POST['nomListe'])?$_POST['nomListe']:Null;
				$idListe = $hermes->creerGroupe($acronyme,$nomListe);
				$smarty->assign('nomListe',$nomListe);
				$smarty->assign("message", array(
					'title'=>SAVE,
					'texte'=>"La liste $nomListe a été créée"),
					3000);
				break;
			case 'ajoutMembres':
				$listeMembres = isset($_POST['mails'])?$_POST['mails']:Null;
				$idListe = isset($_POST['idListe'])?$_POST['idListe']:Null;
				if (isset($listeMembres) && isset($idListe)) {
					$nb = $hermes->addMembresListe ($idListe,$listeMembres);
					$smarty->assign("message", array(
						'title'=>SAVE,
						'texte'=>"$nb membres(s) ajouté(s)"),
						3000);
					}
				break;
			case 'statutListe':
				$nb = $hermes->saveListStatus($_POST, $acronyme);
				$smarty->assign("message", array(
					'title'=>SAVE,
					'texte'=>"$nb modification(s) enregistrée(s)"),
					3000);
				break;
			case 'abonnement':
				$nb = $hermes->gestAbonnements($_POST, $acronyme);
				$smarty->assign("message", array(
					'title'=>SAVE,
					'texte'=>"$nb abonnement(s) modifié(s)"),
					3000);
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
			if ($nb != false)
				$texte = "$nb octet(s) enregistré(s)";
				else $texte = "Échec de l'enregistrement";
			$smarty->assign("message", array(
					'title'=>SAVE,
					'texte'=>$texte),
					3000);
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
$smarty->assign("executionTime",round($Application->chrono()-$debut,6));
$smarty->display("index.tpl");

?>
