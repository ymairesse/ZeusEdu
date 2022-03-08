<?php

require_once("../../config.inc.php");
// définition de la class Application
require_once(INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once (INSTALL_DIR."/ades/inc/classes/classAdes.inc.php");
$Ades = new Ades();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
$User = $_SESSION[APPLICATION];

$acronyme = $User->getAcronyme();

$champ = isset($_POST['champ']) ? $_POST['champ'] : Null;
$texte = isset($_POST['texte']) ? $_POST['texte'] : Null;
$id = isset($_POST['id']) ? $_POST['id'] : Null;
$free = isset($_POST['free']) ? $_POST['free'] : 0;

$nb = $Ades->saveTexte($id, $acronyme, $free, $texte, $champ);

echo $nb;
