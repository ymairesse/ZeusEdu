<?php

session_start();
require_once("../../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

$module = $Application->getModule(3);

require_once (INSTALL_DIR."/$module/inc/classes/class.books.inc.php");
$Books = new Books();

$query = isset($_REQUEST['query'])?$_REQUEST['query']:Null;
$champ = isset($_REQUEST['champ'])?$_REQUEST['champ']:Null;

$query = trim($query);

$liste = $Books->searchBook($query, $champ);

echo json_encode($liste);
