<?php

require_once '../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$User = $_SESSION[APPLICATION];

$acronyme = $User->getAcronyme();

$module = $Application->getModule(2);

$ds = DIRECTORY_SEPARATOR;
$dir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module;

// si le répertoire de l'utilisateur n'existe pas encore, le créer
if (!(file_exists($dir))) {
    @mkdir($dir, 0700, true);
}

if (!empty($_FILES)) {
    $tempFile = $_FILES['file']['tmp_name'];
    $targetFile = $dir.$ds.$_FILES['file']['name'];
    echo (move_uploaded_file($tempFile, $targetFile));
}
