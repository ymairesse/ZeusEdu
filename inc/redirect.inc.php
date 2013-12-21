<?php
require('../smarty/Smarty.class.php');
// ne fait... rien pendant le nombre de secondes demandées
$time = (isset($_GET['time'])?$_GET['time']:1);
$redir  = (isset($_GET['redir'])?$_GET['redir']:Null);
sleep($time);

$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign ("url", $redir);
$smarty->display ("redirection.tpl");
?>
