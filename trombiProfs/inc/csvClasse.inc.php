<?php
require_once ("fonctionsTrombi.inc.php");
require_once ("../../config/constantes.inc.php");
$groupe = isset($_GET['groupe'])?$_GET['groupe']:Null;
if ($groupe == Null) die();
$tableauElevesgroupe = tableauDesElevesgroupe ($groupe);
groupe2csv ($tableauElevesgroupe, $groupe);

require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign("groupe", $groupe);
$smarty->display("telechargercsv.tpl");
?>
