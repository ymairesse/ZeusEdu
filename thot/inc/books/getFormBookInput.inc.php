<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);
require_once (INSTALL_DIR."/$module/inc/classes/class.books.inc.php");
$Books = new Books();

$idBook = isset($_POST['idBook']) ? $_POST['idBook'] : Null;
$mode = isset($_POST['mode']) ? $_POST['mode'] : Null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

if ($idBook != Null) {
    $book = $Books->getBookById($idBook);
    $smarty->assign('book', $book);
}

$smarty->assign('mode', $mode);
echo $smarty->fetch('books/formBookInput.tpl');
