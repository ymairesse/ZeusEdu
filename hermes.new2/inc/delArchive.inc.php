<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Hermes
require_once (INSTALL_DIR."/hermes/inc/classes/classHermes.inc.php");
$hermes = new hermes();
// on capte l'id du mail archivé dans la base de données
$archive = isset($_POST['archive'])?$_POST['archive']:Null;
// on aura besoin de l'acronyme de l'utilisateur pour supprimer les fichiers joints
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
// on recherche l'archive dans la BD
$mail = $hermes->archive($archive);
// suppression des pièces jointes
$PJ = explode(',',$mail['PJ']);
foreach ($PJ as $unePJ) {
	$unePJ = trim($unePJ);
	if ($unePJ != '')
		@unlink("../upload/$acronyme/$unePJ");
	}
// suppression de la référence dans la BD
$n = $hermes->delArchive($archive);
echo $n;
?>
