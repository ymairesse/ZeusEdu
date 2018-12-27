<?php

$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : null;
$etape = isset($_POST['etape']) ? $_POST['etape'] : null;

switch ($mode) {
    case 'addUser':
        // création d'un nouvel utilisateur vierge
        $nouvelUtilisateur = new User();
        $smarty->assign('user', $nouvelUtilisateur->identite());
        $smarty->assign('userDroits', $nouvelUtilisateur->getApplications());
        $smarty->assign('applications', $Application->listeApplis());
        $smarty->assign('applicationDroits', $Application->listeDroits());
        // il s'agit d'un nouvel utilisateur; on doit pouvoir définir son acronyme
        $smarty->assign('dejaConnu', false);
        $smarty->assign('mode', 'saveUser');
        $smarty->assign('corpsPage', 'users/formPerso');
        break;

    case 'saveUser':
        $acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : null;
        // par convention, l'acronyme est toujours en majuscules
        $acronyme = strtoupper($acronyme);
        $user = new User($acronyme);
        $erreur = $user->verifFormulairePerso($_POST);
        if ($erreur != '') {
            die($erreur);
        }
        // enregistrement des données personnelles
        $nbModifUser = $user->saveDataPerso($_POST);
        // enregistrement des droits sur les différentes applications actives
        $nbModifApplis = $user->saveDataApplis($_POST, $Application->listeApplis());
        $smarty->assign('acronyme', $acronyme);
        $mode = 'modifUser';
        $smarty->assign('selecteur', 'selectNomProf');
        $smarty->assign('message', array(
                    'title' => 'Confirmation',
                    'texte' => "Applications mises à jour: $nbModifApplis,<br>profil modifié ".$nbModifUser,
                    'urgence' => 'success', ));
        // break;  pas de break
    case 'modifUser':
        $smarty->assign('listeProfs', $Ecole->listeProfs());
        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('etape', '');
        $smarty->assign('selecteur', 'selecteurs/selectNomProf');
        if (isset($acronyme)) {
            // recherche de toutes les infos sur l'utilisateur existant
            $oldUser = new User($acronyme);
            $smarty->assign('acronyme', $acronyme);
            $smarty->assign('userIdentite', $oldUser->identite());
            $smarty->assign('userApplications', $oldUser->getApplications());
            // liste des applications actives/inactives et dans l'ordre alphabétique
            $smarty->assign('applications', $Application->listeApplis(false, true));
            $smarty->assign('applicationDroits', $Application->listeDroits());
            $smarty->assign('dejaConnu', true);
            $smarty->assign('corpsPage', 'users/formPerso');
        }

        break;
    case 'delUser':
		if ($etape == 'delete') {
			$nb = $Application->deleteUser($acronyme);
		}
        $listeProfs = $Application->listeProfsBoolCours();
        $smarty->assign('listeProfs', $listeProfs);
        $smarty->assign('corpsPage', 'users/userDel');
        break;

    case 'affectation': // affectation en masse des utilisateurs aux applications
        $smarty->assign('usersList', $Ecole->listeProfs());
        $smarty->assign('listeApplications', $Application->listeApplis(true));
        $smarty->assign('listeDroits', $Application->listeDroits());
        $smarty->assign('corpsPage', 'users/affectDroits');
        break;

    case 'saveDroits': // enregistrement des droits précisés dans l'option ci-dessus
        if (isset($_POST['usersList'])) {
            $usersList = $_POST['usersList'];
        } else {
            die('no user list');
        }
        if (isset($_POST['applications'])) {
            $applications = $_POST['applications'];
        } else {
            die('missing applications');
        }
        if (isset($_POST['droits'])) {
            $droits = $_POST['droits'];
        } else {
            die('missing list');
        }
        $bilan = $Application->affecteDroitsApplications($usersList, $applications, $droits);
        $nb = count($bilan);
        $smarty->assign('message', array(
            'title' => 'Modifications',
            'texte' => "$nb droit(s) affecté(s)",
            'urgence' => 'info', ));
        $smarty->assign('bilan', $bilan);
        $smarty->assign('corpsPage', 'users/bilanDroits');
        break;

    case 'educsClasses':
        if (isset($acronyme)) {
            $User = new User($acronyme);
            $identite =  $User->identite();
            $smarty->assign('identite', $identite);
            $smarty->assign('acronyme', $acronyme);

            $listeClasses = $Ecole->listeClasses();
            $smarty->assign('listeClasses', $listeClasses);
            $groupes = $User->getClassesEduc($acronyme);
            $smarty->assign('classes', $groupes);

            $smarty->assign('corpsPage', 'users/educsClasses');
        }

        $smarty->assign('action', $action);
        $smarty->assign('mode', $mode);
        $smarty->assign('etape', 'showUsers');
        $smarty->assign('listeProfs', $Ecole->listeProfs());
        $smarty->assign('selecteur', 'selecteurs/selectNomProf');
        break;
    default:
        die();
}
