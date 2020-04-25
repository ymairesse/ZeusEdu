<?php
require_once("../../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classUser.inc.php');
session_start();

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'/thot/inc/classes/classJdc.inc.php');
$jdc = new Jdc();

$user = @$_SESSION[APPLICATION];
if ($user == Null)
    die();

$acronyme = $user->getAcronyme();

$event_id = isset($_POST['event_id'])?$_POST['event_id']:Null;

if ($event_id != Null) {
    $travail = $jdc->getTravail($event_id);
    require_once(INSTALL_DIR."/smarty/Smarty.class.php");
    $smarty = new Smarty();
    $smarty->template_dir = "../../templates";
    $smarty->compile_dir = "../../templates_c";
    $smarty->assign('travail',$travail);
    $smarty->assign('acronyme',$acronyme);
    $smarty->display('detailSuivi/unTravail.tpl');
    }
    else {
        $date = $Application->now();
    }
