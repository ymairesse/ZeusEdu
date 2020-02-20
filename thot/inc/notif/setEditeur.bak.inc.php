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

$type = isset($_POST['type']) ? $_POST['type'] : Null;
$destinataire = isset($_POST['destinataire']) ? $_POST['destinataire'] : Null;

$ds = DIRECTORY_SEPARATOR;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$notification = $Thot->newNotification($type, $acronyme, $destinataire);

// Application::afficher($notification, true);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('notification', $notification);
$smarty->display('notification/formNotification.tpl');
