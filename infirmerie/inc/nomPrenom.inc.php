<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Ecole
require_once (INSTALL_DIR."/inc/classes/classEcole.inc.php");
$Ecole = new Ecole();

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
if ($acronyme == Null) die();

$nomPrenom = $Ecole->abr2name($acronyme);
echo "<strong>$nomPrenom</strong>";

?>
