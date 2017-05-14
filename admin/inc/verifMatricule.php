<?php

require_once("../../config.inc.php");

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class Eleve
require_once (INSTALL_DIR."/inc/classes/classEcole.inc.php");
$Ecole = new Ecole();

$matricule = $_GET['matricule'];
echo ($Ecole->eleveExiste($matricule));
