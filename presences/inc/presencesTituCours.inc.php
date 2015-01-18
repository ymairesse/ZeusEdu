<?php
// prise de présence par cours par le titulaire du cours
if ($etape == 'enregistrer') {
	if (isset($coursGrp)) {
	$listeEleves = $Ecole->listeElevesCours($coursGrp,'alpha');
	$nb = $Presences->savePresences($_POST, $listeEleves, array($periode=>$periode));
	$smarty->assign('message', array(
				'title'=> SAVE,
				'texte'=>sprintf(NBSAVE,$nb),
				'icon'=>'../images/info.png'
				));
		}
	}

$coursGrp = isset($_REQUEST['coursGrp'])?$_REQUEST['coursGrp']:Null;
$acronyme = $user->getAcronyme();
$smarty->assign('acronyme',$acronyme);

$listeCoursGrp = $Ecole->listeCoursProf($acronyme);
$smarty->assign('listeCoursGrp',$listeCoursGrp);
$smarty->assign('listeProfs', $Ecole->listeProfs(true));

if (isset($coursGrp)) {
	if (!(isset($listeEleves))) {
		// si on a enregistré, $listeEleves est déjà connu
		$listeEleves = $Ecole->listeElevesCours($coursGrp,'alpha');
		}
	$smarty->assign('listeEleves',$listeEleves);
	$smarty->assign('nbEleves',count($listeEleves));
	}
	
$smarty->assign('date',$date);

if (isset($coursGrp)) {
	$listePresences = $Presences->listePresencesElevesDate($date,$listeEleves);
	$smarty->assign('coursGrp', $coursGrp);
	}

$listePresences = isset($listePresences)?$listePresences:Null;
$smarty->assign('listePresences', $listePresences);
$smarty->assign('action',$action);
$smarty->assign('mode',$mode);
$smarty->assign('selecteur', 'selectPeriodeCours');		
$smarty->assign('corpsPage','feuillePresencesCours');
?>
