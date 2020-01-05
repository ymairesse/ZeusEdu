<?php

require_once("../config.inc.php");
include(INSTALL_DIR.'/inc/entetes.inc.php');

// ----------------------------------------------------------------------------
//

$unAn = time() + 365 * 24 * 3600;

$classe = Application::postOrCookie('classe', $unAn);

$matricule = isset($_GET['matricule']) ? $_GET['matricule'] : Null;
if ($matricule == Null)
    $matricule = Application::postOrCookie('matricule', $unAn);

$cours = isset($_GET['cours']) ? $_GET['cours'] : Null;
if ($cours == Null)
    $cours = Application::postOrCookie('cours', $unAn);

if ($classe != Null) {
    $listeElevesClasse = $Ecole->listeEleves($classe, 'groupe');
    $smarty->assign('listeEleves',$listeElevesClasse);
    }

$onglet = isset($_POST['onglet']) ? $_POST['onglet'] : Null;

switch ($action) {
    case 'parClasses':
        if ($classe != Null) {
            $tituClasse = $Ecole->titusDeGroupe($classe);
            $listeEBS = $Ecole->getEBS($classe, 'groupe');

            $smarty->assign('nomFichier', $classe);
            $smarty->assign('cible', 'classe');
            $smarty->assign('classe', $classe);
			$smarty->assign('action','parClasses');
            $smarty->assign('tableauEleves', $listeElevesClasse);
            $smarty->assign('titulaires', $tituClasse);
            $smarty->assign('listeEBS', $listeEBS);
            $smarty->assign('corpsPage', 'trombinoscope');
        }
        break;
    case 'parCours':
        if ($cours != Null) {
            $listeElevesCours = $Ecole->listeElevesCours($cours);
            $listeEBS = $Ecole->getEBS($cours, 'coursGrp');

            $smarty->assign('cible', 'coursGrp');
            $smarty->assign('coursGrp', $cours);
            $smarty->assign('nomFichier', $cours);
            $smarty->assign('action','parCours');
            $smarty->assign('tableauEleves', $listeElevesCours);
            $smarty->assign('listeEBS', $listeEBS);
            $smarty->assign('corpsPage', 'trombinoscope');
		}
        break;
	case 'parEleve':
		if ($matricule != Null) {
            $eleve = new Eleve($matricule);
            $smarty->assign('eleve', $eleve->getDetailsEleve());
            $smarty->assign('listeCours', $eleve->listeCoursEleve());
            $classe = $eleve->classe();
            $smarty->assign('classe', $classe);
            // si le module "EDT" est installée
            if (is_dir('../edt')) {
                require_once INSTALL_DIR.'/edt/inc/classes/classEDT.inc.php';
                $Edt = new Edt();
                $imageEDT = $Edt->getEdtEleve($matricule);
                $smarty->assign('imageEDT', $imageEDT);
            }

            $eleveEBS = $Ecole->getEBS($matricule, 'eleve');
            $smarty->assign('eleveEBS', $eleveEBS);
            $listeElevesClasse = $Ecole->listeEleves($classe, 'groupe');
            $smarty->assign('listeEleves',$listeElevesClasse);
            $smarty->assign('action','parEleve');
            $smarty->assign('titulaires', $eleve->titulaires());
            $smarty->assign('onglet', $onglet);
            $smarty->assign('corpsPage', 'infoEleves');
		}
		break;
    default:
        $smarty->assign('action','parEleve');
        $smarty->assign('nbEleves', $Ecole->nbEleves());
        $smarty->assign('nbClasses', $Ecole->nbClasses());
        $smarty->assign('statAccueil', $Ecole->anniversaires());
        $smarty->assign('corpsPage', 'accueil');
        break;
}

if ($matricule != Null) {
    $smarty->assign('matricule',$matricule);
    }
if (isset($matricule) && (isset($listeElevesClasse))) {
    $prevNext = $Ecole->prevNext($matricule, $listeElevesClasse);
    $smarty->assign('prevNext', $prevNext);
    }
$smarty->assign('classe', $classe);

$smarty->assign('selecteur','selecteurs/selectClasseEleve');
$smarty->assign('listeClasses', $Ecole->listeGroupes());
$smarty->assign('lesCours', $user->listeCoursProf());

//
// ----------------------------------------------------------------------------
$smarty->assign('executionTime', round($chrono->stop(),6));
$smarty->display ('index.tpl');
