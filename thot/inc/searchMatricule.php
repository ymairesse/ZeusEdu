<?php

require_once("../../config.inc.php");
session_start();


// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once (INSTALL_DIR."/inc/classes/classEleve.inc.php");

$nomPrenomClasse = isset($_POST['query']) ? $_POST['query'] : Null;

$matricule = Eleve::searchMatricule($nomPrenomClasse);

echo $matricule;
