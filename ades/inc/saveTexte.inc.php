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

$texte = isset($_POST['texte'])?$_POST['texte']:Null;
$champ = isset($_POST['champ'])?$_POST['champ']:Null;
$id = isset($_POST['id'])?$_POST['id']:'';
$free = isset($_POST['free'])?$_POST['free']:0;

if (($texte == Null) || ($User == Null || $champ == Null)) die("no text no user");
$nb = $Ades->saveTexte($id, $acronyme, $free, $texte, $champ);

if ($nb > 0) {
	$html = "<div class='alert alert-success alert-dismissable auto-fadeOut' role='alert'>
	<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
	Enregistrement réussi...
	</div>";
	echo $html;
	}
