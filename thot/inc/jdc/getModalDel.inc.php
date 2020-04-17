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

require_once INSTALL_DIR."/$module/inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$id = isset($_POST['id'])?$_POST['id']:Null;

if ($id != Null) {
    if ($id != $Jdc->verifIdProprio($id, $acronyme))
        die('Cette note au JDC ne vous appartient pas');

    $noteJdc = $Jdc->getTravail($id);
    $pjFiles = $Jdc->getPJ($id);

    $startDate = $noteJdc['startDate'];
    $destinataire = $noteJdc['destinataire'];
    $type = $noteJdc['type'];

    $coursGrp = ($type == 'cours') ? $noteJdc['destinataire'] : Null;
    $classe = ($type == 'classe') ? $noteJdc['destinataire'] : Null;

    require_once(INSTALL_DIR."/smarty/Smarty.class.php");
    $smarty = new Smarty();
    $smarty->template_dir = "../../templates";
    $smarty->compile_dir = "../../templates_c";

    $smarty->assign('travail',$noteJdc);
    $smarty->assign('startDate',$startDate);
    $smarty->assign('destinataire',$destinataire);
    $smarty->assign('type',$type);
    $smarty->assign('coursGrp',$coursGrp);
    $smarty->assign('classe',$classe);
    $smarty->assign('pjFiles', $pjFiles);
    $smarty->display('jdc/modal/modalDel.tpl');
    }
