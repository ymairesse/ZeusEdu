<?php
require_once('../config.inc.php');
include (INSTALL_DIR.'/inc/entetes.inc.php');

// -------------------------------------------------------------------------------
// listes des groupes/classes et liste des profs pour le sélecteur en haut de page
$smarty->assign('lesGroupes', $Ecole->listeGroupes());
$smarty->assign('listeProfs', $Ecole->listeProfs());

// -------------------------------------------------------------------------------
// le groupe/classe qui a éventuellement été choisi dans le sélecteur
$groupe = isset($_POST['groupe'])?$_POST['groupe']:Null;
$smarty->assign('groupe', $groupe);

// -------------------------------------------------------------------------------
// le prof qui a éventuellemnt déjà été choisi dans le sélecteur
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$smarty->assign('acronyme', $acronyme);

switch ($action) {
	// on a dû sélectionner l'un des titulaires (profs principaux) de la classe
	case 'selectTitu':
		// on prend le premier élément du tableau $acronyme
		$acronyme = $acronyme[0];
		break;
	default:
		// c'est un groupe qui a été choisi dans le sélecteur
		if ($groupe != Null) {
			// on recherche qui sont les titulaires du groupe demandé
			$listeTitulaires = $Ecole->titusDeGroupe($groupe);
			$nbTitulaires = count($listeTitulaires);
			switch ($nbTitulaires) {
				case 0: // on n'a pas de titulaire (prof principal) pour ce groupe
					$smarty->assign('corpsPage','noTitu');
					break;
				case 1: // un seul titulaire (prof principal)
					$acronyme = array_keys($listeTitulaires);
					$acronyme = $acronyme[0];
					break;
				default: // plus que un seul titulaire (prof principal)
					$smarty->assign('action','selectTitu');
					$smarty->assign('listeTitus', $listeTitulaires);
					$smarty->assign('corpsPage','choixTitu');
					break;
				}
			}
		}

if ($acronyme != Null) {
	$prof = new user($acronyme);
	$photo = $prof->photoExiste();
	$smarty->assign('photo',$photo);
	$smarty->assign('acronyme', $acronyme);
	$smarty->assign('prof',$prof->identite());
	$smarty->assign('cours',$prof->listeCoursProf());
	$smarty->assign('titulaire', $prof->listeTitulariats());
	$smarty->assign('corpsPage','formPerso');

	}

// le sélecteur de classe (pour les titulaires) et de nom (pour tous les profs)
$smarty->assign('selecteur', 'selectTituNom');

$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display('index.tpl');
?>
