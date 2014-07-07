<?php

$typeRetenue = isset($_POST['typeRetenue'])?$_POST['typeRetenue']:Null;
$smarty->assign('typeRetenue',$typeRetenue);
// $listeRetenues = isset($typeRetenue)?$Ades->listeRetenues($typeRetenue, true):Null;
// $smarty->assign('listeRetenues',$listeRetenues);
$listeTypes = $Ades->getTypesRetenues();
$smarty->assign('listeTypes',$listeTypes);
require_once(INSTALL_DIR."/ades/inc/classes/classRetenue.inc.php");

switch ($mode) {
	case 'liste':
		switch ($etape) {
			case 'showListe':
				$idretenue = isset($_POST['idretenue'])?$_POST['idretenue']:Null;
				if (isset($idretenue)) {
					$smarty->assign('action',$action);
					$smarty->assign('mode',$mode);
					$smarty->assign('etape',$etape);
					$smarty->assign('idretenue',$idretenue);
					$infosRetenue = $Ades->infosRetenue($idretenue);
					$smarty->assign('infosRetenue',$infosRetenue);
					$listeElevesRetenue = $Ades->listeElevesRetenue ($idretenue);
					$smarty->assign('listeEleves',$listeElevesRetenue);
					$smarty->assign('selecteur','selectRetenueDate');
					$smarty->assign('corpsPage','listeElevesRetenue');
				}
				break;
			default:
			$smarty->assign('action',$action);
			$smarty->assign('mode',$mode);
			$smarty->assign('etape','showListe');
			$smarty->assign('selecteur','selectRetenueDate');
			break;
		}
		
		break;
	case 'dates':
		$smarty->assign('selecteur', 'selectTypeRetenue');
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		if (isset($typeRetenue)) {
			$listeRetenues = $Ades->listeRetenues($typeRetenue, false);
			
			$smarty->assign('listeRetenues',$listeRetenues);
			$infosRetenue = $Ades->infosRetenueType($typeRetenue);
			$smarty->assign('infosRetenue', $infosRetenue);
			$smarty->assign('corpsPage','listesRetenues');
		}
		break;
	case 'edit':
		$idretenue = isset($_REQUEST['idretenue'])?$_REQUEST['idretenue']:Null;
		$retenue = new Retenue($idretenue);
		$typeRetenue = $retenue->get('type');
		$smarty->assign('typeRetenue', $typeRetenue);
		$smarty->assign('idretenue',$idretenue);
		$smarty->assign('retenue', $retenue);
		$smarty->assign('action',$action);
		$smarty->assign('corpsPage','editRetenue');
		break; 
	case 'Enregistrer':
		$Retenue = new Retenue();
		$idretenue = $Retenue->saveRetenue($_POST);
		$smarty->assign("message", array(
					'title'=>"Enregistrement",
					'texte'=>"Retenue enregistrée")
					);
		// relire dans la BD
		$Retenue->lireRetenue($idretenue);
		$typeRetenue = $Retenue->get('type');
		// après enregistrement, relire la table pour avoir toutes les retenues, y compris la dernière enregistrée
		if (isset($typeRetenue)) {
			// $listeRetenues = $Ades->listeRetenues($typeRetenue, false);
			$listeRetenues = $Ades->listeRetenues($typeRetenue);
			$smarty->assign('listeRetenues',$listeRetenues);
			$smarty->assign('type',$typeRetenue);
			$infosRetenue = $Ades->infosRetenueType($typeRetenue);
			$smarty->assign('infosRetenue', $infosRetenue);
			$smarty->assign('corpsPage','listesRetenues');
		}
		$smarty->assign('selecteur', 'selectTypeRetenue');
		$smarty->assign('action',$action);
		$smarty->assign('mode','dates');
		break;
	case 'del':
		$idretenue = isset($_REQUEST['idretenue'])?$_REQUEST['idretenue']:Null;
		$Retenue = new Retenue($idretenue);
		$typeRetenue = $Retenue->get('type');
		$smarty->assign('typeRetenue',$typeRetenue);
		$nb = $Retenue->delRetenue();
		$smarty->assign("message", array(
			'title'=>"Enregistrement",
			'texte'=>"Retenue supprimée")
			);
		$smarty->assign('action',$action);
		$smarty->assign('mode','dates');
		$smarty->assign('selecteur', 'selectTypeRetenue');
		// après effacement, relire la table pour avoir toutes les retenues, sans le dernière supprimée
		$listeRetenues = $Ades->listeRetenues($typeRetenue, false);
		$smarty->assign('listeRetenues',$listeRetenues);
		$infosRetenue = $Ades->infosRetenueType($typeRetenue);
		$smarty->assign('infosRetenue', $infosRetenue);
		$smarty->assign('corpsPage','listesRetenues');
		break;
	default:
		// wtf
		break;
	
	}

?>