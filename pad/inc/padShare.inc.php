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

// récupérer le formulaire d'encodage des cours
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$listeProfs = isset($form['profs']) ? $form['profs'] : Null;
$listeEleves = isset($form['eleves']) ? $form['eleves'] : Null;
$moderw = $form['moderw'];

$nb = 0;
if ($listeEleves != Null && $listeProfs != Null) {
    require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
    // padEleve générique
    $Pad = new padEleve(Null, Null);

    $nb = $Pad->savePartages($acronyme, $moderw, $listeEleves, $listeProfs);
    }
echo $nb;
