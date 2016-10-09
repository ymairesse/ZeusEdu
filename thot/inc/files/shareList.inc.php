<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}
$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// si la liste des partages est demandée par le 'fileId' du fichier
$fileId = isset($_POST['fileId']) ? $_POST['fileId'] : null;

// si la liste des partages est demandée par path et fileName
$path = isset($_POST['path']) ? $_POST['path'] : null;
$fileName = isset($_POST['fileName']) ? $_POST['fileName'] : null;

// demande-t-on une liste simple (pas de boutons,...)
$simple = isset($_POST['simple']) ? $_POST['simple'] : null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

if ($fileId != null) {
    $shareList = $Files->getSharesByFileId($fileId);
} else {
    $shareList = $Files->getSharesByFileName($path, $fileName, $acronyme);
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('shareList', $shareList);
if ($simple == true) {
    echo $smarty->fetch('files/simpleShareList.tpl');
} else {
        echo $smarty->fetch('files/shareList.tpl');
    }
