<?php

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;

switch ($mode) {
	case 'addUser':
		// création d'un nouvel utilisateur vierge
		$nouvelUtilisateur = new User();
		$smarty->assign('user', $nouvelUtilisateur->identite());
		$smarty->assign('userDroits', $nouvelUtilisateur->getApplications());
		$smarty->assign('applications', $Application->listeApplis());
		$smarty->assign('applicationDroits', $Application->listeDroits());
		// il s'agit d'un nouvel utilisateur; on doit pouvoir définir son acronyme
		$smarty->assign('dejaConnu',false);
		$smarty->assign('mode','saveUser');
		$smarty->assign('corpsPage','formPerso');
		break;

	case 'saveUser':
		$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
		// par convention, l'acronyme est toujours en majuscules
		$acronyme = strtoupper($acronyme);
		$user = new User($acronyme);
		$erreur = $user->verifFormulairePerso($_POST);
		if ($erreur != "") die($erreur);
		// enregistrement des données personnelles
		$nbModifUser = $user->saveDataPerso($_POST);
		// enregistrement des droits sur les différentes applications actives
		$nbModifApplis = $user->saveDataApplis($_POST, $Application->listeApplis());
		$smarty->assign('acronyme',$acronyme);
		$mode = 'modifUser';
		$smarty->assign('selecteur','selectNomProf');
		$smarty->assign('message', array(
					'title'=>'Confirmation',
					'texte'=>"Applications mises à jour: $nbModifApplis,<br>profil modifié ".$nbModifUser,
					'urgence'=>'success'));
		// break;  pas de break
	case 'modifUser':
		$smarty->assign('listeProfs', $Ecole->listeProfs());
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		$smarty->assign('etape','');
		$smarty->assign('selecteur','selectNomProf');
		if (isset($acronyme)) {
			// recherche de toutes les infos sur l'utilisateur existant
			$oldUser = new User($acronyme);
			$smarty->assign('acronyme', $acronyme);
			$smarty->assign('userIdentite', $oldUser->identite());
			$smarty->assign('userApplications', $oldUser->getApplications());
			$smarty->assign('applications', $Application->listeApplis());
			$smarty->assign('applicationDroits', $Application->listeDroits());
			$smarty->assign('dejaConnu', true);
			$smarty->assign('corpsPage','formPerso');
			}

		break;
	case 'delUser':
		switch ($etape) {
			case 'confirmation':
				$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
				if (!($acronyme))
					die('missing user');
				$user = user::identiteProf($acronyme);
				$nomPrenom = $user['nom'].' '.$user['prenom'];
				$smarty->assign('acronyme',$acronyme);
				$smarty->assign('nomPrenom',$nomPrenom);
				$smarty->assign('mode',$mode);
				$smarty->assign('etape','effacement');
				$smarty->assign('corpsPage','confirmUserDel');
				break;
			case 'effacement':
				// suppression définitive de l'utilisateur
				$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;

				if (!($acronyme))
					die("missing user");
				if (!($Application->deleteUser($acronyme)))
					die("user not deleted");

				// appel de la class hermes pour le nettoyage des listes d'envoi
				require_once(INSTALL_DIR.'/hermes/inc/classes/classHermes.inc.php');
				$nb = hermes::nettoyerListes();
				$smarty->assign('message', array(
									'title'=>'Confirmation',
									'texte'=>"Utilisateur $acronyme supprimé",
									'urgence'=>'danger'));
				// break; pas de  break
			default:
				// ********************************************************************************************
				// listOprhanUsers() sans doute pas nécessaire: on peut effacer un prof de la table pfofsCours
				// sans problème d'intégrité référentielles À VÉRIFIER !!!!
				// ********************************************************************************************
				$smarty->assign('listeProfs', $Application->listOrphanUsers());
				$smarty->assign('action',$action);
				$smarty->assign('mode',$mode);
				$smarty->assign('etape','confirmation');
				$smarty->assign('selecteur','selectNomProf');
				break;
			}
		break;

	case 'affectation': // affectation en masse des utilisateurs aux applications
		$smarty->assign('usersList', $Ecole->listeProfs());
		$smarty->assign('listeApplications', $Application->listeApplis(true));
		$smarty->assign('listeDroits', $Application->listeDroits());
		$smarty->assign('corpsPage', 'affectDroits');
		break;

	case 'saveDroits': // enregistrement des droits précisés dans l'option ci-dessus
		if (isset($_POST['usersList']))
			$usersList = $_POST['usersList']; else die("no user list");
		if (isset($_POST['applications']))
			$applications = $_POST['applications']; else die("missing applications");
		if (isset($_POST['droits']))
			$droits = $_POST['droits']; else die("missing list");
		$bilan = $Application->affecteDroitsApplications($usersList, $applications, $droits);
		$nb = count($bilan);
		$smarty->assign("message", array(
			'title'=>"Modifications",
			'texte'=>"$nb droit(s) affecté(s)",
			'urgence'=>'info'));
		$smarty->assign('bilan', $bilan);
		$smarty->assign('corpsPage', 'bilanDroits');
		break;
	default:
		die();
}
?>
