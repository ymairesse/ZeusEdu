<?php

$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$etapeFormulaire = isset($_POST['etapeFormulaire'])?$_POST['etapeFormulaire']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$matricule2 = isset($_POST['matricule2'])?$_POST['matricule2']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$date = isset($_POST['date'])?$_POST['date']:Application::dateNow();

// par défaut, action et mode reprennent leurs valeurs actuelles; on re-changera éventuellement plus tard.
$smarty->assign('action', $action);
$smarty->assign('mode', $mode);

// on prend la valeur de $matricule (le sélecteur d'élèves de la classe sélectionnée) ou de $matricule2 (la liste automatique)
$matricule = ($matricule!='')?$matricule:$matricule2;
$smarty->assign('matricule',$matricule);

// si un élève est déclaré, on aura certainement besoin des détails
if ($matricule != Null) {
    $eleve = new Eleve($matricule);
    $classe = $eleve->groupe();
    $matricule = $eleve->matricule();
    $smarty->assign('eleve',$eleve->getDetailsEleve());
	}

// informations pour le sélecteur classe/élève
$smarty->assign('classe',$classe);
$listeEleves = isset($classe)?$Ecole->listeEleves($classe,'groupe'):Null;
$smarty->assign('listeEleves',$listeEleves);
$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);

// va-t-on remontrer la liste des autorisations pour l'élève en cours? Par défaut, non...
$showAutorisations = false;

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes',$listePeriodes);

switch ($mode) {
	case 'encoder':
		// ce 'case' ne fait rien que présenter la liste des autorisations existantes avec un bouton pour 'newAutorisation'
		if ($matricule != '')
			$showAutorisations = true;
		break;
	case 'newAutorisation':
		if ($etape == 'enregistrer') {
			$nb = $Presences->saveSorties($_POST, $matricule);
			$smarty->assign("message", array(
						  'title'=>SAVE,
						  'texte'=>"Enregistrement de: $nb autorisation(s) de sortie"),
					  3000);
			// après enregistrement, le sélecteur revient en mode 'encoder'
			$smarty->assign('mode','encoder');
			// on re-montrera la liste des autorisations de sortie
			$showAutorisations = true;
			}
			else $showAutorisations = false;
		$date = Application::dateNow();
		$smarty->assign('date',$date);
		$heure = date('H:i');
		$smarty->assign('heure',$heure);
		$presences = $Presences->listePresencesElevesDate($matricule,$date);
		$smarty->assign('presences',$presences);
		$smarty->assign('media','Journal de classe');
		$smarty->assign('parent','Parents');
		$smarty->assign('selecteur','selectClasseEleve');		
		$smarty->assign('corpsPage','newAutorisation');
		break;
	case 'edit':
		if ($etape == 'enregistrer') {
			$nb = $Presences->saveSortie($_POST,$listePeriodes);
			$smarty->assign("message", array(
						'title'=>SAVE,
						'texte'=>"Enregistrement de: $nb autorisation(s) de sortie"),
					3000);
			// après enregistrement, le sélecteur revient en mode 'encoder'
			$smarty->assign('mode','encoder');
			// on remontrera la liste des autorisations de sortie
			$showAutorisations = true;
			// -------------------------------------------------
			}
			else $showAutorisations = false;
		$acronyme = $user->getAcronyme();
		$date = (isset($date))?$date:Application::dateNow();
		$date = Application::dateMysql($date);
		$autorisation = $Presences->getSortie($date,$matricule);
		$presences = $Presences->listePresencesElevesDate($matricule, $autorisation['date']);
		$smarty->assign('presences',$presences);
		$smarty->assign('user',$acronyme);
		$smarty->assign('media',$autorisation['media']);
		$smarty->assign('parent',$autorisation['parent']);
		$smarty->assign('date',$autorisation['date']);
		$smarty->assign('heure',$autorisation['heure']);
		$smarty->assign('selecteur','selectClasseEleve');	
		$smarty->assign('corpsPage','newAutorisation');
		break;

	case 'listes':
		$dateDebut = isset($_POST['dateDebut'])?$_POST['dateDebut']:Null;
		$dateFin = isset($_POST['dateFin'])?$_POST['dateFin']:Null;
		$smarty->assign('dateDebut',$dateDebut);
		$smarty->assign('dateFin',$dateFin);
		$smarty->assign('etape','showListe');
		$smarty->assign('selecteur','selectPeriode');
		if ($etape == 'showListe') {
			$liste = $Presences->listeParPeriode($dateDebut,$dateFin);
			$smarty->assign('listeAutorisations',$liste);
			$smarty->assign('corpsPage','listeAutorisations');
		  }
		break;
	default:
		$showAutorisations = true;
	break;
	}

if ($smarty->getTemplateVars('selecteur') === null) 
	$smarty->assign('selecteur','selectClasseEleve');

if (($showAutorisations == true) && ($matricule != '')) {
	$listePresences = $Presences->listePresencesEleve($matricule);
	$smarty->assign('listePresences',$listePresences);
	// on re-montre la liste des autorisations de sortie pour l'élève donné
	$listeAutorisations = $Presences->listeSorties($matricule);
	$smarty->assign('listeAutorisations',$listeAutorisations);
	$smarty->assign('corpsPage','autorisations');
	}

?>
