<?php
require_once("../config.inc.php");
include (INSTALL_DIR."/inc/entetes.inc.php");


// ----------------------------------------------------------------------------
//
// config de la BD spécifique aux e-valves
require_once("config.inc.php");
require_once("inc/classes/classE-valves.inc.php");
$Evalves = new Evalves();
$listeNews = $Evalves->getLastNews(15);
$smarty->assign("listeNews", $listeNews);
$smarty->assign("corpsPage", "lastnews");

//
// ----------------------------------------------------------------------------
$smarty->assign("executionTime", round($chrono->stop(),6));
$smarty->display ("index.tpl");
?>
