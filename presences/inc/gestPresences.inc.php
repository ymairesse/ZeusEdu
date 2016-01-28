<?php
$selectProf = isset($_POST['selectProf'])?$_POST['selectProf']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
// la date postée dans le formulaire ou la date du jour
$date = isset($_POST['date'])?$_POST['date']:strftime("%d/%m/%Y");

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes',$listePeriodes);
$lesPeriodes = range(1, count($listePeriodes));
$smarty->assign('lesPeriodes', $lesPeriodes);

$smarty->assign('listeProfs', $Ecole->listeProfs(true));

if (!empty($listePeriodes)) {
	$periode = isset($_POST['periode'])?$_POST['periode']:$Presences->periodeActuelle($listePeriodes);
	$smarty->assign('periode',$periode);

	// l'utilisateur peut-il changer la date de prise de présence?	
	$freeDate = isset($_POST['freeDate'])?$_POST['freeDate']:Null;
	// retrouver la date de travail à partir de la date du jour ou accepter la date postés si date libre souhaitée
	if ($freeDate == Null) 
		$date = strftime("%d/%m/%Y");
	$smarty->assign('freeDate', $freeDate);
	// $smarty->assign('freePeriode',$freePeriode);
	$jourSemaine = strftime('%A',$Application->dateFR2Time($date));
	$smarty->assign('jourSemaine',$jourSemaine);	
	
	$smarty->assign('date',$date);
	switch ($mode) {
		case 'tituCours':
			require('presencesTituCours.inc.php');
			break;
		case 'eleve':
			require('presencesEleve.inc.php');
			break;
		case 'cours':
			require('presencesCours.inc.php');
			break;
		case 'classe':
			require('presencesClasse.inc.php');
			break;
		default:
			$listeCoursGrp = $Ecole->listeCoursProf($acronyme);
			if (count($listeCoursGrp) > 0)
				require('presencesTituCours.inc.php');				
			break;
			}
	}
	else {
		$smarty->assign('message', array(
			'title'=>'AVERTISSEMENT',
			'texte'=>"Les périodes de cours ne sont pas encore définies. Contactez l'administrateur",
			'urgence'=>'danger'));
	}
?>
