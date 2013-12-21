<?php
session_start();
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../config/constantes.inc.php");
$codeInfo = isset($_GET['codeInfo'])?$_GET['codeInfo']:Null;
if ($codeInfo == Null) die();

$connexion = Connexion (NOM, MDP, BASE, SERVEUR);
$sql = "DELETE FROM ".PREFIXETABLES."eleves WHERE codeInfo='$codeInfo'";
$resultat = ExecuteRequete ($sql, $connexion);
$erreur = (!(mysql_errno() == 0));

if (!($erreur))
	echo "<p>Élève $codeInfo supprimé</p>";
	else echo "<p>Problème durant les suppression de l'élève $codeInfo</p>";
Deconnexion($connexion);
?>
