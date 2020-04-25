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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$nomGroupe = isset($_POST['nomGroupe']) ? $_POST['nomGroupe'] : null;

$nb = 0;
if (isset($form['profs'])) {
    $listeProfs = $form['profs'];

    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.$ds.'inc/classes/classThot2.inc.php';
    $Thot = new Thot();

    $nb = $Thot->addMembresProfsGroupe($nomGroupe, $listeProfs);
}

echo $nb;
