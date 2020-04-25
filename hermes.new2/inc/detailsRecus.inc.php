<?php

require_once '../../config.inc.php';

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

$id = isset($_POST['id']) ? $_POST['id'] : Null;
$nonLu = isset($_POST['nonLu']) ? $_POST['nonLu'] : Null;

$module = Application::getModule(2);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classHermes.inc.php';
$Hermes = new Hermes();

if (!($Hermes->verifAcces($id, $acronyme)))
    die('Cette notification ne vous est pas destinée');

// marquer comme lu (si pas déjà fait)
if ($nonLu == 'true') {
    $Hermes->marqueLu($id, $acronyme, 1);
}
// chercher les détails de la notification $id
$notification = $Hermes->getNotification($id);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('notification', $notification);
$smarty->display('modal/showValve.tpl');
