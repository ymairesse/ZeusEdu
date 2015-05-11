<?php
require_once('../config.inc.php');
include (INSTALL_DIR.'/inc/entetes.inc.php');

// ----------------------------------------------------------------------------
//

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$identite = $user->identite();
$acronyme = $user->getAcronyme();
$smarty->assign('identite',$identite);

switch ($action) {
	case 'perso':
		switch ($mode) {
			case 'Enregistrer':
				$nbModif = $user->saveDataPerso($_POST);
				$smarty->assign('identite', $user->identite(true));
				$smarty->assign('logins', $user->getLogins());
				$photo = $user->photoExiste()?$acronyme:Null;
				$smarty->assign('photo',$photo);
				$smarty->assign('message', array(
						'title'=>SAVE,
						'texte'=>"$nbModif ".MODIFRECORDS,
						'urgence'=>'success'));
				$smarty->assign('corpsPage','fichePerso');
				break;
			default:
				$photo = $user->photoExiste()?$acronyme:Null;
				$smarty->assign('mode','Enregistrer');
				$smarty->assign('photo',$photo);
				$smarty->assign('corpsPage','formPerso');
				break;
			}
		break;
	case 'photo':
		switch ($mode) {
			case 'confirmer':
				// la vérification de l'upload se fait sur la variable globale $_FILES
				$erreur = uploadFile($_FILES, $acronyme);
				if ($erreur != '')
					$message = array('title'=>ERROR,'texte'=>$erreur,'urgence'=>'danger');
					else $message = array('title'=>SAVE,'texte'=>RECORDOK,'urgence'=>'info');
				$smarty->assign('identite', $user->identite(true));
				$smarty->assign('logins', $user->getLogins());
				$photo = $user->photoExiste()?$acronyme:Null;
				$smarty->assign('photo',$photo);
				$smarty->assign('message',$message);
				$smarty->assign('corpsPage','fichePerso');
				break;
			default:
				$photo = $user->photoExiste()?$acronyme:Null;
				if ($photo == Null) {
					$user = $user->identite();
					$sexe = $user['sexe'];
					if ($sexe == 'F')
						$photo = '../images/profFeminin';
						else $photo = '../images/profMasculin';
					}
				$smarty->assign('MAXIMAGESIZE', MAXIMAGESIZE);
				$smarty->assign('photo',$photo);
				$smarty->assign('corpsPage','uploadImage');
				break;
			}
		break;
	case 'mdp':
		switch ($mode) {
			case 'modifier':
				$nbModif = $user->savePwd($_POST);
				$smarty->assign('message', $message);
				$smarty->assign('logins', $user->getLogins());
				$smarty->assign('corpsPage','fichePerso');
				$smarty->assign('message', array(
					'title'=>'Confirmation',
					'texte'=>'Mot de passe modifié',
					'urgence'=>'success'));
				break;
			default:
				$smarty->assign('corpsPage','mdp');
				break;
			}

		break;
	default:
		$photo = $user->photoExiste()?$acronyme:Null;
		$smarty->assign('photo',$photo);
		$smarty->assign('logins',$Application->lastAccess(0, 40, $acronyme));
		$smarty->assign('corpsPage','fichePerso');
		break;
	}

//
// ----------------------------------------------------------------------------

$smarty->assign('executionTime', round($chrono->stop(),6));
$smarty->display('index.tpl');
?>
