<?php

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

switch ($mode) {
    case 'share':
        require_once INSTALL_DIR.'/inc/classes/class.Treeview.php';

        $ds = DIRECTORY_SEPARATOR;
        $dir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;
        $tree = new Treeview($dir);
        // Application::afficher($tree, true);

        $smarty->assign('tree', $tree->getTree());
        $smarty->assign('dir', $dir);

        $smarty->assign('corpsPage', 'files/fileview');
        break;
    case 'e-docs':
        require_once INSTALL_DIR.'/inc/classes/class.Files.php';
        $Files = new Files();
        $listeFichiers = $Files->sharedWith($acronyme);
        $smarty->assign('listeFichiers', $listeFichiers);
        $smarty->assign('corpsPage', 'files/sharedWithMe');
        break;

    default:
        # code...
        break;
}
