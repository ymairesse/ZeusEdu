<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");
// ----------------------------------------------------------------------------
//

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$classe = isset($_POST['classe'])?$_POST['classe']:Null;
$consultID = isset($_POST['consultID'])?$_POST['consultID']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$smarty->assign('matricule',$matricule);

$onglet = isset($_POST['onglet'])?$_POST['onglet']:0;

$smarty->assign('listeClasses', $Ecole->listeGroupes());
$smarty->assign('onglet',$onglet);

require_once(INSTALL_DIR."/$module/inc/classes/classVisite.inc.php");

// le sélecteur retourne une valeur pour $matricule
if ($matricule != '') {
    $eleve = new Eleve($matricule);
	$dataEleve = $eleve->getDetailsEleve();
	$smarty->assign('eleve', $dataEleve);

	$classe = $dataEleve['groupe'];
	$smarty->assign('classe',$classe);

	$listeEleves = $Ecole->listeEleves($classe,'groupe');
	$smarty->assign('listeEleves',$listeEleves);

	$prevNext = $Ecole->prevNext($matricule, $listeEleves);
	$smarty->assign('prevNext',$prevNext);

	$titulaires = $eleve->titulaires($matricule);
	$smarty->assign('titulaires', $titulaires);

    require_once("inc/classes/classInfirmerie.inc.php");
    $infirmerie = new eleveInfirmerie($matricule);
    }

switch ($action) {
	case 'ficheEleve':
        if ($etape == 'enregistrer') {
            $infoMedicale = isset($_POST['infoMedicale'])?$_POST['infoMedicale']:Null;
            if ($matricule != Null)
                $nb = $infirmerie->saveInfoMedic($matricule, $infoMedicale);
        }
		if (isset($matricule)) {
            $smarty->assign('medicEleve',$infirmerie->getMedicEleve($matricule));
            $smarty->assign('consultEleve',$infirmerie->getVisitesEleve($matricule));
            }
		$smarty->assign('mode',$mode);
		$smarty->assign('corpsPage','ficheEleve');
		break;

    case 'modifier':
       	require('inc/modifier.inc.php');
        break;

    case 'supprimer':
		require('inc/supprimer.inc.php');
        break;

    case 'enregistrer':
		require('inc/enregistrer.inc.php');
        break;
	case 'synthese':
		require('inc/synthese.inc.php');
		break;
	case 'news':
		require('inc/news.inc.php');
		break;
	}


// si rien n'a encore été assigné au sélecteur, on présente le sélecteur par défaut.
if ($smarty->getTemplateVars('selecteur') == Null) {
	$smarty->assign('classe',$classe);
	$listeEleves=($classe!= Null)?$Ecole->listeEleves($classe,'groupe'):Null;
	$smarty->assign('action','ficheEleve');
	$smarty->assign('mode','wtf');
	$smarty->assign('listeEleves', $listeEleves);
	$smarty->assign('selecteur', 'selectClasseEleve');
}

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$FlashInfo = new FlashInfo();

$listeFlashInfos = $FlashInfo->listeFlashInfos($module);
$smarty->assign('module', $module);
$smarty->assign('userStatus', $userStatus);
$smarty->assign('listeFlashInfos', $listeFlashInfos);


// // si rien n'a encore été assigné au corps de page, on présente le corps par défaut.
// if ($smarty->getTemplateVars('corpsPage') == Null) {
// 	require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");
// 	$flashInfo = new flashInfo();
// 	$appli = $Application->repertoireActuel();
// 	$smarty->assign('flashInfos', $flashInfo->listeFlashInfos ($appli));
// 	$smarty->assign('corpsPage', 'news');
// 	}

//
// ----------------------------------------------------------------------------
$smarty->assign('INSTALL_DIR', INSTALL_DIR);
$smarty->assign('executionTime', round($chrono->stop(),6));

$smarty->display ('index.tpl');
