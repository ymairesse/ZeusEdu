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

// récupérer le formulaire contenant les fichiers à ajouter
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);


// $fileInfos = $Files->getFileInfoByShareId($shareId, $acronyme);
//
// $ds = DIRECTORY_SEPARATOR;
// $file = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$fileInfos['path'].$ds.$fileInfos['fileName'];
// $fileInfos['fileType'] = is_dir($file) ? 'dir' : 'file';
//
// echo json_encode($fileInfos);
