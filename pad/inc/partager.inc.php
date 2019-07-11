<?php

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;
$classe = isset($_POST['classe']) ? $_POST['classe'] : Null;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : Null;
$moderw = isset($_POST['moderw']) ? $_POST['moderw']:'r';
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('classe',$classe);
$smarty->assign('niveau', $niveau);

$smarty->assign('moderw',$moderw);

$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$listeEleves = isset($_POST['eleves'])?$_POST['eleves']:Null;
$listeProfs = isset($_POST['profs'])?$_POST['profs']:Null;

if ((($mode == 'parCours') || ($mode == 'parClasse')) && ($etape == 'enregistrer')) {
	$acronyme = $user->acronyme();
	$nb = padEleve::savePartages($acronyme, $moderw, $listeEleves, $listeProfs);
	if ($nb > 0) {
		$smarty->assign("message", array(
			'title'=>SAVE,
			'texte'=>"Ajout de: ".$nb." enregistrement(s)"),
		3000);
		}
		else if  ($nb < 0) {
				$smarty->assign("message", array(
				'title'=>SAVE,
				'texte'=>"Suppression de: ".-$nb." enregistrement(s)"),
			3000);}
			else {
				$smarty->assign("message", array(
				'title'=>SAVE,
				'texte'=>"Aucune modification"),
				3000);
				}
	}

switch ($mode) {
	case 'parCours':
		$listeCours = $user->listeCoursProf();
		$smarty->assign('listeCours',$listeCours);
		$smarty->assign('selecteur','selectCours');

		// un cours a été choisi, listons les élèves
		if (isset($coursGrp)) {
			$listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha',false) ;
			$smarty->assign('listeEleves',$listeEleves);
			$listeProfs = $Ecole->listeProfs();
			$smarty->assign('listeProfs',$listeProfs);
			$smarty->assign('corpsPage','choixEleves');
			}
		break;
	case 'parClasse':
		$listeClasses = $Ecole->listeClasses();
		$smarty->assign('listeClasses',$listeClasses);
		$smarty->assign('selecteur','selectClasse');
		// une classe a été choisie, listons les élèves
		if (isset($classe)) {
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			$smarty->assign('listeEleves', $listeEleves);
			$listeProfs = $Ecole->listeProfs();
			$smarty->assign('listeProfs', $listeProfs);
			$smarty->assign('corpsPage','choixEleves');
			}
		break;

	case 'parNiveau':
		$listeNiveaux = $Ecole->listeNiveaux();
		$smarty->assign('listeNiveaux', $listeNiveaux);
		$smarty->assign('selecteur', 'selectNiveau');

		// un niveau a été choisi, listons les classes
		if (isset($niveau)) {
			$smarty->assign('niveau', $niveau);
			$listeClasses = $Ecole->listeClassesNiveau($niveau);
			$smarty->assign('listeClasses', $listeClasses);
			$listeProfs = $Ecole->listeProfs();
			$smarty->assign('listeProfs', $listeProfs);
			$smarty->assign('corpsPage', 'parNiveau');
		}


	}
