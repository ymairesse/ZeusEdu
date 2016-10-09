<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// $module = $Application->getModule(2);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$post = isset($_POST['post']) ? $_POST['post'] : null;
// retour du contenu du formulaire qui a été serializé
$form = array();
parse_str($post, $form);

// Application::afficher($form);

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

// retourne le fileId du fichier partagé
echo  $Files->share($form, $acronyme);
