<?php
$unAn = time() + 365*24*3600;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;
$etape = isset($_REQUEST['etape'])?$_REQUEST['etape']:Null;

if (isset($_POST['classe'])) {
	$classe = $_POST['classe'];
	setcookie('classe',$classe,$unAn, null, null, false, true);
	}
	else $classe = isset($_COOKIE['classe'])?$_COOKIE['classe']:Null;
$smarty->assign('classe', $classe);

if (isset($_POST['matricule'])) {
	$matricule = $_POST['matricule'];
	setcookie('matricule',$matricule,$unAn, null, null, false, true);
	}
	else $matricule = isset($_COOKIE['matricule'])?$_COOKIE['matricule']:Null;
$smarty->assign('matricule', $matricule);

$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$annee = ($classe != Null)?SUBSTR($classe,0,1):Null;

// liste des classes dont le prof utilisateur est titulaire
$listeTitus = $user->listeTitulariats();
$listeClasses = $Ecole->listeGroupes($sections=array('G','TT', 'S'));

$smarty->assign('listeTitus', $listeTitus);
$smarty->assign('listeClasses', $listeClasses);

$smarty->assign('annee', $annee);
$smarty->assign('bulletin', $bulletin);
$smarty->assign('nbBulletins', NBPERIODES);
$smarty->assign('action', 'delibes');

switch ($mode) {
	case 'individuel':
		$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
		$smarty->assign('listeEleves', $listeEleves);
		$smarty->assign('bulletin', $bulletin);
		$smarty->assign('selecteur','selectClasseEleve');
		$smarty->assign('action','delibes');
		$smarty->assign('mode','individuel');
		switch ($etape) {
			case 'enregistrer':
				$nb = $Bulletin->enregistrerMentions($_POST);
				$nb = $Bulletin->enregistrerDecision($_POST);
				$smarty->assign('message', array(
									'title'=>'Enregistrement',
									'texte'=>"$nb mention(s) enregistrée(s)",
									'urgence'=>'success')
									);
				// pas de break;
			case 'showEleve':
				$listeCoursEleve = current($Bulletin->listeCoursGrpEleves($matricule, $bulletin));
				// recension des situations dans les différents cours pour l'élève concerné
				$listeSituations = current($Bulletin->listeSituationsCours($matricule, array_keys($listeCoursEleve), null, true));
				// calcul de la moyenne des cotes de situation pour l'élève concerné pour les périodes avec délibération
				$listePeriodes = explode(',',str_replace(' ','',PERIODESDELIBES));
				$moyenneSituations = $Bulletin->moyennesSituations($listeSituations, $listePeriodes);
				// sur la base de la moyenne des situations, détermination de la mention (grade) méritée avant délibération
				$mentionsJuinDec = $Bulletin->calculeMentionsDecJuin($moyenneSituations);

				// recherche toutes les mentions effectivement attribuées par le Conseil de Classe, durant l'année scolaire en cours pour l'élève concerné
				$listeMentions = $Bulletin->listeMentions($matricule,Null,$annee,ANNEESCOLAIRE);

				// recherche toutes les décisions prises en délibération, y compris les infos nécessaires à la notification de l'élève $matricule
				$decision = $Bulletin->listeDecisions($matricule);
				$decision = $decision[$matricule];

				// liste doublement liée des élèves de la classe (pour suivant et précédent)
				$prevNext = $Bulletin->prevNext($matricule,$listeEleves);
				// liste de tous les commentaires de titulaires de différents cours
				$remarques = $Bulletin->listeCommentairesTousCours($matricule, $listePeriodes);

				$estTitulaire = in_array($classe,$user->listeTitulariats());
				$smarty->assign('decision',$decision);
				$smarty->assign('estTitulaire',$estTitulaire);
				$smarty->assign('listePeriodes',$listePeriodes);
				$smarty->assign('listeCours',$listeCoursEleve);
				$smarty->assign('listeSituations',$listeSituations);
				$smarty->assign('listeRemarques',$remarques);
				$smarty->assign('prevNext',$prevNext);
				$smarty->assign('eleve',$Ecole->nomPrenomClasse($matricule));
				$smarty->assign('mentions',$mentionsJuinDec);
				$smarty->assign('decision',$decision);
				$smarty->assign('delibe',$moyenneSituations);
				$smarty->assign('mentionsAttribuees',$listeMentions);
				$smarty->assign('ANNEESCOLAIRE',ANNEESCOLAIRE);
				$smarty->assign('corpsPage','delibeIndividuel');
				break;
			default:
				// wtf
				break;
			}

		break;
	case 'synthese':
		$smarty->assign('action','delibes');
		$smarty->assign('mode','synthese');
		$smarty->assign('etape','showCotes');
		// sélecteur incluant la période '0' pour les élèves de 2e
		$smarty->assign('selecteur', 'selectBulletin0Classe');
		if (($etape == 'showCotes') && ($classe)) {
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			$listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
			$listeSituations100 = $Bulletin->getSituations100($bulletin, $listeEleves);
			$listeCours = $Ecole->listeCoursClassePourDelibe($classe);

			$smarty->assign('listeSituations100', $listeSituations100);
			$smarty->assign('listeCours', $listeCours);
			$smarty->assign('listeCoursGrpListeEleves',$listeCoursGrpListeEleves);
			$smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('corpsPage','grillePeriode');
			}
		break;
	case 'parClasse':
		$smarty->assign('action','delibes');
		$smarty->assign('mode','parClasse');
		$smarty->assign('etape','showCotes');
		$smarty->assign('selecteur', 'selectBulletinClasse');

		if (($etape == 'showCotes') && ($classe != Null)) {

			$titusClasse = $Ecole->titusDeGroupe($classe);

			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			if (in_array($bulletin, explode(',', str_replace(' ','',PERIODESDELIBES))))
				$listeMentions = $Bulletin->listeMentions($listeEleves,$bulletin,$annee,ANNEESCOLAIRE);
				else $listeMentions = Null;
			$listeCoursGrpListeEleves = $Bulletin->listeCoursGrpEleves($listeEleves, $bulletin);
			$listeCoursListeEleves = $Bulletin->listeCoursSansGrp($listeCoursGrpListeEleves);
			$listeCoursGrp = $Ecole->listeCoursGrpClasse($classe);
			$listeCours = $Ecole->listeCoursClassePourDelibe($classe);

			$listeSituations = $Bulletin->listeSituationsDelibe($listeEleves, array_keys($listeCoursGrp), $bulletin);

			//// À LA DERNIÈRE PÉRIODE DE L'ANNÉE, ON TIENT COMPTE DES ÉPREUVES EXTERNES ÉVENTUELLES
			//if ($bulletin == NBPERIODES)
			//	$listeSituations = $Bulletin->listeSitDelibeExternes($listeSituations, $listeEleves, $listeCoursGrp);
			$delibe = $Bulletin->echecMoyennesDecisions($listeSituations);

			$smarty->assign('ANNEESCOLAIRE',ANNEESCOLAIRE);
			$smarty->assign('delibe',$delibe);
			$smarty->assign('listeEleves', $listeEleves);
			$smarty->assign('listeCoursListeEleves',$listeCoursListeEleves);
			$smarty->assign('listeCoursGrpListeEleves',$listeCoursGrpListeEleves);
			$smarty->assign('listeSituations', $listeSituations);
			$smarty->assign('selectClasse',$classe);
			$smarty->assign('titusClasse',$titusClasse);
			$smarty->assign('listeCours',$listeCours);
			$smarty->assign('listeMentions',$listeMentions);
			$smarty->assign('corpsPage','feuilleDelibes');
			}
		break;
	case 'notifications':
		$listeClasses = $user->listeTitulariats();
		$smarty->assign('listeClasses',$listeClasses);
		$smarty->assign('selecteur','selectClasse');
		$smarty->assign('classe',$classe);
		// la classe actuellement active fait-elle partie des classes dont l'utilisateur est titulaire?
		if (in_array($classe,$listeClasses)) {
			// retrouver la liste des élèves de la classe
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			$smarty->assign('listeEleves',$listeEleves);

			// établir la liste des décisions éventuelles pour cette liste d'élèves
			// (tous, même ceux pour lesquels aucune décision n'est prise maintenant)
			$listeDecisions = $Bulletin->listeDecisions($listeEleves);

			// ajouter le texte qui figurera dans la BD pour accès par Thot
			$texteNotification = file_get_contents('templates/notification/templateNote.html');
			$texteNotification = str_replace(PHP_EOL, '', $texteNotification); 	// suppression des /n
			$listeDecisions = $Bulletin->listeDecisionsAvecTexte($listeDecisions,$listeEleves,$texteNotification);

			/*****************************************************************************************************/
			// certains parents souhaitent que leur enfant ne reçoive pas la notification par mail
			// et/ou la notification dans la plate-forme Thot. On les exclut donc au cas par cas
			// l'information est fournie par le prof titulaire (prof principal) durant la délibération du Conseil de Classe
			// et figure dans la table des décisions dans la BD
			/*****************************************************************************************************/

			// la liste des élèves pour lesquels une notification dans la BD est souhaitée
			$listeDecisionsBD = $Bulletin->listeDecisionsNote($listeDecisions);
			// la liste des élèves pour lesquels une notification par mail est souhaitée
			$listeDecisionsMails = $Bulletin->listeDecisionsMail($listeDecisions);

			// est-ce le moment d'enregistrer ces décisions?
			if ($etape == 'envoyer') {
				$objet = file_get_contents('templates/notification/objetMail.tpl');
				$texte = file_get_contents('templates/notification/texteMail.tpl');
				$signature = file_get_contents('templates/notification/signatureMail.tpl');

				require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
				$Thot = new thot();
				// envoi des notifications dans la BD; la liste des notifications obtenues est celle des matricules
				// des élèves pour lesquels on a enregistré une décision durant la procédure
				$listeNotifications = $Thot->notifier($_POST, $listeDecisionsBD, $listeEleves, $acronyme);

				// envoi des mails d'avertissement $listeNotifications contient les matricules / $listeDecisions contient
				// la fonction revient avec la liste des élèves auxquels le mail a été envoyé
				$listeMailing = $Thot->mailer($listeDecisionsMails, $objet, $texte, $signature);
				$nbMails = count($listeMailing);
				// avec horodatage pour les élèves de la liste des notifications (dans la BD)
				// la fonction revient avec la liste des élèves auxquels la notification a été envoyée
				$listeNotifs = $Bulletin->daterDecisions($listeNotifications);
				$nbNotifs = count($listeNotifs);

				// recharger la liste des décisions pour l'ensemble de la classe afin de rafraîchir l'affichage
				$listeDecisions = $Bulletin->listeDecisions($listeEleves);
				$smarty->assign('listeDecisions', $listeDecisions);
				// chercher la liste de synthèse des décisions qui viennent d'être actées (et seulement celles-là)
				$listeSynthDecisions = $Bulletin->listeSynthDecisions($listeNotifications);
				$smarty->assign('listeSynthDecisions',$listeSynthDecisions);

				$smarty->assign('message', array(
						'title'=>'Notifications',
						'texte'=>"$nbNotifs notification(s) et $nbMails mail(s) envoyée(s)",
						'urgence'=>'success')
						);
				$smarty->assign('corpsPage','synthNotifications');
				}
				// sinon, on affiche le statut de chaque élève du point de vue des décisions du C.Cl.
				else {
					$estTitulaire = in_array($classe,$user->listeTitulariats());
					$smarty->assign('estTitulaire',$estTitulaire);
					$smarty->assign('listeDecisions', $listeDecisions);
					$smarty->assign('corpsPage','notifications');
					}
			}
			// on ne sait pas encore quelle classe traiter et seul le selecteur est présenté
			else {
				$smarty->assign('corpsPage',Null);
				}
		break;
	}
?>
