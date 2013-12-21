<?php
require_once("../config.inc.php");
include(INSTALL_DIR.'/inc/entetes.inc.php');

// ----------------------------------------------------------------------------
//
$classe = isset($_REQUEST['classe'])?$_REQUEST['classe']:Null;
$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$cours = isset($_REQUEST['cours'])?$_REQUEST['cours']:Null;

$smarty->assign('listeClasses', $Ecole->listeGroupes());
$smarty->assign('lesCours', $user->listeCoursProf());
$smarty->assign('selecteur','selectNomClasse');

switch ($action) {
    case 'parClasses':
        if ($classe != Null) {
            $listeElevesClasse = $Ecole->listeEleves($classe, 'groupe');

            $tituClasse = $Ecole->titusDeGroupe($classe);
            $fichierPDF = pagePDF($listeElevesClasse, $classe);
            $fichierCSV = fichierCSV($listeElevesClasse, $classe);
            $smarty->assign("fichierPDF", $fichierPDF);
            $smarty->assign("fichierCSV", $fichierCSV);
            $smarty->assign("classe", $classe);
			$smarty->assign('action',$action);
            $smarty->assign("tableauEleves", $listeElevesClasse);
            $smarty->assign("titulaires", $tituClasse);
            $smarty->assign("corpsPage", "trombinoscope");
        }
        break;
    case 'parCours':
        if ($cours != Null) {
			$listeElevesCours = $Ecole->listeElevesCours($cours);
			$fichierPDF = pagePDF($listeElevesCours, $cours);
			$fichierCSV = fichierCSV($listeElevesCours, $cours);
			
			$smarty->assign("fichierPDF", $fichierPDF);
			$smarty->assign("fichierCSV", $fichierCSV);
			$smarty->assign("cours", $cours);
			$smarty->assign("tableauEleves", $listeElevesCours);
			$smarty->assign("corpsPage", "trombinoscope");
		}
        break;
	case 'parEleve':
		if ($matricule != Null) {
			$eleve = new Eleve($matricule);
			$smarty->assign("eleve", $eleve->getDetailsEleve());
			$smarty->assign('classe', $eleve->classe());
			$smarty->assign("age", $eleve->age());
			$smarty->assign("titulaires", $eleve->titulaires());
			$smarty->assign("corpsPage", "infoEleves");
		}
		break;
    default:
		$smarty->assign('action','parClasses');
        $smarty->assign("nbEleves", $Ecole->nbEleves());
        $smarty->assign("nbClasses", $Ecole->nbClasses());
        $smarty->assign("statAccueil", $Ecole->anniversaires());
        $smarty->assign("corpsPage", "accueil");
        break;
}
//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime",round(Application::chrono()-$debut,6));
$smarty->display ("index.tpl");
?>
