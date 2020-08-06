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

$shareId = isset($_POST['shareId']) ? $_POST['shareId'] : Null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$fileInfos = $Files->getFileInfoByShareId($shareId, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$ds = DIRECTORY_SEPARATOR;
$file = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$fileInfos['path'].$ds.$fileInfos['fileName'];
$fileInfos['fileType'] = is_dir($file) ? 'dir' : 'file';

$smarty->assign('fileInfos', $fileInfos);

$smarty->display('files/modal/modalEditShare.tpl');
