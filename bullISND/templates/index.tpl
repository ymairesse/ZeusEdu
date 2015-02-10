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
{include file="../../templates/menuHaut.tpl"}
{if isset($selecteur)}
	{include file="$selecteur.tpl"}
{/if}
<img src="../images/bigwait.gif" id="wait" style="display:none" alt="wait">

<div class="attention">
{if isset($message)}
<span class="title">{$message.title}</span>
<span class="texte">{$message.texte}</span>
<span class="icon">{$message.icon|default:''}</span>
{/if}
</div>

{* La valeur de $corpsPage est définie dans index.php ou les sous-modules php *}
{if isset($corpsPage)}
	{include file="$corpsPage.tpl"}
{/if}
{include file="../../templates/footer.tpl"}

<script type="text/javascript">

$(document).ready (function() {

	$(".attention").hide();

	if ($(".attention .texte").html() != null) {
		$.growlUI(
			$(".attention .title").html(),
			$(".attention .texte").html(),
			3000
		)
	}

	// selectionner le premier champ de formulaire dans le corps de page ou dans le sélecteur si pas de corps de page
	if ($("#corpsPage form").length != 0)
		$("#corpsPage form :input:visible:enabled").first().focus();
		else
		$("form :input:visible:enabled:first").focus();

	$("*[title], .tooltip").tooltip();

	$( ".draggable" ).draggable();

	$("input").not(".autocomplete").attr("autocomplete","off");

})

</script>

</body>
</html>
