<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$module = $Application->getModule(3);
require_once (INSTALL_DIR."/$module/inc/classes/class.books.inc.php");
$Books = new Books();

$idAuteur = isset($_POST['idAuteur']) ? $_POST['idAuteur'] : null;
$idBook = isset($_POST['idBook']) ? $_POST['idBook'] : null;

$Books->delidBookidAuteur($idBook, $idAuteur);

$Books->delOrphanAuteurs($idAuteur);
