<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<title>{$titre}</title>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="../js/jquery.form.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>

<script type="text/javascript" src="../js/menuBas.js"></script>
<link rel="stylesheet" href="../menu.css" type="text/css" media="screen">
<link rel="stylesheet" href="../screen.css" type="text/css" media="screen">
<link rel="stylesheet" href="../print.css" type="text/css" media="print">
<!-- feuille de style du module -->
<link rel="stylesheet" href="{$module}.css" type="text/css" media="screen,print">
	
<script type="text/javascript" src="../js/jquery.blockUI.js"></script>
<link type="text/css" media="screen" rel="stylesheet" href="../js/blockUI.css">
<script type="text/javascript" src="../js/jquery.ymtooltip.js"></script>
<link rel="stylesheet" href="../js/ymtooltip.css" type="text/css" media="screen,print">

<script type="text/javascript" src="../js/jquery.enter2tab.js"></script>

<script src="../js/toTop/jquery.easing.1.3.js" type="text/javascript"></script>
<!-- UItoTop plugin -->
<script src="../js/toTop/jquery.ui.totop.js" type="text/javascript"></script>

<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

<script src="../js/jquery.ui.timepicker.js"></script>
<link rel="stylesheet" href="../js/jquery.ui.timepicker.css" type="text/css" media="screen">

<link rel="stylesheet" media="screen,projection" href="../js/toTop/ui.totop.css">

</head>
<body>
{include file="menu.tpl"}
{include file="../../templates/menuHaut.tpl"}	
{if isset($selecteur)}
	{include file="$selecteur.tpl"}
{/if}

<div class="attention">
{if isset($message)}
<span class="title">{$message.title|default:''}</span>
<span class="texte">{$message.texte|default:''}</span>
<span class="icon">{$message.icon|default:''}</span>
{/if}
</div>

<img src="../images/bigwait.gif" id="wait" style="display:none">
<div id="corpsPage" style="clear:both">
{if isset($corpsPage)}
	{include file="$corpsPage.tpl"}
{/if}
</div>
{include file="../../templates/footer.tpl"}

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		
		$("*[title], .tooltip").tooltip();
		
		// selectionner le premier champ de formulaire dans le corps de page ou dans le sélecteur si pas de corps de page
		if ($("#corpsPage").html() != '\n') 
			$("#corpsPage form :input:visible:enabled:first").focus();
			else 
			$("form :input:visible:enabled:first").focus();
		
		$(".attention").hide(); 
		if ($(".attention .texte").html() != null) {
			$.growlUI(
				$(".attention .title").html(),
				$(".attention .texte").html(),
				3000
			)
		}
		
		$("#messageErreur").dialog({
			modal: true,
			width: 400,
			buttons: {
				Ok: function() {
					$( this ).dialog("close" );
					}
				}
			});
		
	
		$("input").tabEnter();
		
		$("*[title], .tooltip").tooltip();
		
		$(".draggable" ).draggable();
		
		$("input").attr("autocomplete","off");
		
	});
	{/literal}
</script>

</body>
</html>
