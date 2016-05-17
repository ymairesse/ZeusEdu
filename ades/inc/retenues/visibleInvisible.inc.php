<?php

session_start();
require_once '../../../config.inc.php';

// définition de la class Application nécessaire dans la class ADES
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class ADES
require_once INSTALL_DIR.'/ades/inc/classes/classAdes.inc.php';
$Ades = new Ades();

$idretenue = isset($_POST['idretenue']) ? $_POST['idretenue'] : null;
$visible = isset($_POST['visible']) ? $_POST['visible'] : null;

// inversion de la visibilité
$visible = ($visible == 'O') ? 'N' : 'O';

$texte = $Ades->toggleAffichageRetenue($idretenue, $visible);
echo $texte;
