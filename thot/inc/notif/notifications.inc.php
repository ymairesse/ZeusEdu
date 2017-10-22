<?php

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/inc/classes/class.Treeview.php';
$tree = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$acronyme);
$smarty->assign('tree', $tree->getTree());

switch ($mode) {
    case 'classes':
        require 'inc/notif/notificationClasse.inc.php';
        break;
    case 'coursGrp':
        require 'inc/notif/notificationCours.inc.php';
        break;
    case 'niveau':
        require 'inc/notif/notificationNiveau.inc.php';
        break;
    case 'ecole':
        require 'inc/notif/notificationEcole.inc.php';
        break;
    case 'historique':
        require 'inc/notif/historique.inc.php';
        break;
    }
