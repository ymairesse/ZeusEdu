<?php

require_once '../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}
$User = $_SESSION[APPLICATION];

$passwd1 = isset($_POST['passwd1']) ? $_POST['passwd1'] : null;
$passwd2 = isset($_POST['passwd2']) ? $_POST['passwd2'] : null;

if (($passwd1 == $passwd2) && strlen($passwd1) >= 8) {
    $resultat = $User->savePasswd($passwd1);
}

echo $resultat;
