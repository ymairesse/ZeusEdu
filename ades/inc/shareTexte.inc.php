<?php

require_once("../../config.inc.php");
// définition de la class Application
require_once(INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once (INSTALL_DIR."/ades/inc/classes/classAdes.inc.php");
$Ades = new Ades();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
$User = $_SESSION[APPLICATION];

$acronyme = $User->getAcronyme();

$id = isset($_POST['id']) ? $_POST['id'] : Null;

$status = $Ades->toggleShareStatus($id, $acronyme);

echo $status;
