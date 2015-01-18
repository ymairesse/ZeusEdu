<?php
$selectProf = isset($_POST['selectProf'])?$_POST['selectProf']:Null;
$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$date = isset($_POST['date'])?$_POST['date']:Null;

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes',$listePeriodes);
$lesPeriodes = range(1, count($listePeriodes));
$smarty->assign('lesPeriodes', $lesPeriodes);

// fonctionnalités seulement si prise de présence par cours ou par classe
if (in_array($mode,array('cours','classe','tituCours'))) {
	// l'utilisateur peut-il changer de période de prise de présence?
	$freePeriode = isset($_POST['freePeriode'])?$_POST['freePeriode']:Null;
	// retrouver la période actuelle à partir de l'heure ou accepter l'heure si heure libre souhaitée
	if ($freePeriode == Null)
		$periode = $Presences->periodeActuelle($listePeriodes);
		else $periode = isset($_POST['periode'])?$_POST['periode']:Null;
	$smarty->assign('periode',$periode);

	// l'utilisateur peut-il changer la date de prise de présence?	
	$freeDate = isset($_POST['freeDate'])?$_POST['freeDate']:Null;
	// retrouver la date de travail à partir de la date du jour ou accepter la date postés si date libre souhaitée
	if ($freeDate == Null) 
		$date = strftime("%d/%m/%Y");
	$smarty->assign('freeDate', $freeDate);
	$smarty->assign('freePeriode',$freePeriode);
	$jourSemaine = strftime('%A',$Application->dateFR2Time($date));
	$smarty->assign('jourSemaine',$jourSemaine);	
	}

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
		}
?>
