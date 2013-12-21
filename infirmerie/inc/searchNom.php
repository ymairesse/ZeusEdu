<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Eleve
require_once (INSTALL_DIR."/inc/classes/classEleve.inc.php");

$fragment = isset($_GET['term'])?$_GET['term']:Null;

$listeEleves = Eleve::searchEleve2($fragment);
echo json_encode($listeEleves);
?>
