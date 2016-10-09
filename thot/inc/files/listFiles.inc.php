<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$activeDir = isset($_POST['activeDir']) ? $_POST['activeDir'] : null;

$ds = DIRECTORY_SEPARATOR;
// $activeDir = INSTALL_DIR.$ds.$module.$ds.'upload'.$ds.$acronyme.$ds.$activeDir;
$activeDir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$activeDir;

require_once INSTALL_DIR.'/inc/classes/class.Treeview.php';
$Treeview = new Treeview($activeDir);
$listFiles = $Treeview->getTree();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listFiles', $listFiles);
echo $smarty->fetch('files/listFiles.tpl');
