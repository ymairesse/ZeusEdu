<?php
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../config/constantes.inc.php");

$lesClasses = isset($_GET['lesClasses'])?$_GET['lesClasses']:Null;
$groupe = isset($_GET['groupe'])?$_GET['groupe']:Null;

if (($lesClasses == Null) || ($groupe == Null)) die();

$lesClasses = explode(":", $lesClasses);
$connexion = Connexion (NOM, MDP, BASE, SERVEUR);

foreach ($lesClasses as $uneClasse)
	{
	$sql = "UPDATE ".PREFIXETABLES."eleves SET groupe = '$groupe' WHERE classe='$uneClasse';";
	$resultat = ExecuteRequete($sql, $connexion);
	}
Deconnexion ($connexion);
echo $groupe;
?>
