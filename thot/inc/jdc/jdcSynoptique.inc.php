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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$categories = $Jdc->categoriesTravaux();
$smarty->assign('categories', $categories);

$type = 'synoptique';
$smarty->assign('type', $type);
// "mode" pourrait être "subjectif" (dans ce cas, pas moyen de déverrouiller)
$smarty->assign('mode', 'synoptique');
$smarty->assign('destinataire', 'synoptique');

$smarty->assign('lblDestinataire', 'Vue synoptique');
$smarty->assign('coursGrp', 'synoptique');

$smarty->assign('editable', true);

$smarty->assign('jdcInfo', 'Pour voir l\'ensemble de vos cours');

$smarty->display('jdc/jdcAgenda.tpl');
