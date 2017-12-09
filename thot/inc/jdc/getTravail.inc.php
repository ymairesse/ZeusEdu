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
$jdc = new Jdc();

$id = isset($_POST['id']) ? $_POST['id'] : null;
$editable = isset($_POST['editable']) ? $_POST['editable'] : null;

if ($id != null) {
    $travail = $jdc->getTravail($id);

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('travail', $travail);
    $smarty->assign('editable', $editable);
    $smarty->assign('acronyme', $acronyme);
    $smarty->display('jdc/unTravail.tpl');
}
