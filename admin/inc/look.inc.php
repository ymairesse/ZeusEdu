<?php
$smarty->assign("table", $table);
$smarty->assign("entete", SQLtableFields2array($table));
$smarty->assign("tableau", SQLtable2array($table));
$smarty->assign("class", "tableauAdmin");
$smarty->display("lookTable.tpl");
	
?>
