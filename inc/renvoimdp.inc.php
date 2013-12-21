<?php
require_once("../config.inc.php");
// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

$acronyme = strtoupper(isset($_GET['acronyme'])?$_GET['acronyme']:Null);
$Application->renvoiMdp($acronyme);

?>
