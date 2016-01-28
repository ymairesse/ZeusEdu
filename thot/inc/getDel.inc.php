<?php

// session_start();
require_once("../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/thot/inc/classes/classJdc.inc.php');
$jdc = new Jdc();

$id = isset($_POST['id'])?$_POST['id']:Null;
$startDate = isset($_POST['startDate'])?$_POST['startDate']:Null;
$viewState = isset($_POST['viewState'])?$_POST['viewState']:Null;
$destinataire = isset($_POST['destinataire'])?$_POST['destinataire']:Null;
$type = isset($_POST['type'])?$_POST['type']:Null;

if ($id != Null) {
    $travail = $jdc->getTravail($id);
    require_once(INSTALL_DIR."/smarty/Smarty.class.php");
    $smarty = new Smarty();
    $smarty->template_dir = "../templates";
    $smarty->compile_dir = "../templates_c";
    $smarty->assign('travail',$travail);
    $smarty->assign('startDate',$startDate);
    $smarty->assign('viewState',$viewState);
    $smarty->assign('destinataire',$destinataire);
    $smarty->assign('type',$type);
    $smarty->display('jdc/modalDel.tpl');
    }
