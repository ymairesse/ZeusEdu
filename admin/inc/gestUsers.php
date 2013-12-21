<?php
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$etape = isset($_POST['etape'])?$_POST['etape']:Null;
$smarty->assign("listeProfs", $Ecole->listeProfs());

switch ($mode) {
	case 'addUser':
		// création d'un nouvel utilisateur vierge
		$nouvelUtilisateur = new User();
		$smarty->assign("user", $nouvelUtilisateur->identite());
		$smarty->assign("userDroits", $nouvelUtilisateur->getApplications());
		$smarty->assign("applications", $Application->listeApplis());
		$smarty->assign("applicationDroits", $Application->listeDroits());
		// il s'agit d'un nouvel utilisateur; on doit pouvoir définir son acronyme
		$smarty->assign("dejaConnu",false);
		$smarty->assign("mode","saveUser");
		$smarty->assign("corpsPage","formPerso");
		break;
	/* case 'selectUser':
		$smarty->assign("mode", "modifUser");
		$smarty->assign("selecteur","selectNomProf");
		if (!$acronyme) break;
		// sinon, on continue
		*/

	case 'saveUser':
		$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
		$user = new User($acronyme);
		$erreur = $user->verifFormulairePerso($_POST);
		if ($erreur != "") die($erreur);
		// enregistrement des données personnelles
		$nbModifUser = $user->saveDataPerso($_POST);
		// enregistrement des droits sur les différentes applications actives
		$nbModifApplis = $user->saveDataApplis($_POST, $Application->listeApplis());
		$smarty->assign("acronyme",$acronyme);
		$smarty->assign("mode", "modifUser");
		$smarty->assign("selecteur","selectNomProf");
		$smarty->assign("message", array(
					'title'=>"Confirmation",
					'texte'=>"Applications mises à jour: $nbModifApplis,<br>profil modifié ".$nbModifUser/2),
				3000);
		// break;  pas de break
	case 'modifUser':
		if ($acronyme) {
			// recherche de toutes les infos sur l'utilisateur existant
			$oldUser = new User($acronyme);
			$smarty->assign("acronyme", $acronyme);
			$smarty->assign("userIdentite", $oldUser->identite());
			$smarty->assign("userApplications", $oldUser->getApplications());
			$smarty->assign("applications", $Application->listeApplis());
			$smarty->assign("applicationDroits", $Application->listeDroits());
			$smarty->assign("dejaConnu", true);
			$smarty->assign("action", "gestUsers");
			$smarty->assign("etape",'');
			$smarty->assign("mode","modifUser");
			$smarty->assign("selecteur","selectNomProf");
			$smarty->assign("corpsPage","formPerso");
			}
			else {
				$smarty->assign("action", "gestUsers");
				$smarty->assign("mode", "modifUser");
				$smarty->assign("etape",'');
				$smarty->assign("selecteur","selectNomProf");
				}
		break;
	case 'delUser':
		switch ($etape) {
			case 'confirmation':
				$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
				if (!($acronyme))
					die("missing user");
				$user = $user->oldUser($acronyme,$Application);
				$nomPrenom = $user['nom']." ".$user['prenom'];
				$smarty->assign("acronyme", $acronyme);
				$smarty->assign("nomPrenom", $nomPrenom);
				$smarty->assign("mode", "delUser");
				$smarty->assign("etape","effacement");
				$smarty->assign("corpsPage", "confirmUserDel");		
				break;
			case 'effacement':
				// suppression définitive de l'utilisateur
				$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
				if (!($acronyme))
					die("missing user");
				if (!($Application->deleteUser($acronyme)))
					die("user not deleted");
				$smarty->assign("message", array(
									'title'=>"Confirmation",
									'texte'=>"Utilisateur $acronyme supprimé"),
								3000);
				break;
			default:
				$smarty->assign("listeProfs", $Application->listOrphanUsers());
				$smarty->assign("action", "gestUsers");
				$smarty->assign("mode", "delUser");
				$smarty->assign("etape", "confirmation");
				$smarty->assign("selecteur","selectNomProf");
				break;				
			}
		break;
	case 'affectation': // affectation en masse des utilisateurs aux applications
		$smarty->assign("usersList", $Ecole->listeProfs());
		$smarty->assign("listeApplications", $Application->listeApplis(true));
		$smarty->assign("listeDroits", $Application->listeDroits());
		$smarty->assign("corpsPage", "affectDroits");
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
			'texte'=>"$nb droit(s) affecté(s)"),
		3000);
		$smarty->assign("bilan", $bilan);
		$smarty->assign("corpsPage", "bilanDroits");
		break;
	default:
		die();
}
?>
