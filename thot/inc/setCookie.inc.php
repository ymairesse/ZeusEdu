<?php

session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$unAn = time() + 365 * 24 * 3600;

$module = $Application->getModule(2);
echo $module;

$cookieName = isset($_POST['name']) ? $_POST['name'] : Null;
$cookieValue = isset($_POST['cookie']) ? $_POST['cookie'] : Null;
$duree = isset($_POST['length']) ? $_POST['length'] : $unAn;

setCookie($cookieName, $cookieValue, $unAn, '/');
