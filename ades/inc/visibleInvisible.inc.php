<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application nécessaire dans la class ADES
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class ADES
require_once (INSTALL_DIR."/ades/inc/classes/classAdes.inc.php");
$Ades = new Ades();

$id = isset($_POST['id'])?$_POST['id']:Null;
$texte = isset($_POST['texte'])?$_POST['texte']:Null;
if (($id == Null) || ($texte == Null)) die();

$texte = $Ades->toggleAffichageRetenue($id, $texte);
echo $texte;
?>
