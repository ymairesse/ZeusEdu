<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");

// ----------------------------------------------------------------------------

$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$classe = isset($_REQUEST['classe'])?$_REQUEST['classe']:Null;

require_once(INSTALL_DIR."/inc/classes/classPad.inc.php");

$listeClasses = $Ecole->listeGroupes();
$smarty->assign("listeClasses", $listeClasses);

$listeEleves = isset($classe)?$Ecole->listeEleves($classe, 'groupe'):Null;
$smarty->assign("listeElevesClasse", $listeEleves);

$listeCours = $user->listeCoursProf();
$smarty->assign("listeCours",$listeCours);

$smarty->assign("action", $action);
$smarty->assign("mode",$mode);

$acronyme = $user->getAcronyme();

switch ($action) {
	case 'ficheEleve':
        $smarty->assign("classe",$classe);
        if ($matricule) {
			// si un matricule est donné, on aura sans doute besoin des données de l'élève
			$eleve = new Eleve($matricule);
			$smarty->assign("eleve", $eleve->getDetailsEleve());
			$titulaires = $eleve->titulaires($matricule);
			$smarty->assign("matricule",$matricule);
			$smarty->assign("titulaires", $titulaires);
			$padEleve = new padEleve($matricule, $acronyme);
			$smarty->assign("padEleve", $padEleve);
			$prevNext = $padEleve->prevNext($matricule,$listeEleves);
			$smarty->assign("prevNext", $prevNext);
			$smarty->assign("corpsPage", "ficheEleve");
			}
			else die ("missing id");
		break;

    case 'Enregistrer':
        if ($matricule) {
			$padEleve = new padEleve($matricule, $acronyme);
			$eleve = new Eleve($matricule);
			$smarty->assign("eleve", $eleve->getDetailsEleve());
			$nb = $padEleve->savePadEleve($_POST);
			$texte = ($nb>0)?"Enregistrement réussi":"Pas de modification";
			$smarty->assign("message", array(
				'title'=>"Enregistrement",
				'texte'=>$texte)
				);
			$prevNext = $padEleve->prevNext($matricule,$listeEleves);
			$smarty->assign("prevNext", $prevNext);
			$smarty->assign("matricule", $matricule);
			$smarty->assign("classe", $classe);
			$smarty->assign("padEleve", $padEleve);
			$smarty->assign("action", "ficheEleve");
			$smarty->assign("corpsPage", "ficheEleve");
			}
			else die ("missing id");
        break;
	
    default:
        $smarty->assign("nbEleves", $Ecole->nbEleves());
        $smarty->assign("nbClasses", $Ecole->nbClasses());
        $smarty->assign("statAccueil", $Ecole->anniversaires());
        $smarty->assign("flashInfos", $Application->lireFlashInfos($module));
        $smarty->assign("action", "ficheEleve");
        $smarty->assign("mode", "test");
        $smarty->assign("corpsPage", "accueil");
        break;
}
//
// ----------------------------------------------------------------------------
$smarty->assign('selecteur','selectClasseEleve');
$smarty->assign("executionTime",round(Application::chrono()-$debut,6));
$smarty->display ("index.tpl");
?>

