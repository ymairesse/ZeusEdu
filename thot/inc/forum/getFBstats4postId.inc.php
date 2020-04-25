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

$idCategorie = isset($_POST['idCategorie']) ? $_POST['idCategorie'] : Null;
$idSujet = isset($_POST['idSujet']) ? $_POST['idSujet'] : Null;
$postId = isset($_POST['postId']) ? $_POST['postId'] : Null;

$ds = DIRECTORY_SEPARATOR;

// définition de la class Forum
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new ThotForum();

$stats = $Forum->getFBstats4postId($idCategorie, $idSujet, $postId);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('stats', $stats);
$smarty->assign('postId', $postId);
$smarty->assign('single', 'single');

$smarty->display('forum/singleLikeType.tpl');
