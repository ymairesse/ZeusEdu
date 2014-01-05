<?php
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
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

switch ($mode) {
	case 'individuel':
		$smarty->assign('etape','showEleve');
		$smarty->assign('selecteur','selectClasseEleve');
		switch ($etape) {
			case 'enregistrer':
				$nb =  $BullTQ->enregistrerDelibe($_POST);
				$smarty->assign("message", array(
				'title'=>"Enregistrement",
				'texte'=>"Enregistrement de $nb mentions"),
				3000);
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
	
						$mentionsPossibles = array('E','TB','B','AB','S','I','TI');
						$smarty->assign('mentions', $mentionsPossibles);
						$smarty->assign('statGlobales', $statistiquesGlobales);
						$smarty->assign('statStage', $statistiquesStage);
						$smarty->assign('statOG', $statistiquesOG);						
						
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
	
}
?>