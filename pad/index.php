<?php

require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");

// ----------------------------------------------------------------------------

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$coursGrp = isset($_REQUEST['coursGrp'])?$_REQUEST['coursGrp']:Null;
$smarty->assign('classe',$classe);
$smarty->assign('matricule',$matricule);
$smarty->assign('coursGrp', $coursGrp);

$acronyme = $user->getAcronyme();

require_once(INSTALL_DIR."/inc/classes/classPad.inc.php");

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);

$listeCours = $user->listeCoursProf();
$smarty->assign('listeCours',$listeCours);

// pour l'instant, aucune liste d'élèves
$listeEleves = Null;

switch ($action) {
	case 'parCours':
		include('inc/parCours.inc.php');
		break;
	case 'parClasse':
		include('inc/parClasse.inc.php');
		break;
	case 'partager':
		include ('inc/partager.inc.php');
		break;
	case 'mesPartages':
		include ('inc/mesPartages.inc.php');
		break;
    default:
        $smarty->assign('nbEleves', $Ecole->nbEleves());
        $smarty->assign('nbClasses', $Ecole->nbClasses());
        $smarty->assign('statAccueil', $Ecole->anniversaires());
        $smarty->assign('flashInfos', $Application->lireFlashInfos($module));
        $smarty->assign('corpsPage','accueil');
        break;
}
//
// ----------------------------------------------------------------------------

$smarty->assign('executionTime', round($chrono->stop(),6));
$smarty->display ('index.tpl');
?>
