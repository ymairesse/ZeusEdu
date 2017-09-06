<?php
session_start();
require_once ("../inc/fonctionsAdmin.inc.php");
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../config/constantes.inc.php");

$codeInfo = isset($_GET['codeInfo'])?$_GET['codeInfo']:Null;
if ($codeInfo == Null) die();

$connexion = connexion (NOM, MDP, BASE, SERVEUR);
$sql = "SELECT CONCAT(nom,' ',prenom) AS nomPrenom FROM ".PREFIXETABLES."eleves WHERE codeInfo='$codeInfo'";
$resultat = executeRequete($sql, $connexion);
$erreur = (!(mysql_errno() == 0));
$ligne = ligneSuivante($resultat);
$nomPrenom = $ligne['nomPrenom'];

require("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign ("nomPrenom", $nomPrenom);
$smarty->assign ("codeInfo", $codeInfo);
$smarty->display ("confirmEleveDel.tpl");

Deconnexion($connexion);

?>
