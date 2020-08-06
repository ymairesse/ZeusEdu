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

$arborescence = isset($_POST['arborescence']) ? $_POST['arborescence'] : null;
$fileName = isset($_POST['fileName']) ? $_POST['fileName'] : null;
$type = isset($_POST['type']) ? $_POST['type'] : Null;

// recherche des shareIds pour ce fichier
$shares = $Files->getSharesByFileName($arborescence, $fileName, $type, $acronyme);

echo count($shares);
