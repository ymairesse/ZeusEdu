<?php

$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$moderw = isset($_POST['moderw'])?$_POST['moderw']:'r';
$smarty->assign('coursGrp',$coursGrp);
$smarty->assign('classe',$classe);
$smarty->assign('moderw',$moderw);

$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$listeEleves = isset($_POST['eleves'])?$_POST['eleves']:Null;
$listeProfs = isset($_POST['profs'])?$_POST['profs']:Null;

$listeProfs = $Ecole->listeProfs();
$smarty->assign('listeProfs', $listeProfs);

switch ($mode) {
	case 'parCours':
		$listeCoursGrp = $user->listeCoursProf();
		$smarty->assign('listeCoursGrp',$listeCoursGrp);
		$smarty->assign('corpsPage', 'partageCoursGrp');
		break;
	case 'parClasse':
		$listeClasses = $Ecole->listeGroupes();
		$smarty->assign('listeClasses', $listeClasses);
		$smarty->assign('corpsPage', 'partageClasses');
		break;
	case 'parNiveau':
		$listeNiveaux = $Ecole->listeNiveaux();
		$smarty->assign('listeNiveaux', $listeNiveaux);
		$smarty->assign('corpsPage', 'partageNiveau');
	}
