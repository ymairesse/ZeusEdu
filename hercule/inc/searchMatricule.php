<?php

session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once INSTALL_DIR."/inc/classes/classApplication.inc.php";
$Application = new Application();

require_once (INSTALL_DIR."/inc/classes/classEleve.inc.php");

$nomPrenomClasse = isset($_POST['nomPrenomClasse']) ? $_POST['nomPrenomClasse'] : Null;

$matricule = Eleve::searchMatricule($nomPrenomClasse);

echo $matricule;
