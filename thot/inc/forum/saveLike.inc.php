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

// $controlId est l'identifiant unique du post qui est liké
// il est formé de l'idCategorie, idSujet et postId séparés par un ":"
$controlId = isset($_POST['control_id']) ? $_POST['control_id'] : Null;
$controlIdArray = explode(':', $controlId);

$idCategorie = (int)$controlIdArray[0];
$idSujet = (int)$controlIdArray[1];
$postId = (int)$controlIdArray[2];

$emoji = isset($_POST['value']) ? $_POST['value'] : Null;

$ds = DIRECTORY_SEPARATOR;

// définition de la class Forum
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

if ($emoji != 'null') {
    $nb = $Forum->saveLike($idCategorie, $idSujet, $postId, $acronyme, $emoji);
    }
    else {
        $nb = $Forum->delLike($idCategorie, $idSujet, $postId, $acronyme);
    }

echo json_encode(array(
    'idCategorie' => $idCategorie,
    'idSujet' => $idSujet,
    'postId' => $postId,
    'emoji' => $emoji
    )
);
