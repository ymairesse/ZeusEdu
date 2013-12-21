<?php
session_start();
require_once ("fonctionsTrombi.inc.php");
// fonctions relatives à la BD
require_once ("../../config/BD/utilBD.inc.php");

$cours = isset($_GET['cours'])?$_GET['cours']:Null;
if ($cours == Null) die();

$listeEleves = ElevesDuCoursFromBulluc($cours);
/* 
$connexion = connexion (NOM, MDP, BASE, SERVEUR);

$sql = "SELECT ".PREFIXETABLES."elevesCours.codeInfo,concat(nom,' ',prenom) as nomPrenom ";
$sql .= "FROM ".PREFIXETABLES."elevesCours ";
$sql .= "JOIN ".PREFIXETABLES."eleves ON (".PREFIXETABLES."eleves.codeInfo = ".PREFIXETABLES."elevesCours.codeInfo) ";
$sql .= "WHERE coursGrp = '$cours' ";
$sql .= "ORDER BY REPLACE(REPLACE (nom, ' ', ''),'''',''), prenom";

$resultat = ExecuteRequete($sql, $connexion);
$listeEleves = array();
while ($eleve = LigneSuivante($resultat))
	$listeEleves[] = $eleve;
Deconnexion($connexion); */
require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("listeEleves", $listeEleves);
$smarty->display("listeEleves.tpl");
?>
