<?php 
require_once('config.inc.php');

// définition de la class USER utilisée en variable de SESSION
require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

session_start();
if (isset($_SESSION[APPLICATION])) {

	$user = $_SESSION[APPLICATION];

	// suppression de la notification en BD
	$user->delogger();
	}
session_destroy();
header('Location: ./accueil.php?message=logout');
exit; 
?>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Déconnexion</title>
	<link type="text/css" rel="stylesheet" media="all" href="screen.css">
	<link type="text/css" rel="stylesheet" media="screen" href="js/blockUI.css">	
	<script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="js/jquery.blockUI.js"></script>

</head>
<body>
<img src="images/bigwait.gif" id="wait" alt="wait">
<div class="attention" style="display:none">
    <span class="title">Confirmation</span>
    <span class="texte">Déconnexion en cours</span>
</div>

</body>
</html>
