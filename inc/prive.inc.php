<?php
// require_once ("fonctions.inc.php");
require_once ("../config/constantes.inc.php");
// vérifier que l'utilisateur est identifié
if ((!isset($_SESSION['identite']['acronyme']) ||
	(!isset($_SESSION['identite']['mdp'])) ||
	(!$_SESSION['applicationName'] == APPLICATION)
	))
	header("Location: accueil.php");
// vérifier l'accès au répertoire. Le nom du répertoire est le même que le nom du module
if ((moduleIsOpen()))
	{
	header("Location: ".BASEDIR."index.php");
	}
?>
