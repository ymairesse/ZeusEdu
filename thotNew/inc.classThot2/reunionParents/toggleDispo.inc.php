<?php

require_once("../../../config.inc.php");

session_start();

$id = isset($_POST['id'])?$_POST['id']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/inc/classes/classThot2.inc.php');
$thot = new Thot();
$dispo = $thot->toggleDispo($id);

echo $dispo;
