<?php

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(1);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classHermes.inc.php";
$hermes = new hermes();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'widgets/fileTree/inc/classes/class.Treeview.php';

$selectedFiles = array();

$Tree = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$acronyme, $selectedFiles);
$arbre = $Tree->getTree();

$listeProfs = $Hermes->listeMailingProfs();
$listeTitus = $Hermes->listeMailingTitulaires();
$listesAutres = $Hermes->listesPerso($acronyme);
$listeDirection = $Hermes->listeDirection();

$smarty->assign('NOREPLY', NOREPLY);
$smarty->assign('NOMNOREPLY', NOMNOREPLY);

$smarty->assign('listeProfs',$listeProfs);
$smarty->assign('listeTitus',$listeTitus);
$smarty->assign('listesAutres',$listesAutres);
$smarty->assign('listeDirection',$listeDirection);
$smarty->assign('tree', $arbre);

$smarty->assign('corpsPage', 'envoiMail');
