<?php

$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$cours = isset($_POST['cours'])?$_POST['cours']:Null;
$bulletin = isset($_POST['bulletin'])?$_POST['bulletin']:PERIODEENCOURS;

switch ($mode) {
	case 'imagesCours':
		$listeImages = $BullTQ->imagesPngBranches(200);
		$smarty->assign("listeImages", $listeImages);
		$smarty->assign("corpsPage", "imagesCours");
		break;

	case 'initialiser':
		if ($etape == 'confirmer') {
			$init = $BullTQ->init('CommentProfs');
			$init += $BullTQ->init('CotesCompetences');
			$init += $BullTQ->init('CotesGlobales');
			$init += $BullTQ->init('Mentions');
			$smarty->assign('message', array(
				'title'=>'Enregistrement',
				'texte'=>"$init tables(s) vidée(s)")
				);
			}
			else {
				$smarty->assign('action',$action);
				$smarty->assign('mode',$mode);
				$smarty->assign('etape','confirmer');
				$smarty->assign('corpsPage','confirmInit');
				}
		break;
	case 'competences':
		if ($userStatus != 'admin') die('get out of here');
		$listeNiveaux = array('5','6');
		$smarty->assign('listeNiveaux', $listeNiveaux);
		if ($niveau) {
			$smarty->assign('niveau', $niveau);
			$listeCoursComp = $BullTQ->listeCoursNiveaux($niveau);
			$smarty->assign('listeCoursComp', $listeCoursComp);
		}
		if ($etape == 'enregistrer') {
			$nbResultats = $BullTQ->enregistrerCompetences($_POST);
			$smarty->assign("message", array(
						'title'=>"Enregistrement",
						'texte'=>"$nbResultats compétence(s) modifiée(s)"));
			}
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('cours',$cours);
		$listeCompetences = $BullTQ->listeCompetencesListeCours($cours);
		$smarty->assign('listeCompetences', $listeCompetences);
		$smarty->assign('corpsPage', 'adminCompetences');
		$smarty->assign('selecteur', 'selectNiveauCours');
		break;
	default:
		break;
	}

?>
