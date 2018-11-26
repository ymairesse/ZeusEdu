<?php
require_once("../../../config.inc.php");

session_start();

$id = isset($_POST['id'])?$_POST['id']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();
$nb = $thot->delRV($id);

echo $nb;
