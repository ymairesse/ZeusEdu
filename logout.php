<?php 
require_once('config.inc.php');

// définition de la class USER utilisée en variable de SESSION
require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

session_start();
$user = $_SESSION[APPLICATION];

// définition de la class USER utilisée en variable de SESSION
require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");
$user = $_SESSION[APPLICATION];
// suppression de la notification en BD
$user->delogger();

session_destroy();
?>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>Déconnexion</title>
  <link media="all" rel="stylesheet" href="screen.css" type="text/css">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>

<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<link type="text/css" media="screen" rel="stylesheet" href="js/blockUI.css">

<script type="text/javascript">
  
  function delayRedirect(){  
	window.location = "index.php";  
  } 
$(document).ready(function(){
	setTimeout('delayRedirect()', 1000);
	$.growlUI(
				$(".attention .title").html(),
				$(".attention .texte").html(),
				2000
			)
	})
</script>
</head>
<body>
<img src="images/bigwait.gif" id="wait" alt="wait">
<div class="attention" style="display:none">
    <span class="title">Confirmation</span>
    <span class="texte">Déconnexion en cours</span>
</div>
</body>
</html>
