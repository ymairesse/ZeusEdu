<?php
require_once("../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classUser.inc.php');
session_start();

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/thot/inc/classes/classJdc.inc.php');
$jdc = new Jdc();

$user = @$_SESSION[APPLICATION];
if ($user == Null)
    die();

$listeCours = $user->getListeCours();
$listeClasses = $user->listeTitulariats("'G','TT','S','C','D'");
$categories = $jdc->categoriesTravaux();

$id = isset($_POST['id'])?$_POST['id']:Null;
$viewState = isset($_POST['viewState'])?$_POST['viewState']:Null;


if ($id != Null) {
    $travail = $jdc->getTravail($id);
    require_once(INSTALL_DIR."/smarty/Smarty.class.php");
    $smarty = new Smarty();
    $smarty->template_dir = "../templates";
    $smarty->compile_dir = "../templates_c";

    $smarty->assign('categories',$categories);
    $smarty->assign('listeCours',$listeCours);
    $smarty->assign('listeClasses',$listeClasses);
    $smarty->assign('viewState',$viewState);

    $smarty->assign('travail',$travail);
    $smarty->display('jdc/modalMod.tpl');
    }
