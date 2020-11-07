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

$userStatus = $User->userStatus($module);

$idCategorie = isset($_POST['idCategorie']) ? $_POST['idCategorie'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

$nbPosts = $Forum->getNbPosts4categorie($idCategorie);
$nbChildren = $Forum->getNbChildren($idCategorie);

if ($nbPosts > 0) {
    echo json_encode(array('nb' => 0, 'message' => sprintf('Il existe %d contributions pour cette catégorie. La suppression est impossible.', $nbPosts)));
    }
    else if ($nbChildren > 0) {
        echo json_encode(array('nb' => 0, 'message' => sprintf('Cette catégorie est "mère" de %d catégories. La suppression est impossible', $nbChildren)));
    }
    else {
        $nb = $Forum->delCategorie($idCategorie);
        echo json_encode(array('nb' => $nb, 'message' => sprintf('%d catégorie supprimée', $nb)));
    }
