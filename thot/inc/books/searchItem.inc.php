<?php

/* Recherche d'un livre en BD correspondant à un certain critère (texte dans un champ) */

$query = isset($_POST['query'])?$_POST['query']:Null;
$champ = isset($_POST['champ'])?$_POST['champ']:Null;
$minLength = isset($_POST['minLength'])?$_POST['minLength']:Null;

if (strlen($query) < $minLength)
    die();

session_start();
require_once("../../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

$module = $Application->getModule(3);

require_once (INSTALL_DIR."/$module/inc/classes/class.books.inc.php");
$Books = new Books();

$query = trim($query);

$liste = $Books->searchBook($query, $champ);

echo json_encode($liste);
