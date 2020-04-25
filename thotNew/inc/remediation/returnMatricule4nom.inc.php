<?php

require_once("../../../config.inc.php");
session_start();

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once (INSTALL_DIR."/inc/classes/classEleve.inc.php");

$nom = isset($_POST['nom']) ? $_POST['nom'] : Null;

$matricule = Eleve::searchFuzzyMatricule($nom);

echo $matricule;
