<?php

session_start();
require_once("../../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

$module = $Application->getModule(3);

require_once (INSTALL_DIR."/$module/inc/classes/class.books.inc.php");
$Books = new Books();

$idBook = isset($_POST['idBook']) ? $_POST['idBook'] : Null;

// nombre de livres supprimés
$nb = $Books->delBookById($idBook);
// suppression des auteurs inutiles dans la BD
$Books->delOrphanAuteurs();

echo $nb;
