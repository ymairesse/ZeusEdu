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

// retour du contenu du formulaire qui a été serializé
$form = array();
parse_str($formulaire, $form);

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

// On postule que tout s'est bien passé :o)
$wtf = $Files->share($form, $acronyme);
