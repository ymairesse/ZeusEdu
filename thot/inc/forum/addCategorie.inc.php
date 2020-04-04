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

$idParent = isset($_POST['idParent']) ? $_POST['idParent'] : Null;
$libelle = isset($_POST['libelle']) ? $_POST['libelle'] : Null;
$userStatus = isset($_POST['userStatus']) ? $_POST['userStatus'] : Null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('idParent', $idParent);
$smarty->assign('libelle', $libelle);
$smarty->assign('userStatus', $userStatus);

$smarty->display('forum/modal/modalAddCategorie.tpl');
