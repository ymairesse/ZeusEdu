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

$champ = isset($_COOKIE['champ']) ? $_COOKIE['champ'] : Null;
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

require_once(INSTALL_DIR.'/smarty/Smarty.class.php');
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('champ', $champ);
$smarty->assign('critere', $critere);

echo $smarty->fetch('books/searchBar.tpl');
