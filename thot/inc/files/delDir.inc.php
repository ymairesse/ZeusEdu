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

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$arborescence = isset($_POST['arborescence'])?$_POST['arborescence']:Null;
$fileName = isset($_POST['fileName'])?$_POST['fileName']:Null;

$ds = DIRECTORY_SEPARATOR;
$root = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;

$arborescence = $arborescence.$ds.$fileName;

// rustine: suppression des éventuelles occurrences multiples de "/"
$completeFileName = preg_replace('~/+~', '/', $root.$ds.$arborescence);

// impossible d'effacer un répertoire dont le nom commence par #
if ((substr($arborescence, 0, 1) != '#') && (file_exists($completeFileName))) {
    // liste l'ensemble des fichiers dans l'arborescence de l'utilisateur,
    // dans un tableau linéaire
    // n => {'path' => ... , 'fileName' => ... , 'dirOrFile' => 'dir'|'file'}
    $allFiles = $Files->getAllFilesFrom($root, $arborescence);

    // recherche des $shareIds du répertoire et des fichiers / répertoires inclus
    $listeShareIds = $Files->getShareIdsFromFileList($allFiles, $acronyme);

    // suppression des témoins de téléchargement sur base des $shareIds
    foreach ($listeShareIds as $shareId => $data){
        $nb = $Files->delSpy4ShareId($shareId, $acronyme);
    }

    // suppression des partages par $shareIds
    foreach ($listeShareIds as $shareId => $data) {
        $nb = $Files->unShareByShareId($shareId, $acronyme);
    }

    // suppression des fichiers dans la table didac_files de la BD
    foreach ($listeShareIds as $shareId => $data) {
        $fileId = $data['fileId'];
        $nb = $Files->delFileByFileId($fileId);
    }

    // effacement effectif du répertoire et des fichiers contenus
    $nbDir = $Files->delTree(INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$arborescence);
    echo json_encode(array('nbFiles' => count($allFiles)-1, 'nbDir' => $nbDir));
    }
else {
     exit;
}
