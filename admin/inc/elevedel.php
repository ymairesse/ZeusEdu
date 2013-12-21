<?php
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../config/constantes.inc.php");
$acronyme = isset($_GET['acronyme'])?$_GET['acronyme']:Null;
if ($acronyme == Null) die();

$connexion = Connexion (NOM, MDP, BASE, SERVEUR);
$sql = "DELETE FROM ".PREFIXETABLES."profs WHERE acronyme='$acronyme'";
$resultat = ExecuteRequete ($sql, $connexion);
$erreur1 = (!(mysql_errno() == 0));
$sql = "DELETE FROM ".PREFIXETABLES."profsApplications WHERE acronyme='$acronyme'";
$resultat = ExecuteRequete ($sql, $connexion);
$erreur2 = (!(mysql_errno() == 0));

if (!($erreur1 || $erreur2))
	echo "<p>Utilisateur $acronyme supprimé</p>";
	else echo "<p>Problème durant les suppression de $acronyme</p>";
Deconnexion($connexion);

?>
