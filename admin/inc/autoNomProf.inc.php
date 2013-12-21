<?php
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../config/constantes.inc.php");

$q = $_GET["q"];
if (!$q) return;

$connexion = Connexion (NOM,MDP,BASE,SERVEUR);
$sql = "SELECT nom, prenom, acronyme FROM ".PREFIXETABLES."profs ";
$sql .= "WHERE CONCAT(nom, prenom) LIKE '%$q%' ORDER BY CONCAT(nom, prenom)";

$resultat = executeRequete($sql, $connexion);
Deconnexion ($connexion);

$texte = "";
while ($ligne = ligneSuivante($resultat))
    {
    $prof = $ligne['nom']." ".$ligne['prenom'];
    $acronyme = $ligne['acronyme'];
    $texte .= "{\"nom\":\"$prof\", \"acronyme\":\"$acronyme\"}\n";
    }
echo $texte;
?>
