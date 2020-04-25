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

$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

require_once INSTALL_DIR.$ds.'smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('coursGrp', $coursGrp);

$categories = $Jdc->categoriesTravaux();
$smarty->assign('categories', $categories);

$type = 'coursGrp';
$smarty->assign('type', $type);
// $mode pourrait être "subjectif"
$smarty->assign('mode', 'coursGrp');

$lblDestinataire = $Jdc->getRealDestinataire(Null, $acronyme, $type, $coursGrp);
$smarty->assign('lblDestinataire', $lblDestinataire);
$smarty->assign('destinataire', $coursGrp);

$smarty->assign('editable', true);

$smarty->assign('synoptique', false);

$listeCategories = $Jdc->getListeCategoriesJDC();
$smarty->assign('listeCategories', $listeCategories);

$smarty->assign('jdcInfo', 'Pour voir votre JDC par cours');

$smarty->display('jdc/jdcCours.tpl');
