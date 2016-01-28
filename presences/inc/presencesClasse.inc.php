<?php
// prise de présence par classe
if ($etape == 'enregistrer') {
	if (isset($classe)) {
		$listeEleves = $Ecole->listeEleves($classe,'groupe');
		$nb = $Presences->savePresences($_POST, $listeEleves, array($periode=>$periode));
		$smarty->assign('message', array(
				'title'=> SAVE,
				'texte'=>sprintf(NBSAVE,$nb),
				'urgence'=>'info'
				));
		}
	}

// une classe a été sélectionnée
if (isset($classe)){
	$smarty->assign('classe',$classe);
	if (!(isset($listeEleves))) {
		// si on a enregistré, $listeEleves est déjà connu
		$listeEleves = $Ecole->listeEleves($classe,'groupe');
		}
	$smarty->assign('listeEleves',$listeEleves);
	$smarty->assign('nbEleves',count($listeEleves));
	}


$listeClasses = $Ecole->listeClasses();
$smarty->assign('listeClasses',$listeClasses);
$smarty->assign('date',$date);

if (isset($classe) && (isset($listeEleves))) {
	$listePresences = $Presences->listePresencesElevesDate($date,$listeEleves);
	$smarty->assign('classe',$classe);
	}

$listePresences = isset($listePresences)?$listePresences:Null;
$smarty->assign('listePresences', $listePresences);
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('selecteur','selectPeriodeDateClasse');
$smarty->assign('corpsPage','feuillePresencesClasse');
?>
