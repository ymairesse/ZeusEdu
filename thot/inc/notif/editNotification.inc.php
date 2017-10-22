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

require_once (INSTALL_DIR."/inc/classes/classThot.inc.php");
$thot = new Thot();

$notification = $thot->getNotification($notifId, $acronyme);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/inc/classes/class.Treeview.php';
$tree = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$acronyme);

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('notification', $notification);
$smarty->assign('tree', $tree->getTree());
$smarty->assign('edition', true);

// s'il s'agit d'une notification à une classe ou un cours, on cherche la liste des élèves
$type = $notification['type'];

if (in_array($type, array('cours', 'classes', 'eleves'))) {
    require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
    $Ecole = new Ecole();
    switch ($type) {
        case 'cours':
            $listeEleves = $Ecole->listeElevesCours($notification['destinataire']);
            break;
        case 'classes':
            $listeEleves = $Ecole->listeElevesClasse($notification['destinataire']);
            break;
        case 'eleves':
            $listeEleves = $Ecole->detailsDeListeEleves($notification['destinataire']);
            break;
    }
}
$smarty->assign('listeEleves', $listeEleves);

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

$pjFiles = $Thot->getPj4Notifs($notifId, $acronyme);

$smarty->assign('pjFiles', $pjFiles);
echo $smarty->display('notification/formNotification.tpl');
