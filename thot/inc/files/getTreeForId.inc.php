<?php

require_once '../../../config.inc.php';
// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$fileId = isset($_POST['fileId']) ? $_POST['fileId'] : null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

$fileId = isset($_POST['fileId']) ? $_POST['fileId'] : null;

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$listeSharedFiles = $Files->getFilesSharedWith($acronyme);

if (in_array($fileId, $listeSharedFiles)) {
    $infos = $Files->getSharedfileById($fileId);
    $proprio = $infos['acronyme'];
    $path = $infos['path'];

    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.'/inc/classes/class.Treeview.php';
    $Treeview = new Treeview(INSTALL_DIR.$ds.'upload'.$ds.$proprio.$path);

    require_once(INSTALL_DIR."/smarty/Smarty.class.php");
    $smarty = new Smarty();
    $smarty->template_dir = "../../templates";
    $smarty->compile_dir = "../../templates_c";

    $smarty->assign('tree', $Treeview->getTree());
    $smarty->assign('fileId', $fileId);
    echo $smarty->fetch('files/treeviewDownload.tpl');
}
