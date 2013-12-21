<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<title>{$titre}</title>
<script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="../js/jquery.form.js"></script>
<script type="text/javascript" src="../js/jquery.validate.js"></script>
<script type="text/javascript" src="../js/jquery.blockUI.js"></script>
<script type="text/javascript" src="../js/jquery.enter2tab.js"></script>
<script type="text/javascript" src="../js/toTop/jquery.ui.totop.js"></script>
<script type="text/javascript" src="../js/menuBas.js"></script>
<script type="text/javascript" src="../js/jquery.ymtooltip.js"></script>
<script type="text/javascript" src="../js/toTop/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="../js/jquery.ui.timepicker.js"></script>
<script type="text/javascript" src="../js/jquery-ui-1.10.3/ui/minified/jquery-ui.min.js"></script>

<link rel="stylesheet" href="../menu.css" type="text/css" media="screen">
<link rel="stylesheet" href="../screen.css" type="text/css" media="screen">
<link rel="stylesheet" href="../print.css" type="text/css" media="print">
<link rel="stylesheet" href="../js/blockUI.css" type="text/css" media="screen">
<link rel="stylesheet" href="../js/ymtooltip.css" type="text/css" media="screen,print">
<link rel="stylesheet" href="../js/jquery-ui-themes-1.10.3/themes/smoothness/jquery-ui.css" media="screen, print">

<link rel="stylesheet" href="../js/jquery.ui.timepicker.css" type="text/css" media="screen">
<link rel="stylesheet" media="screen,projection" href="../js/toTop/ui.totop.css">
<!-- feuille de style du module -->
<link rel="stylesheet" href="{$module}.css" type="text/css" media="screen,print">

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

<img src="../images/bigwait.gif" id="wait" style="display:none" alt="wait">
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
		
		$("input").not(".autocomplete").attr("autocomplete","off");
		
	});
	{/literal}
</script>

</body>
</html>
