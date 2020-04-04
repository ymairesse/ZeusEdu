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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$idCategorie = isset($form['idCategorie']) ? $form['idCategorie'] : Null;
$libelle = isset($form['modalLibelle']) ? $form['modalLibelle'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new thotForum();

$categorie = $Forum->getInfoCategorie($idCategorie);

$parentId = $categorie['parentId'];
$userStatus = $categorie['userStatus'];

// $nb est le nombre de lignes dans la table des catégories avec le même libellé
// et le même parent
$nb = $Forum->categorieAlreadyExists($parentId, $libelle, $userStatus);

// on n'a pas trouvé d'enregistrement du même libelle à ce niveau dans la BD
if ($nb == 0) {
    $idCategorie = $Forum->saveCategorie($parentId, $libelle, $userStatus, $idCategorie);
    echo $idCategorie;
    }
    else echo -1;
