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

$unAn = time() + 365 * 24 * 3600;
if (isset($_POST['champ'])) {
    $champ = $_POST['champ'];
    setcookie('champ', $champ, $unAn, null, null, false, true);
} else {
        $champ = (isset($_COOKIE['champ'])) ? $_COOKIE['champ'] : null;
    }

$query = isset($_POST['query']) ? $_POST['query'] : null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$criteres = array(
        'nom'=>'Auteur',
        'titre'=>'Titre',
        'editeur'=>'Éditeur',
        'annee' => 'Année',
        'lieu' => 'Lieu',
        'collection' => 'Collection',
        'isbn' => 'ISBN',
        'cdu' => 'CDU');
$critere = $criteres[$champ];

$smarty->assign('champ', $champ);
$smarty->assign('critere', $critere);

$module = $Application->getModule(3);
require_once (INSTALL_DIR."/$module/inc/classes/class.books.inc.php");
$Books = new Books();

// récupérer la liste des ouvrages correspondants
$bookList = $Books->getBookList($query, $champ);

// s'il n'y a qu'un seul livre correspondant au critère, on affiche
// immédiatement le formulaire d'édition
if (count($bookList) == 1) {
    $idBook = current($bookList)['idBook'];
    $book = $Books->getBookById($idBook);
    $smarty->assign('book', $book);
    $smarty->assign('mode', 'edit');
    echo $smarty->fetch('books/formBookInput.tpl');
}
// sinon, on affiche la liste des livres correspondants
else {
    $smarty->assign('bookList', $bookList);
    echo $smarty->fetch('books/bookList.tpl');
}
