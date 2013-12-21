<?php
$type = isset($_POST['type'])?$_POST['type']:Null;
$smarty->assign('type',$type);
$listeRetenues = isset($type)?$Ades->listeRetenues($type, true):Null;
$smarty->assign('listeRetenues',$listeRetenues);
$listeTypes = $Ades->getTypesRetenues();
$smarty->assign('listeTypes',$listeTypes);
require_once(INSTALL_DIR."/ades/inc/classes/classRetenue.inc.php");

switch ($mode) {
	case 'liste':
		switch ($etape) {
			case 'showListe':
				$retenue = isset($_POST['retenue'])?$_POST['retenue']:Null;
				if (isset($retenue)) {
					$smarty->assign('action',$action);
					$smarty->assign('mode',$mode);
					$smarty->assign('etape',$etape);
					$smarty->assign('retenue',$retenue);
					$infosRetenue = $Ades->infosRetenue($retenue);
					$smarty->assign('infosRetenue',$infosRetenue);
					$listeElevesRetenue = $Ades->listeElevesRetenue ($retenue);
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
		if (isset($type)) {
			$listeRetenues = $Ades->listeRetenues($type, false);
			$smarty->assign('listeRetenues',$listeRetenues);
			$infosRetenue = $Ades->infosRetenueType($type);
			$smarty->assign('infosRetenue', $infosRetenue);
			$smarty->assign('corpsPage','listesRetenues');
		}
		break;
	case 'edit':
		$idretenue = isset($_REQUEST['idretenue'])?$_REQUEST['idretenue']:Null;
		$retenue = new Retenue($idretenue);
		$type = $retenue->get('type');
		$smarty->assign('type', $type);
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
		$smarty->assign('action',$action);
		$smarty->assign('mode','liste');
		$type = $Retenue->get('type');
		$smarty->assign('selecteur', 'selectTypeRetenue');
		$smarty->assign('action',$action);
		$smarty->assign('mode','dates');
		if (isset($type)) {
			$listeRetenues = $Ades->listeRetenues($type, false);
			$smarty->assign('type',$type);
			$smarty->assign('listeRetenues',$listeRetenues);
			$infosRetenue = $Ades->infosRetenueType($type);
			$smarty->assign('infosRetenue', $infosRetenue);
			$smarty->assign('corpsPage','listesRetenues');
		}
		break;
	case 'del':
		$idretenue = isset($_REQUEST['idretenue'])?$_REQUEST['idretenue']:Null;
		$Retenue = new Retenue($idretenue);
		$type = $Retenue->get('type');
		$smarty->assign('type',$type);
		$nb = $Retenue->delRetenue();
		$smarty->assign("message", array(
			'title'=>"Enregistrement",
			'texte'=>"Retenue supprimée")
			);
		$smarty->assign('selecteur', 'selectTypeRetenue');
		$listeRetenues = $Ades->listeRetenues($type, false);
		$smarty->assign('listeRetenues',$listeRetenues);
		$infosRetenue = $Ades->infosRetenueType($type);
		$smarty->assign('infosRetenue', $infosRetenue);
		$smarty->assign('corpsPage','listesRetenues');
		break;
	default:
		// wtf
		break;
	
	}

?>