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

$listeProfs = isset($form['acronymes']) ? $form['acronymes'] : Null;
$listeEleves = isset($form['matricules']) ? $form['matricules'] : Null;
$nomGroupe = $form['nomGroupe'];

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classThot.inc.php';
$Thot = new Thot();

$nb = 0;
if ($listeEleves != Null)
    $nb += $Thot->delMembresGroupe($nomGroupe, 'eleves', $listeEleves);
if ($listeProfs != Null)
    $nb += $Thot->delMembresGroupe($nomGroupe, 'profs', $listeProfs);

echo $nb;
