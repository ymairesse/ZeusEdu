<?php

require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';

$module = $Application->getModule(3);

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;

$eleve = Eleve::staticGetDetailsEleve($matricule);
$groupe = $eleve['groupe'];

echo $groupe;
