<?php
$table = isset($_REQUEST['table'])?$_REQUEST['table']:Null;
if ($table == Null) 
	die("missing table");
switch ($mode) {
	case 'Confirmer':
		clearTable($table);
		$smarty->assign("table", $table);
		$smarty->assign("corpsPage","confirmClear");
		break;
	default:
		$smarty->assign("table", $table);
		$smarty->assign("entete", $Application->SQLtableFields2array($table));
		$smarty->assign("tableau", $Application->SQLtable2array($table));
		$smarty->assign("class", "tableauAdmin");
		$smarty->assign("corpsPage","formulaireVider");
		break;	
}
?>
