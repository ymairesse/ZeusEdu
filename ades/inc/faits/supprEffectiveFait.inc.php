<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// répertoire du module actuel
$module = $Application->getModule(3);

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$idfait = isset($_POST['idfait']) ? $_POST['idfait']: null;

require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

// suppression du fait avec libération éventuelle de la place de retenue
$n = $EleveAdes->supprFait($idfait);

echo $n;
