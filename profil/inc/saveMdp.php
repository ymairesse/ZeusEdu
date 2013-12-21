<?php
session_start();
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../inc/fonctions.inc.php");
require_once ("../../config/constantes.inc.php");

Normalisation();

$identite = $_SESSION['identite'];
$acronyme = $identite['acronyme'];

$mdp = ($_POST['mdp']!="")?$_POST['mdp']:Null;
$mdp2 = ($_POST['mdp2']!="")?$_POST['mdp2']:Null;

$erreur = "";
if ($mdp != $mdp2)
    $erreur = "Les deux versions du mot de passe sont différentes. ";
if ((strlen($mdp) > 0) && (strlen($mdp) < 6))
    $erreur .= "Le mot de passe trop court. ";
if ($mdp != Null)
    $data['mdp']= md5($mdp);
if ($erreur != "")
    die("Le formulaire contient des erreurs: $erreur");

if ($mdp != Null)
	$md5mdp = md5($mdp);

$connexion = Connexion (NOM,MDP,BASE,SERVEUR);
$sql = "UPDATE ".PREFIXETABLES."profs SET mdp = '$md5mdp' ";
$sql .= " WHERE acronyme = '$acronyme'";
$resultat = executeRequete($sql, $connexion);
Deconnexion ($connexion);

require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign ("redirection","../index.php");
$smarty->assign ("time",2000);
$smarty->display("redirect.tpl");
?>
