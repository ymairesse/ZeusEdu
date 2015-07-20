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

$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;

$smarty->assign('classe',$classe);
$smarty->assign('bulletin',$bulletin);
$smarty->assign('matricule',$matricule);

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$listePeriodes = $BullTQ->listePeriodes(true);
$listeClasses = $Ecole->listeGroupes(array('TQ'));
$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('listePeriodes', $listePeriodes);

if ($classe)
	$listeEleves = $Ecole->listeEleves($classe,'classe');
	else $listeEleves = Null;
$smarty->assign('listeEleves', $listeEleves);

$estTitulaire = in_array($classe,$user->listeTitulariats());
$smarty->assign('estTitulaire',$estTitulaire);

switch ($mode) {
	case 'individuel':
		$smarty->assign('etape','showEleve');
		$smarty->assign('selecteur','selectClasseEleve');
		switch ($etape) {
			case 'enregistrer':
				$nb =  $BullTQ->enregistrerDelibe($_POST);
				$nb = $BullTQ->enregistrerDecision($_POST);
				$smarty->assign('message', array(
				'title'=>SAVE,
				'texte'=>"Enregistrement de $nb mentions",
				'urgence'=>'success')
				);
				// break;  pas de break: on continue sur la présentation de la fiche d'élève
			default:
				if (($matricule == '') || ($classe == '')) break;
					else {
						$smarty->assign('nomPrenomClasse',$Ecole->nomPrenomClasse($matricule));
						// on établit autant de sous-tableaux qu'il existe de périodes
						// dans chaque sous-tableau, toutes les cotes d'une même période
						$cotesParPeriode = $BullTQ->cotesEleve($matricule, $listePeriodes);

						$statistiquesGlobales = $BullTQ->tableauStatistique($cotesParPeriode, '');
						$statistiquesStage = $BullTQ->tableauStatistique($cotesParPeriode, 'STAGE');
						$statistiquesOG = $BullTQ->tableauStatistique($cotesParPeriode, 'OG');
						
						$decision = $BullTQ->listeDecisions($matricule);
						$decision = $decision[$matricule];
	
						$mentionsPossibles = array('E','TB','B','AB','S','I','TI');
						$smarty->assign('mentions', $mentionsPossibles);
						$smarty->assign('statGlobales', $statistiquesGlobales);
						$smarty->assign('statStage', $statistiquesStage);
						$smarty->assign('statOG', $statistiquesOG);
						
						$smarty->assign('decision',$decision);
						
						// établir trois sous-tableaux par type de cours
						// les cours de type OG, les cours de type 'STAGE', les autres cours
						// les trois sous-tableaux portent les noms:
						// ['cours'] pour le tout-venant
						// [leNomDuType] pour les autres (soit 'OG' ou 'STAGE', ici)
						$cotesParTypes = $BullTQ->cotesParTypes($cotesParPeriode, array('OG', 'STAGE'));

						// $listeCours = $Ecole->listeCoursListeEleves($matricule);
						// $smarty->assign('listeCours',$listeCours[$matricule]);
						$smarty->assign('listeCotes', $cotesParTypes);
						
						$qualification = $BullTQ->mentionsQualif($matricule);
						$smarty->assign('qualification',$qualification);
						$mentionsManuelles = $BullTQ->mentionsManuelles($matricule);
						$smarty->assign("mentionsManuelles", $mentionsManuelles);

						$smarty->assign('anneeScolaire',ANNEESCOLAIRE);
						$smarty->assign('etape','enregistrer');
						$smarty->assign('corpsPage', 'delibeIndividuel');

						break;
						}
				break;
		}
		
		break;
	case 'parClasse':
		if (isset($classe)) {
			$listeSituations = $BullTQ->listeSituationsClasse($classe, $bulletin);
			$smarty->assign('listeSituations',$listeSituations);
			
			$listeCoursEleves = $Ecole->listeCoursListeEleves($listeEleves);
			$smarty->assign('listeCoursEleves',$listeCoursEleves);

			$listeCours = $BullTQ->listeCoursClasse($classe);
			$smarty->assign('listeCours',$listeCours);
			
			$smarty->assign('corpsPage', 'syntheseClasse');

		}
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		
		$smarty->assign('selecteur', 'selectPeriodeClasse');
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
			// recherche la liste des décisions éventuelles pour cette liste d'élèves
			// (tous, même ceux pour lesquels aucune décision n'est prise maintenant)
			$listeDecisions = $BullTQ->listeDecisions($listeEleves);

			// est-ce le moment d'enregistrer ces décisions?
			if ($etape == 'envoyer') {
				require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
				$Thot = new thot();
				$objet = file_get_contents('templates/notification/objetMail.tpl');
				$texte = file_get_contents('templates/notification/texteMail.tpl');
				
				// envoi des notifications dans la BD; la liste des notifications obtenues est celle des matricules
				// des élèves pour lesquels on a enregistré une décision
				$listeNotifications = $Thot->notifier($_POST, $listeDecisions, $listeEleves, $acronyme);
				$listeEnvoi = array_intersect_key($listeDecisions, $listeNotifications);
	
				// envoi des mails d'avertissement $listeNotifications contient les matricules / $listeDecisions contient 
				$listeMailing = $Thot->mailer($listeEnvoi, $objet, $texte);
				// avec horodatage pour les élèves de cette liste
				$nbNotifs = $BullTQ->daterDecisions($listeNotifications);
				$nbMails = count($listeMailing);
				
				// recharger la liste des décisions pour l'ensemble de la classe
				$listeDecisions = $BullTQ->listeDecisions($listeEleves);

				// chercher la liste de synthèse des décisions qui viennent d'être actées (et seulement celles-là)
				$listeSynthDecisions = $BullTQ->listeSynthDecisions($listeNotifications);
				$smarty->assign('listeSynthDecisions',$listeSynthDecisions);
				$smarty->assign('message', array(
						'title'=>'Notifications',
						'texte'=>"$nbNotifs notification(s) et $nbMails mail(s) envoyée(s)",
						'urgence'=>'success')
						);
				$smarty->assign('listeDecisions', $listeDecisions);
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
