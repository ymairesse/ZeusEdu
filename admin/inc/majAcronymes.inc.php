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

$module = $Application::getmodule(2);

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$ancien = isset($form['ancien']) ? $form['ancien'] : Null;
$nouveau = isset($form['nouveau']) ? $form['nouveau'] : Null;
$table = isset($form['table']) ? $form['table'] : Null;
$field = isset($form['field']) ? $form['field'] : Null;

$ds = DIRECTORY_SEPARATOR;

$nb = $Application->changeAcronyme4table($ancien, $nouveau, $table, $field);

echo $nb;
