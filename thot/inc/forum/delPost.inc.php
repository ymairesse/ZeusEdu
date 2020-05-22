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

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

$idCategorie = isset($form['idCategorie']) ? $form['idCategorie'] : Null;
$idSujet = isset($form['idSujet']) ? $form['idSujet'] : Null;
$postId = isset($form['postId']) ? $form['postId'] : Null;

// définition de la class Forum
$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

$okProprio = $Forum->verifAuteur($acronyme, $postId, $idSujet, $idCategorie);
$hasChildren = $Forum->hasChildren($idCategorie, $idSujet, $postId);

if ($okProprio) {
    if ($hasChildren == 1) {
        $nb = $Forum->clearPost($acronyme, $postId, $idSujet, $idCategorie);
        echo 1;
        }
        else {
            $nb = $Forum->delPost($acronyme, $postId, $idSujet, $idCategorie);
            echo 0;
        }
}
else echo "Vous n'êtes par l'auteur de ce post";
