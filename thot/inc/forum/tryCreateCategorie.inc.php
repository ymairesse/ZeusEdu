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

$parentId = isset($_POST['parentId']) ? $_POST['parentId'] : Null;
// profs ou eleves
$userStatus = isset($_POST['userStatus']) ? $_POST['userStatus'] : Null;
$newCategorie = isset($_POST['newCategorie']) ? $_POST['newCategorie'] : Null;
$noeud = isset($_POST['noeud']) ? $_POST['noeud'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

// combien de catégories de ce nom existent dans la categorie $parentId (0 ou 1)
$nb = $Forum->categorieAlreadyExists($parentId, $newCategorie, $userStatus);

// s'il n'existe pas encore de catégorie de ce nom
if ($nb == 0) {
    $idCategorie = $Forum->saveCategorie($parentId, $newCategorie, $userStatus);

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('idCategorie', $idCategorie);
    $smarty->assign('userStatus', $userStatus);
    $smarty->assign('libelle', $newCategorie);
    $smarty->assign('noeud', $noeud);
    $li = $smarty->fetch('forum/modal/liUneCategorie.tpl');
    echo json_encode(array('OK' => true, 'li' => $li));
    }
    else {
        echo json_encode(array('OK' => false, 'li' => Null));
    }
