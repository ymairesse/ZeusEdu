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

$name = isset($_POST['name']) ? $_POST['name'] : Null;
$value = isset($_POST['value']) ? $_POST['value'] : Null;

$unAn = time() + 365 * 24 * 3600;

setcookie($name, $value, $unAn, '/', null, false, true);
