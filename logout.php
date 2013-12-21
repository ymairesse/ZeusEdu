<?php 
session_start();
session_destroy();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
