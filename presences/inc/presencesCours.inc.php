<?php
// prise de présence par cours
if ($etape == 'enregistrer') {
	if (isset($coursGrp)) {
		$listeEleves = $Ecole->listeElevesCours($coursGrp,'alpha');
		$nb = $Presences->savePresences($_POST, $listeEleves, array($periode=>$periode));
		$smarty->assign('message', array(
				'title'=> SAVE,
				'texte'=>sprintf(NBSAVE,$nb),
				'urgence'=>'success'
				));
		}
	}

// un nom de prof a été sélectionné?
if ($selectProf) {
	$smarty->assign('acronyme', $selectProf);
	$listeCoursGrp = $Ecole->listeCoursProf($selectProf);
	if ($coursGrp) {
		if (!(isset($listeEleves))) {
			// si on a enregistré, $listeEleves est déjà connu
			$listeEleves = $Ecole->listeElevesCours($coursGrp,'alpha');
			}
		$smarty->assign('listeEleves',$listeEleves);
		$smarty->assign('nbEleves',count($listeEleves));
		}
	}
	else $listeCoursGrp = Null;
	
$smarty->assign('listeProfs', $Ecole->listeProfs(true));
$smarty->assign('date',$date);
$smarty->assign('listeCoursGrp',$listeCoursGrp);

if (isset($coursGrp)) {
	$listePresences = $Presences->listePresencesElevesDate($date,$listeEleves);
	$smarty->assign('coursGrp',$coursGrp);
	}
	
$listePresences = isset($listePresences)?$listePresences:Null;
$smarty->assign('listePresences', $listePresences);
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('selecteur', 'selectHeureProfCours');		
$smarty->assign('corpsPage','feuillePresencesCours');
?>
