<?php
$typeRetenue = isset($_POST['typeRetenue'])?$_POST['typeRetenue']:Null;
$smarty->assign('typeRetenue',$typeRetenue);
$listeTypes = $Ades->getTypesRetenues();
$smarty->assign('listeTypes',$listeTypes);

require_once(INSTALL_DIR."/ades/inc/classes/classRetenue.inc.php");

switch ($mode) {
	case 'liste':
		switch ($etape) {
			case 'showListe':
				$idretenue = isset($_POST['idretenue'])?$_POST['idretenue']:Null;
				if (isset($idretenue)) {
					$smarty->assign('etape',$etape);
					$smarty->assign('idretenue',$idretenue);
					$listeRetenues = $Ades->listeRetenues($typeRetenue, true);

					$smarty->assign('listeRetenues',$listeRetenues);
					$infosRetenue = $Ades->infosRetenue($idretenue);
					$smarty->assign('infosRetenue',$infosRetenue);
					$listeElevesRetenue = $Ades->listeElevesRetenue($idretenue);
					$smarty->assign('listeEleves',$listeElevesRetenue);
					$smarty->assign('selecteur','selectRetenueDate');
					$smarty->assign('corpsPage','listeElevesRetenue');
				}
				break;
			default:
				$smarty->assign('etape','showListe');
				$smarty->assign('selecteur','selectRetenueDate');
				break;
		}
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);		
		break;
	case 'dates':
		$smarty->assign('selecteur','selectTypeRetenue');
		if (isset($typeRetenue)) {
			$listeRetenues = $Ades->listeRetenues($typeRetenue, false);
			$smarty->assign('listeRetenues',$listeRetenues);
			$infosRetenue = $Ades->infosRetenueType($typeRetenue);
			$smarty->assign('infosRetenue',$infosRetenue);
			$smarty->assign('corpsPage','listesRetenues');
			}
		$smarty->assign('action',$action);
		$smarty->assign('mode',$mode);
		break;
	case 'edit':
		$typeRetenue = isset($_REQUEST['typeRetenue'])?$_REQUEST['typeRetenue']:Null;
		$idretenue = isset($_REQUEST['idretenue'])?$_REQUEST['idretenue']:Null;
		$retenue = current((array) new Retenue($idretenue));
		$smarty->assign('idretenue',$idretenue);
		$smarty->assign('typeRetenue',$typeRetenue);
		$smarty->assign('retenue',$retenue);
		$smarty->assign('action',$action);
		$smarty->assign('corpsPage','editRetenue');
		break; 
	case 'Enregistrer':
		$Retenue = new Retenue();
		$idretenue = $Retenue->saveRetenue($_POST);
		$smarty->assign("message", array(
					'title'=>"Enregistrement",
					'texte'=>"Retenue enregistrée",
					'urgence'=>'success'
					)
					);
		// relire dans la BD
		$Retenue->lireRetenue($idretenue);
		$typeRetenue = $Retenue->get('type');
		// après enregistrement, relire la table pour avoir toutes les retenues, y compris la dernière enregistrée
		if (isset($typeRetenue)) {
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
	default:
		// wtf
		break;
	}
?>
