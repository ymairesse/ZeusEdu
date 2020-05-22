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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new thotForum();

$infoSujet = $Forum->getInfoSujet($idCategorie, $idSujet);

$listePosts = $Forum->getPosts4subject($idCategorie, $idSujet);

// listes des posts devenus vides (Null) et qui sont terminaux dans un thread
// ils sont donc "effacçables"
$erasableList = $Forum->erasableListe($idCategorie, $idSujet);

$FBstats = $Forum->getFBstats4subject($idCategorie, $idSujet);

$likes4user = $Forum->getLikesOnSubject4user($acronyme, $idCategorie, $idSujet);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('idCategorie', $idCategorie);
$smarty->assign('idSujet', $idSujet);

$smarty->assign('listePosts', $listePosts);
$smarty->assign('erasableList', $erasableList);
$smarty->assign('infoSujet', $infoSujet);

$smarty->assign('likes4user', $likes4user);
$smarty->assign('FBstats', $FBstats);

$smarty->assign('acronyme', $acronyme);

$smarty->display('forum/treeviewPosts.tpl');
