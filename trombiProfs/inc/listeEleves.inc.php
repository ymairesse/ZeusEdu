<?php
session_start();
require_once ("fonctionsTrombi.inc.php");
// require ("../../config/BD/utilBD.inc.php");
// require ("../../config/constantes.inc.php");

$groupe = isset($_GET['groupe'])?$_GET['groupe']:Null;
if ($groupe == Null) die();

$listeEleves = elevesDeClasseFromBulluc($groupe);
/*
$connexion = connexion (NOM, MDP, BASE, SERVEUR);
$sql = "SELECT codeInfo,concat(nom,' ',prenom) as nomPrenom FROM ".PREFIXETABLES."eleves WHERE groupe = '$groupe' ";
$sql .= "ORDER BY REPLACE(REPLACE (nom, ' ', ''),'''',''), prenom;";

$resultat = ExecuteRequete($sql, $connexion);
$listeEleves = array();
while ($eleve = LigneSuivante($resultat))
	$listeEleves[] = $eleve;
Deconnexion($connexion);
*/
require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("listeEleves", $listeEleves);
$smarty->display("listeEleves.tpl");
?>
