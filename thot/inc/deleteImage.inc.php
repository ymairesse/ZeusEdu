<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

$pathAndFile = array_reverse(explode('/', $_POST['src']));

$fileName = $pathAndFile[0];
$acronyme = $pathAndFile[1];
$path = $pathAndFile[2];

$ds = DIRECTORY_SEPARATOR;

unlink(INSTALL_DIR.$ds.$path.$ds.$acronyme.$ds.$fileName);
