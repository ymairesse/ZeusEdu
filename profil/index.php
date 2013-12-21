<?php
require_once("../config.inc.php");
include (INSTALL_DIR.'/inc/entetes.inc.php');

// ----------------------------------------------------------------------------
//
$identite = $user->identite();
$acronyme = $user->getAcronyme();
$smarty->assign("identite",$identite);

switch ($action) {
	case 'perso':
		switch ($mode) {
			case 'Enregistrer':
				$nbModif = $user->saveDataPerso($_POST);
				$smarty->assign("identite", $user->identite(true));
				$smarty->assign("logins", $user->getLogins());
				$message = array('title'=>SAVE,'texte'=>"$nbModif ".MODIFRECORDS,'icon'=>'info');
				$photo = $user->photoExiste()?$acronyme:Null;
				$smarty->assign("photo",$photo);
				$smarty->assign("message", $message);
				$smarty->assign("corpsPage","fichePerso");
				break;
			default:
				$photo = $user->photoExiste()?$acronyme:Null;
				$smarty->assign("photo",$photo);
				$smarty->assign("corpsPage","formPerso");			
				break;
			}
		break;
	case 'photo':
		switch ($mode) {
			case 'confirmer':
				// la vérification de l'upload se fait sur la variable globale $_FILES
				$erreur = uploadFile($_FILES, $acronyme);
				if ($erreur != '')
					$message = array('title'=>ERROR,'texte'=>$erreur,'icon'=>'attention');
					else $message = array('title'=>SAVE,'texte'=>RECORDOK,'icon'=>'info');
				$smarty->assign("identite", $user->identite(true));
				$smarty->assign("logins", $user->getLogins());
				$photo = $user->photoExiste()?$acronyme:Null;
				$smarty->assign("photo",$photo);
				$smarty->assign("message",$message);
				$smarty->assign("corpsPage","fichePerso");
				break;
			default:
				$smarty->assign("MAXIMAGESIZE", MAXIMAGESIZE);
				$smarty->assign("photo",$acronyme);
				$smarty->assign("corpsPage","uploadImage");
				break;
			}
		break;
	case 'mdp':
		switch ($mode) {
			case 'Modifier':
				$nbModif = $user->savePwd($_POST);
				$message = array('title'=>SAVE,'texte'=>"$nbModif ".MODIFRECORDS,'icon'=>'info');
				$smarty->assign("message", $message);
				$smarty->assign("logins", $user->getLogins());				
				$smarty->assign("corpsPage","fichePerso");
				$smarty->assign("message", array(
					'title'=>"Confirmation",
					'texte'=>"Mot de passe modifié"),
					3000);
				break;
			default:
				$smarty->assign("corpsPage","mdp");
				break;
			}
	
		break;
	default:
		$photo = $user->photoExiste()?$acronyme:Null;
		$smarty->assign("photo",$photo);
		$smarty->assign("logins",$Application->lastAccess (0, 40, $acronyme));
		// $smarty->assign("logins", $user->getLogins());
		$smarty->assign("corpsPage","fichePerso");
		break;
	}

//
// ----------------------------------------------------------------------------

$smarty->assign("executionTime",round($Application->chrono()-$debut,6));
$smarty->display("index.tpl");
?>
