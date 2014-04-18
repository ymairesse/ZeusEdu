<?php
// récupérer l'onglet précédemment actif
$onglet = isset($_POST['onglet'])?$_POST['onglet']:0;
$smarty->assign('onglet',$onglet);

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
			$smarty->assign('classe',$classe);
			$smarty->assign('tableauEleves', $listeElevesClasse);
			$smarty->assign('corpsPage','trombinoscope');
		}
		$afficherEleve = (isset($matricule))?true:Null;
		break;
	
	case 'savePad':
		require_once(INSTALL_DIR.'/$module/inc/classes/classMemo.inc.php');
		$memoAdes = new memoAdes($matricule, 'ades');
		$nb = $memoAdes->savePadEleve($_POST);
		$smarty->assign('message', array(
				'title'=>'Enregistrement',
				'texte'=>'Note enregistrée'));
		$smarty->assign('listeClasses', $Ecole->listeGroupes());
		if (isset($classe))
			$smarty->assign('listeEleves', $Ecole->listeEleves($classe));
		$mode = 'selection';
		$smarty->assign('selecteur','selectClasseEleve');
		$afficherEleve = true;
		break;
	
	default:
		if (isset($matricule) && isset($classe)) {
			$afficherEleve = true;
		}
	}
?>