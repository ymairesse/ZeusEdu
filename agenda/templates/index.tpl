<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{$titre}</title>

{include file='../../javascript.js'}
{include file='../../styles.sty'}

</head>
<body>
{include file="menu.tpl"}

<div class="container">
{if isset($selecteur)}
	{include file="$selecteur.tpl"}
{/if}
</div>

<img src="../images/bigwait.gif" id="wait" style="display:none" alt="wait">

<div class="attention">
	{if isset($message)}
		<span class="title">{$message.title|default:''}</span>
		<span class="texte">{$message.texte|default:''}</span>
		<span class="icon">{$message.icon|default:''}</span>
	{/if}
</div>

<div id="corpsPage">
{if isset($corpsPage)}
	{include file="$corpsPage.tpl"}
{else}
	{include file="../../templates/corpsPageVide.tpl"}
{/if}
</div>

{include file="../../templates/footer.tpl"}

<script type="text/javascript">
	
	$(document).ready(function(){
		
		$("*[title], .tooltip").tooltip();
		
		// selectionner le premier champ de formulaire dans le corps de page ou dans le sélecteur si pas de corps de page
		if ($("#corpsPage").html() != '\n') 
			$("#corpsPage form :input:visible:enabled:first").focus();
			else 
			$("form :input:visible:enabled:first").focus();
		
		$("input").tabEnter();
		
		$("*[title]").tooltip();
		
		$("input").not(".autocomplete").attr("autocomplete","off");
		
	});
	
</script>

</body>
</html>
