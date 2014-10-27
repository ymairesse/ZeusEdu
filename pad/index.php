<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");

// ----------------------------------------------------------------------------

$smarty->assign('action',$action);

$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$classe = isset($_REQUEST['classe'])?$_REQUEST['classe']:Null;
$cours = isset($_REQUEST['cours'])?$_REQUEST['cours']:Null;
$smarty->assign('classe',$classe);
$smarty->assign('matricule',$matricule);
$smarty->assign('cours', $cours);

// la liste d'élèves d'un cours
if (isset($cours)) 
	$listeEleves = $Ecole->listeElevesCours($cours);
	else
		// ou la liste d'élèves d'une classe
		if (isset($classe))
			$listeEleves = $Ecole->listeEleves($classe, 'groupe');
			// ou rien...
			else $listeEleves = Null;
$smarty->assign('listeEleves', $listeEleves);

require_once(INSTALL_DIR."/inc/classes/classPad.inc.php");

$listeClasses = $Ecole->listeGroupes();
$smarty->assign('listeClasses', $listeClasses);

$listeCours = $user->listeCoursProf();
$smarty->assign('listeCours',$listeCours);

// on enregistre le pad
$acronyme = $user->getAcronyme();
if ($mode == 'Enregistrer') {
	if ($matricule) {
		$padEleve = new padEleve($matricule, $acronyme);
		$nb = $padEleve->savePadEleve($_POST);
		$texte = ($nb>0)?"Enregistrement réussi":"Pas de modification";
		$smarty->assign('message', array(
			'title'=>"Enregistrement",
			'texte'=>$texte)
			);
		}
	}

switch ($action) {
	case 'parCours':
		$listeEleves = $Ecole->listeElevesCours($cours);
		if (isset($matricule)) {
			// si un matricule est donné, on aura sans doute besoin des données de l'élève
			$eleve = new Eleve($matricule);
			$smarty->assign('eleve', $eleve->getDetailsEleve());
			$titulaires = $eleve->titulaires($matricule);
			$smarty->assign('titulaires', $titulaires);
			$padEleve = new padEleve($matricule, $acronyme);
			$smarty->assign('padEleve', $padEleve);
			$smarty->assign('corpsPage','ficheEleve');			
			}
		$smarty->assign('selecteur','selectEleve');
		break;
	
	case 'parClasse':
		$listeEleves = $Ecole->listeEleves($classe,'groupe');
		$smarty->assign('listeEleves',$listeEleves);
        if (isset($matricule)) {
			// si un matricule est donné, on aura sans doute besoin des données de l'élève
			$eleve = new Eleve($matricule);
			$smarty->assign('eleve', $eleve->getDetailsEleve());
			$titulaires = $eleve->titulaires($matricule);
			$smarty->assign('titulaires', $titulaires);
			$padEleve = new padEleve($matricule, $acronyme);
			$smarty->assign('padEleve', $padEleve);
			$smarty->assign('corpsPage','ficheEleve');
			}
		$smarty->assign('selecteur','selectClasseEleve');
		break;
    default:
        $smarty->assign('nbEleves', $Ecole->nbEleves());
        $smarty->assign('nbClasses', $Ecole->nbClasses());
        $smarty->assign('statAccueil', $Ecole->anniversaires());
        $smarty->assign('flashInfos', $Application->lireFlashInfos($module));
        $smarty->assign('selecteur','selectClasseEleve');
        $smarty->assign('action','parClasse');
        $smarty->assign('corpsPage','accueil');
        break;
}
//
// ----------------------------------------------------------------------------

$smarty->assign('executionTime', round($chrono->stop(),6));
$smarty->display ('index.tpl');
?>

