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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

if (isset($form['categories'])) {
    $categories = $form['categories'];

    $start = isset($_POST['start']) ? $_POST['start'] : Null;
    $end = isset($_POST['end']) ? $_POST['end'] : Null;

    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
    $Jdc = new Jdc();

    $ghost = $Jdc->getGhostJdc ($acronyme, $start, $end, $categories);
    // enregistrement du modèle dans la base de données
    $nb = $Jdc->saveGhost($ghost, $acronyme);

    echo $nb;
}
else echo 0;
