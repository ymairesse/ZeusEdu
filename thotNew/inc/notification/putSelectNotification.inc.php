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

$notifId = isset($_POST['notifId']) ? $_POST['notifId'] : Null;

require_once INSTALL_DIR."/inc/classes/classThot.inc.php";
$Thot = new Thot();
$notification = $Thot->getNotification($notifId, $acronyme);

// attribuer le type virtuel "eleve" si $notification['eleve'] = 1
$notification['type'] = ($notification['eleve'] == 1) ? 'eleves' : $notification['type'];
$type = $notification['type'];
$destinataire = $notification['destinataire'];
$notification['trueDest'] = $Thot->getTrueDestinataire($type, $destinataire);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('notification', $notification);
$smarty->display('notification/selecteurEdit.tpl');
