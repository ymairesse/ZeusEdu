<?php
session_start();
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../inc/fonctions.inc.php");
require_once ("../../config/constantes.inc.php");

Normalisation;

$identite = $_SESSION['identite'];

require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("identite", $identite);
$smarty->display("formPerso.tpl");

?>
