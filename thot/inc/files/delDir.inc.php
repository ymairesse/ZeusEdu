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

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$activeDir = isset($_POST['activeDir']) ? $_POST['activeDir'] : null;

$ds = DIRECTORY_SEPARATOR;
$root = INSTALL_DIR.$ds;
$upload = 'upload'.$ds.$acronyme.$activeDir;

// impossible d'effacer un répertoire dont le nom commence par #
if (substr($activeDir, 1, 1) != '#') {
    $allFiles = $Files->getAllFilesFrom($root, $upload);
    $nb = $Files->unShareAllFiles($allFiles, $acronyme);

    echo $Files->delTree(INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$activeDir);
}
else {
    exit;
}
