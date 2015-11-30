<?php
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

// prise de présence par cours par le titulaire du cours

$listeCoursGrp = $Ecole->listeCoursProf($acronyme);
$coursGrp = isset($_REQUEST['coursGrp'])?$_REQUEST['coursGrp']:Null;

$smarty->assign('listeCoursGrp',$listeCoursGrp);
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('acronyme',$acronyme);

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

// un coursGrp a été sélectionné
if (isset($coursGrp)) {
	if (!(isset($listeEleves))) {
		// si on a enregistré, $listeEleves est déjà connu
		$listeEleves = $Ecole->listeElevesCours($coursGrp,'alpha');
		}
	$listePresences = $Presences->listePresencesElevesDate($date,$listeEleves);
	$smarty->assign('listeEleves',$listeEleves);
	$smarty->assign('nbEleves',count($listeEleves));

	$listePresences = isset($listePresences)?$listePresences:Null;
	$smarty->assign('listePresences', $listePresences);
	$smarty->assign('action',$action);
	$smarty->assign('mode',$mode);
	$smarty->assign('corpsPage','feuillePresencesCours');
	}
	else {
		// on présente la liste de choix des coursGrp
		$smarty->assign('corpsPage','choixCoursProf');
	}

?>
