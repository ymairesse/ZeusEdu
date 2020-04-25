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

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(3);

require_once INSTALL_DIR.$ds.'inc/classes/classThot2.inc.php';
$Thot = new thot();

$notifId = isset($_POST['notifId']) ? $_POST['notifId'] : null;

$notification = $Thot->getNotification($notifId, $acronyme);
$destinataire = $notification['destinataire'];
$type = $notification['type'];

$pjFiles = $Thot->getPj4singleNotif($notifId, $acronyme);
$destinataire = $Thot->getTrueDestinataire($type, $destinataire);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('notifId', $notifId);
$smarty->assign('type', $type);
$smarty->assign('notification', $notification);
$smarty->assign('destinataire', $destinataire);
$smarty->assign('pjFiles', $pjFiles);

$smarty->display('notification/modal/modalDelete.tpl');
