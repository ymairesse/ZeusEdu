<?php
session_start();
require_once("../../config.inc.php");
// définition de la class Application
require_once(INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once (INSTALL_DIR."/ades/inc/classes/classAdes.inc.php");
$Ades = new Ades();

$texte = isset($_POST['texte'])?$_POST['texte']:Null;
$user = isset($_POST['qui'])?$_POST['qui']:Null;
$champ = isset($_POST['champ'])?$_POST['champ']:Null;

if (($texte == Null) || ($user == Null || $champ == Null)) die("no text no user");

$nb = $Ades->saveTexte('', $user, '0', $texte, $champ);
if ($nb == 1)
	echo ":o)";

?>