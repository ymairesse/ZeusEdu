<?php

require_once '../../../config.inc.php';

// définition de la class Application
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

$idCategorie = isset($_GET['idCategorie']) ? $_GET['idCategorie'] : Null;
$idSujet = isset($_GET['idSujet']) ? $_GET['idSujet'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new thotForum();

// VÉ&RIFIER LA PROPRIÉTÉ DU SUJET

$infoSujet = $Forum->getInfoSujet($idCategorie, $idSujet);
$listePosts = $Forum->getPosts4subject($idCategorie, $idSujet, false);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';


$smarty->assign('acronyme', $acronyme);
$smarty->assign('infoSujet', $infoSujet);
$smarty->assign('listePosts', $listePosts);

$forum = $smarty->fetch('forum/treeviewPosts4PDF.tpl');
$forum = strip_tags($forum, '<h1><h2><h3><br><p><a><style>');
echo $forum;

// suppression des <iframe> (vidéos,...)
// $forum = preg_replace( '@<iframe[^>]*?>.*?</iframe>@siu', ' ### élément non imprimable ### ', $forum );
// $forum = preg_replace( '@<strike[^>]*?>.*?</strike>@siu', '<span style="text-decoration:line-through">texte barré</span> ', $forum );
// $forum = preg_replace( '@<font[^>]*?>.*?</font>@siu', '', $forum );
//
//
// $html2pdf->WriteHTML($forum);
//
// $html2pdf->Output('fiche'.$infoSujet['sujet'].'.pdf');
