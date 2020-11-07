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
$newLibelle = isset($_POST['name']) ? $_POST['name'] : Null;
// profs ou eleves ?
$userStatus = isset($_POST['userStatus']) ? $_POST['userStatus'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

$parentId = $Forum->getParent4categorie($idCategorie);

// combien de catégories de ce nom existent dans la categorie $parentId (0 ou 1)
$nb = $Forum->categorieAlreadyExists($parentId, $newLibelle, $userStatus);

if ($nb == 0)
    $resultat = $Forum->updateCategorie($idCategorie, $newLibelle) ;
    else $resultat = 0;

echo $resultat;
