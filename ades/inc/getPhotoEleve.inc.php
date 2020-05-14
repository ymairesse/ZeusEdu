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

// récupérer le formulaire d'encodage du livre
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';

$photo = Ecole::photo($matricule);

echo $photo;
