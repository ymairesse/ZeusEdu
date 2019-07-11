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

$module = $Application->getModule(3);

// récupérer le formulaire d'encodage du JDC
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';

$listeEleves = $form['eleves'];
$listeProfs = $form['acronyme'];
$moderw = $form['moderw'];

$nb = padEleve::savePartages($acronyme, $moderw, $listeEleves, $listeProfs);

echo $nb;
