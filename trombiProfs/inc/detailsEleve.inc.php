<?php
session_start();
require ("../../config/BD/utilBD.inc.php");
require ("../../config/constantes.inc.php");
require ("../../inc/fonctions.inc.php");

$codeInfo = $_GET['codeInfo'];

$connexion = Connexion (NOM,MDP,BASE,SERVEUR);
$sql = "SELECT * FROM ".PREFIXETABLES."eleves WHERE codeInfo = '$codeInfo';";
$resultat = executeRequete($sql, $connexion);
$eleve = ligneSuivante($resultat);

// recherche des titulaires pour le groupe auquel appartient l'élève
$groupe = $eleve['groupe'];
$sql = "SELECT CONCAT(prenom,' ',nom) as nom FROM ".PREFIXETABLES."profs WHERE titulaire='$groupe'";
$resultat = executeRequete($sql, $connexion);
$titulaires = "";
while ($ligne = ligneSuivante($resultat))
	$titulaires .= implode(' ',$ligne)." ";
Deconnexion ($connexion);

// détermination de l'âge exact de l'élève
$age = age(dateNaiss($codeInfo));

require ("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign ("age",$age);
$smarty->assign ("eleve", $eleve);
$smarty->assign ("titulaires",$titulaires);
$smarty->display("infoEleves.tpl");
?>
