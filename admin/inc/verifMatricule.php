<?php
require_once("../config.inc.php");

// définition de la class Ecole
require_once (INSTALL_DIR."/inc/classes/classEleve.inc.php");

$matricule = $_GET['matricule'];
echo (Eleve::eleveExists($matricule));
?>
