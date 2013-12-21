<?php
/*
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../inc/fonctions.inc.php");
require_once ("../../config/constantes.inc.php");

$connexion = Connexion (NOM,MDP,BASE,SERVEUR);
$sql = "SELECT acronyme FROM ".PREFIXETABLES."profs ";
$resultat = executeRequete($sql, $connexion);

$profs = array();
while ($ligne = LigneSuivante($resultat))
	$profs[] = $ligne['acronyme'];

foreach ($profs as $acronyme) {
	$sql = "INSERT INTO didac_profsApplications SET acronyme = '$acronyme', application='delibes', statut='prof'";
	$resultat = executeRequete($sql, $connexion);
	}

Deconnexion ($connexion); */
?>
