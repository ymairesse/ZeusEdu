<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");
// ----------------------------------------------------------------------------
//

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$classe = isset($_REQUEST['classe'])?$_REQUEST['classe']:Null;
$matricule = isset($_REQUEST['matricule'])?$_REQUEST['matricule']:Null;
$matricule2 = isset($_POST['matricule2'])?$_POST['matricule2']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;

$acronyme = $user->getAcronyme();
$smarty->assign('acronyme',$acronyme);

require_once(INSTALL_DIR."/$module/inc/classes/classAdes.inc.php");
$Ades = new Ades();

if (($matricule != '') || ($matricule2 != '')) {
    // si un matricule est donné, on aura sans doute besoin des données de l'élève
	require_once(INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php");
	// on prend la valeur de $matricule (le sélecteur d'élèves de la classe sélectionnée) ou de $matricule2 (la liste automatique)
	$matricule = ($matricule!='')?$matricule:$matricule2;
	$eleve = new Eleve($matricule);
	$ficheDisc = new EleveAdes($matricule);

	$titulaires = $eleve->titulaires($matricule);
	$smarty->assign('matricule',$matricule);
	$smarty->assign('eleve', $eleve->getDetailsEleve());

	$classe = $eleve->getDetailsEleve();
	$classe = $classe['groupe'];
	$listeEleves = $Ecole->listeEleves($classe,'groupe');
	$prevNext = $Ecole->prevNext($matricule, $listeEleves);
	$smarty->assign('prevNext',$prevNext);
	$smarty->assign('ficheDisc', $ficheDisc);
	$smarty->assign('titulaires', $titulaires);
    }

switch ($action) {
	case 'admin':
		include ('inc/admin.inc.php');
		break;
	case 'users':
		include ('inc/users.inc.php');
		break;
	case 'synthese':
		include ('inc/synthese.inc.php');
		break;
	case 'retenues':
		include ('inc/retenues.inc.php');
		break;
	case 'print':
		include('inc/print.inc.php');
		break;
	case 'fait':
		include('inc/fait.inc.php');
		break;
	case 'news':
		if (in_array($userStatus, array('admin','educ')))
			include ("inc/delEditNews.php");
		break;
	default:
		include('inc/eleve.inc.php');
		break;

}

// pour les différents cas où il faut afficher une fiche d'élève, on affiche
if (isset($afficherEleve) && ($afficherEleve == true)) {
	require_once(INSTALL_DIR."/$module/inc/classes/classMemo.inc.php");
	$memoEleve = new memoAdes($matricule,'ades');
	$smarty->assign('memoEleve',$memoEleve);
	$smarty->assign('listeTypesFaits', $Ades->listeTypesFaits());
	$smarty->assign('descriptionChamps', $Ades->listeChamps());
	$smarty->assign('etape','showEleve');
	$smarty->assign('classe',$classe);
	$smarty->assign('matricule',$matricule);
	$smarty->assign('listeClasses', $Ecole->listeGroupes());
	$listeEleves = $Ecole->listeEleves($classe, 'groupe');
	$smarty->assign('listeElevesClasse', $listeEleves);
	$smarty->assign('corpsPage','ficheEleve');
	}

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display ("index.tpl");
?>
