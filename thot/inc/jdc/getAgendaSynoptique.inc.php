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

require_once INSTALL_DIR.$ds.'smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';



$type = 'synoptique';
$smarty->assign('type', $type);

$lblDestinataire = $Jdc->getRealDestinataire(Null, $acronyme, $type, $coursGrp);

$smarty->assign('lblDestinataire', $lblDestinataire);
$smarty->assign('destinataire', 'synoptique');

$smarty->assign('editable', 1);

$smarty->assign('synoptique', true);

$smarty->assign('jdcInfo', 'Pour voir l\'ensemble de vos cours');

$smarty->display('jdc/jdcAgenda.tpl');
