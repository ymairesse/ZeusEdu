<?php
$table = isset($_REQUEST['table'])?$_REQUEST['table']:Null;
if ($table == Null) die('missing table');
$smarty->assign('table', $table);
$smarty->assign('entete', $Application->SQLtableFields2array($table));
$smarty->assign('tableau', $Application->SQLtable2array($table));
$smarty->assign('class', 'tableauAdmin');
$smarty->assign('corpsPage', 'lookTable');
?>
