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

$groupe = isset($_POST['groupe']) ? $_POST['groupe'] : null;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new thot();

$datasGroupe = $Thot->getData4groupe($groupe);
$membresGroupe = $Thot->getListeMembresGroupe($groupe);
$statutsGroupes = $Thot->getStatusGroupes();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('datasGroupe', $datasGroupe);
$smarty->assign('membresGroupe', $membresGroupe);
$smarty->assign('statutsGroupes', $statutsGroupes);

$smarty->display('groupes/editGroupe.tpl');
