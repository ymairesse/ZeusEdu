<?php
require_once ("../../inc/fonctions.inc.php");
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../config/constantes.inc.php");

$codeInfo = (isset($_GET['codeInfo'])?$_GET['codeInfo']:Null);
if ($codeInfo == Null) die (ADMINISTRATOR);

$connexion = Connexion (NOM, MDP, BASE, SERVEUR);
$sql = "SELECT * FROM ".PREFIXETABLES."eleves WHERE codeInfo = '$codeInfo'";
$eleve = ExecuteRequete($sql, $connexion);

// il ne peut y avoir qu'un seul résultat: les codes Info sont uniques
$fiche = ligneSuivante($eleve);
$groupe = $fiche['groupe'];

// recherche des infos sur les titulaires
$sql2 = "SELECT acronyme, prenom, nom FROM ".PREFIXETABLES."profs WHERE titulaire = '$groupe'";
$titus = ExecuteRequete($sql2, $connexion);
$titulaires = array();
while ($titulaire = ligneSuivante($titus))
	$titulaires[] = $titulaire['prenom']." ".$titulaire['nom'];
$fiche['titulaires'] = implode(", ", $titulaires);
Deconnexion($connexion);

require_once ("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";	

$smarty->assign("fiche", $fiche);
$smarty->display("infoEleves.tpl");
?>
