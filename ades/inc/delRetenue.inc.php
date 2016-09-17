<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

$idretenue = $_POST['idretenue'];

require_once (INSTALL_DIR."/ades/inc/classes/classRetenue.inc.php");
$Retenue = new Retenue($idretenue);
echo ($Retenue->delRetenue());
