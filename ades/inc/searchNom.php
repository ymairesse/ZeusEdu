<?php

session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once (INSTALL_DIR."/inc/classes/classEleve.inc.php");

$fragment = isset($_REQUEST['query'])?$_REQUEST['query']:Null;

$fragment = trim($fragment);

$listeEleves = Eleve::searchEleve2($fragment);

echo json_encode($listeEleves);
