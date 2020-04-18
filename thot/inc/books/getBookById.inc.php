<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$module = $Application->getModule(3);
require_once (INSTALL_DIR."/$module/inc/classes/class.books.inc.php");
$Books = new Books();

// récupérer le formulaire d'encodage du livre
$idBook = isset($_POST['idBook']) ? $_POST['idBook'] : null;

// récupérer les informations depuis la BD
$book = $Books->getBookById($idBook);
$auteurs = $Books->getAuthorsByidBook($idBook);
$book['auteurs'] = $auteurs;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('book', $book);
echo $smarty->fetch('books/showBook.tpl');
