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

$idCategorie = isset($_POST['idCategorie']) ? $_POST['idCategorie'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new thotForum();

$categorie = $Forum->getInfoCategorie($idCategorie);

if ($categorie != Null) {
    $libelle = $categorie['libelle'];
    $userStatus = $categorie['userStatus'];

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('idCategorie', $idCategorie);
    $smarty->assign('userStatus', $userStatus);
    $smarty->assign('libelle', $libelle);

    $smarty->display('forum/modal/modalEditCategorie.tpl');
}
