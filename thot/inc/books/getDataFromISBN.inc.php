<?php

session_start();
require_once("../../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

$module = $Application->getModule(3);

require_once (INSTALL_DIR."/$module/inc/classes/class.books.inc.php");
$Books = new Books();

$isbn = isset($_POST['isbn']) ? $_POST['isbn'] : Nuall;

$livre = $Books->getDataFromISBNGoogle($isbn);

if ($livre != Null) {
    require_once(INSTALL_DIR.'/smarty/Smarty.class.php');
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('livre', $livre);

    echo $smarty->fetch('books/modal/dataBook4modal.tpl');
}
else echo "Pas d'informations sur cet ouvrage avec l'ISBN $isbn";
