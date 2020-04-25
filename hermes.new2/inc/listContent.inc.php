<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Hermes
require_once (INSTALL_DIR."/hermes/inc/classes/classHermes.inc.php");
$hermes = new hermes();

// on capte l'id de la liste
$id = isset($_POST['id'])?$_POST['id']:Null;

$listeMembres = $hermes->membresListe($id);
$listeHTML = '<table class="table table-condensed table-striped">';
$listeHTML .= '<tr><th>Membres actuels</th></tr>';
foreach ($listeMembres as $acronyme => $data) {
	$listeHTML .= "<tr><td>".$data['nom']." ".$data['prenom']."</td></tr>";
	}
$listeHTML .= '</table>';

echo $listeHTML;

?>
