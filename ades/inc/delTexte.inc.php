<?php
session_start();
require_once("../../config.inc.php");
// définition de la class Application
require_once(INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

require_once (INSTALL_DIR."/ades/inc/classes/classAdes.inc.php");
$Ades = new Ades();

$id = isset($_POST['id'])?$_POST['id']:'';

if ($id == Null) die("no text");
$nb = $Ades->delTexte($id);
if ($nb == 1) {
		$html = "<div class='alert alert-warning alert-dismissable auto-fadeOut' role='alert'>
	<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
	Texte supprimé
	</div>";
	echo $html;
}
?>