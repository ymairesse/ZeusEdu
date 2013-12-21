<?php
// session_start();
require_once("../../config.inc.php");
// définition de la class APPLICATION
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class USER
require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");
$user = new User();

$acronyme = $_GET['acronyme'];
echo ($user->userExists($acronyme));

?>
