<?php

$smarty->assign('action',$action);
$smarty->assign('mode',$mode);

$table = isset($_REQUEST['table'])?$_REQUEST['table']:Null;
if ($table == Null) 
	die("missing table");
switch ($mode) {
	case 'Confirmer':
		Application::clearTable($table);
		$smarty->assign('message',array(
				'title'=>DELETE,
				'texte'=>"La table <strong>{$table}</strong> a été vidée",
				'urgence'=>'warning'));
		break;
	default:
		$smarty->assign('table', $table);
		$smarty->assign('entete', $Application->SQLtableFields2array($table));
		$smarty->assign('tableau', $Application->SQLtable2array($table));
		$smarty->assign('corpsPage','formulaireVider');
		break;	
}
?>
