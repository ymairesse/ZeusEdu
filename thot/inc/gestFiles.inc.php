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
        // si le répertoire de l'utilisateur n'existe pas encore, le créer
        if (!(file_exists($dir))) {
            @mkdir($dir, 0700, true);
        }
        $tree = new Treeview($dir);
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
    case 'casier':
        $coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;
        $smarty->assign('coursGrp', $coursGrp);
        require_once INSTALL_DIR.'/inc/classes/class.Files.php';
        $Files = new Files();
        $listeCours = $User->listeCoursProf();
        $smarty->assign('listeCours', $listeCours);
        if ($etape == 'enregistrer') {
            Application::afficher($_POST);
        }
        $smarty->assign('corpsPage', 'files/casierVirtuel');
        break;
    default:
        # code...
        break;
}
