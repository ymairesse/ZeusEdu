<?php

$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;

$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('classe',$classe);

switch ($mode) {
	case 'parClasse':
		$listeClasses = $Ecole->listeClasses();
		$smarty->assign('listeClasses',$listeClasses);
		$smarty->assign('selecteur','selectClasse');
		// une classe a été choisie, listons les élèves
		if (isset($classe)) {
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			$acronyme = $user->acronyme();
			$listePartages = PadEleve::listePartages($acronyme,$listeEleves);
			$smarty->assign('listeEleves',$listeEleves);
			$smarty->assign('listePartages',$listePartages);
			$listeProfs = $Ecole->listeProfs();
			$smarty->assign('listeProfs',$listeProfs);
			$smarty->assign('corpsPage','showPartages');
			}

		break;

	case 'parCours':
		$listeCours = $user->listeCoursProf();
		$smarty->assign('listeCours',$listeCours);
		$smarty->assign('selecteur','selectCours');

		// un cours a été choisi, listons les élèves
		if (isset($coursGrp)) {
			$listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha');
			$acronyme = $user->acronyme();
			$listePartages = PadEleve::listePartages($acronyme, $listeEleves);
			$smarty->assign('listeEleves',$listeEleves);
			$smarty->assign('listePartages',$listePartages);
			$listeProfs = $Ecole->listeProfs();
			$smarty->assign('listeProfs',$listeProfs);
			$smarty->assign('corpsPage','showPartages');
			}
		break;
	}
