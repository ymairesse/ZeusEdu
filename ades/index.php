<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");
// ----------------------------------------------------------------------------
//

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
		$idfait = isset($_REQUEST['idfait'])?$_REQUEST['idfait']:Null;
		$type = isset($_REQUEST['type'])?$_REQUEST['type']:Null;
		switch ($mode) {
			case 'suppr':
				if ($idfait != Null) {
				$nb = $ficheDisc->supprFait($idfait);
				$smarty->assign("message", array(
					'title'=>"Suppression",
					'texte'=>"Effacement de: $nb fait(s)"),
				3000);
				$ficheDisc->relireFaitsDisciplinaires($matricule);
				$afficherEleve = true;
				}
				break;
			case 'new':
				$prototype = $Ades->prototypeFait($type);
				$faitVide = $ficheDisc->faitVide($prototype,$type,$user->identite());
				$smarty->assign('fait',$faitVide);
				$smarty->assign('type',$type);
				// break;  pas de break, on poursuit sur l'édition du fait vide
			case 'edit':
				if (isset($idfait)) {
					// on ne vient pas du case 'new', il faut assigner le $fait et le $type
					$fait = $ficheDisc->lireUnFait($idfait);
					$smarty->assign('fait',$fait);
					$type = $fait['type'];
					$smarty->assign('type',$type);
				}
				// liste nécessaire pour obtenir une liste des profs à l'origine du signalement du fait
				$smarty->assign('listeProfs',$Ecole->listeProfs(false));
				// acronyme de l'utilisateur pour indiquer qui a pris note du fait
				$smarty->assign('acronyme',$user->acronyme());
				
				$prototype = $Ades->prototypeFait($type);
				$smarty->assign('prototype', $prototype);
				$listeRetenues = $Ades->listeRetenues($prototype['structure']['typeRetenue'], true);
				$smarty->assign('listeRetenues', $listeRetenues);
				$smarty->assign('listeMemos',$Ades->listeMemos($user->acronyme()));

				$smarty->assign('action',$action);
				$smarty->assign('mode','enregistrer');
				$smarty->assign('classe',$classe);
				$smarty->assign('matricule',$matricule);
				$smarty->assign('corpsPage','editFaitDisciplinaire');
				break;
			case 'enregistrer':
				echo "$action";
				$type=isset($_POST['type'])?$_POST['type']:Null;
				$oldIdretenue = isset($_POST['oldIdretenue'])?$_POST['oldIdretenue']:Null;
				// s'il n'y a pas de idretenue mais qu'on a un oldIdretenue, c'est que la date de retenue n'est plus accessible (cachée)
				// dans la liste déroulante; alors, on prend l'ancien idretenue comme base
				$idretenue = (isset($_POST['idretenue']) && $_POST['idretenue'] != '')?$_POST['idretenue']:$oldIdretenue;
				$prototype = $Ades->prototypeFait($type);
				$retenue = ($prototype['structure']['typeRetenue'] != 0)?$Ades->detailsRetenue($idretenue):Null;

				$nb = $ficheDisc->enregistrerFaitDisc($_POST, $prototype, $retenue);
				$smarty->assign("message", array(
					'title'=>"Enregistrement",
					'texte'=>"Enregistrement de: $nb fait(s)"),
				3000);
				$ficheDisc->relireFaitsDisciplinaires($matricule);
				$afficherEleve = true;
				$action = Null; $mode= Null;
				break;
			}
		break;

	case 'eleves':
		switch ($mode) {
			case 'selection':
				$smarty->assign('listeClasses', $Ecole->listeGroupes());
				if (isset($classe))
					$smarty->assign('listeEleves', $Ecole->listeEleves($classe));
				$smarty->assign('action',$action);
				$smarty->assign('mode',$mode);
				$afficherEleve = ($etape == 'showEleve')?true:Null;
				$smarty->assign('selecteur','selectClasseEleve');
				break;
			case 'trombinoscope':
				$smarty->assign('lesGroupes', $Ecole->listeGroupes());
				$smarty->assign('selecteur','selectClasse');
				$smarty->assign('action',$action);
				$smarty->assign('mode',$mode);
				if (($etape == 'showEleve') && isset($classe)) {
					$listeElevesClasse = $Ecole->listeEleves($classe,'groupe');
					$smarty->assign("classe",$classe);
					$smarty->assign("tableauEleves", $listeElevesClasse);
					$smarty->assign("corpsPage","trombinoscope");
				}
				$afficherEleve = (isset($matricule))?true:Null;
				break;
			default:
				if (isset($matricule) && isset($classe)) {
					$afficherEleve = true;
				}
			}
	default:
		// wtf
		break;
}

// pour les différents cas où il faut afficher une fiche d'élève, on affiche
if (isset($afficherEleve) && ($afficherEleve == true)) {
	$smarty->assign("listeTypesFaits", $Ades->listeTypesFaits());
	$smarty->assign("descriptionChamps", $Ades->listeChamps());
	$smarty->assign('action',$action);
	$smarty->assign('mode',$mode);
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
$smarty->assign("executionTime",round(Application::chrono()-$debut,6));
$smarty->display ("index.tpl");
?>
