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

// récupérer le formulaire d'encodage du livre
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

// enregistrer les informations du livre et revenir avec le $idBook de la BD
$idBook = $Books->saveBook($form);

// établir la liste de tous les auteurs provenant des deux champs (auteur et auteurs)
$auteurs = isset($form['auteurs']) ? $form['auteurs'] : Null;
$auteur = isset($form['auteur']) ? $form['auteur'] : Null;

$lesAuteurs = array();
if ($auteur != null)
    array_push($lesAuteurs, $auteur);
if ($auteurs != Null) {
    foreach ($auteurs as $wtf => $auteur) {
        array_push($lesAuteurs, $auteur);
    }
}

// enregistrement de la liste des auteurs pour le livre $idBook
$nbAuteurs = 0;

foreach ($lesAuteurs as $wtf => $nomAuteur) {
    $idAuteur = $Books->saveAuteur($nomAuteur);
    $nbAuteurs += $Books->saveidAuteuridBook($idAuteur, $idBook);
    }

// récupérer les données enregistrées
$book = $Books->getBookById($idBook);
// y compris les auteurs de l'ouvrage
$auteurs = $Books->getAuthorsByidBook($idBook);
$book['auteurs'] = $auteurs;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('mode', 'edit');
$smarty->assign('book', $book);

echo $smarty->fetch('books/formBookInput.tpl');
