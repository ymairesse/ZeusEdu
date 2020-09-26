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

$periodeSelect = isset($form['periodeSelect']) ? $form['periodeSelect'] : Null;

$listeMentions = isset($form['listeMentions']) ? $form['listeMentions'] : Null;

// Cookies actuels à supprimer
$mentionsCookies = isset($_COOKIE['mentionsSelect']) ? $_COOKIE['mentionsSelect'] : Null;

// supprimer tous les cookies 'mentionsSelect' existants
if ($mentionsCookies != Null) {
    foreach ($mentionsCookies as $key => $uneMention) {
        setcookie('mentionsSelect['.$key.']', $uneMention, time()-180*24*3600, "/");
    }
}

// création des nouveaux cookies 'mentionsSelect'

if ($listeMentions != Null) {
    foreach ($listeMentions as $key => $uneMention) {
        echo $uneMention;
        setcookie('mentionsSelect['.$key.']', $uneMention, time()+180*24*3600, "/");
    }
}

setcookie('periodeSelect', $periodeSelect, time()+180*24*3600, "/");
