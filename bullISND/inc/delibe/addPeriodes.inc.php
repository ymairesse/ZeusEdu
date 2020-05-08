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

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

Application::afficher($form);

$listePeriodes = isset($form['listePeriodes']) ? $form['listePeriodes'] : Null;

// Cookies actuels à supprimer
$periodesSyntheseCookies = isset($_COOKIE['periodesSynthese']) ? $_COOKIE['periodesSynthese'] : Null;

// supprimer tous les cookies 'mentionsSelect' existants
if ($periodesSyntheseCookies != Null) {
    foreach ($periodesSyntheseCookies as $key => $unePeriode) {
        setcookie('periodesSynthese['.$key.']', $unePeriode, time()-180*24*3600, "/");
    }
}

// création des nouveaux cookies 'periodeSynthese'
if ($listePeriodes != Null) {
    foreach ($listePeriodes as $key => $unePeriode) {
        setcookie('periodesSynthese['.$key.']', $unePeriode, time()+180*24*3600, "/");
    }
}
