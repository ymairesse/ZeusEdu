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

// tous les types de destinataires
$listeTypes = $Thot->getTypes();

// lecture de toutes les notifications pour l'utilisateur courant
// ecole => ... niveau => ... classes => ... cours => ... eleves => ...
$listeNotifications = $Thot->listeUserNotification($acronyme);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeNotifications', $listeNotifications);

$smarty->assign('listeTypes', $listeTypes);
$smarty->display('notification/inc/selectFromHistorique.tpl');
