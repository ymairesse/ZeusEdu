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

$post = isset($_POST['post']) ? $_POST['post'] : null;
// retour du contenu du formulaire qui a été serializé
$formulaire = array();
parse_str($post, $formulaire);

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

// retourne le fileId du fichier partagé
echo  $Files->share($formulaire, $acronyme);
