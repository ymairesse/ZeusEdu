<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<title>{$titre}</title>

{include file='../../javascript.js'}
{include file='../../styles.sty'}
<style type="text/css">
body {
	width:937px;
}
</style>
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
<span class="icon">{$message.icon}</span>
{/if}
</div>

{* La valeur de $corpsPage est définie dans index.php ou les sous-modules php *}
<div id="corpsPage">
{if isset($corpsPage)}
	{include file="$corpsPage.tpl"}
{/if}</div>
{include file="../../templates/footer.tpl"}

<script type="text/javascript">
{literal}
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
		if ($("#corpsPage").html() != '\n') 
			$("#corpsPage form :input:visible:enabled:first").focus();
			else 
			$("form :input:visible:enabled:first").focus();

	$("*[title], .tooltip").tooltip();
		
	$( ".draggable" ).draggable();
		
	$("input").not(".autocomplete").attr("autocomplete","off");
	
	$(".widget").hide();
	
	$(".widget").each(function(){
		if ($(this).hasClass("lift")) {
			var hauteur = $(this).height();
			$(this).attr("data-hauteur", $(this).height());
			$(this).css("height","150px");
			var titre = $(this).find("h1").append("<span class='minMax'>+</span>");
			}
		
		if ($(this).hasClass("w50")) 
			$(this).wrap("<div class='widget-outer-480' />");
			else $(this).wrap("<div class='widget-outer-980' />");
		$(this).parent().prepend(titre);
		})
	
	$(".widget").show();
		
	$(".minMax").click(function(){
		if ($(this).text() == '+') {
			var hauteur = $(this).parent().parent().find(".widget").data("hauteur");
			$(this).parent().parent().find(".widget").animate({"height": hauteur}, "slow");
			$(this).text('-');
			}
			else {
				$(this).text('+');
				$(this).parent().parent().find(".widget").animate({"height": "150px"}, "slow");
				}
		})
	
})
{/literal}
</script>

</body>
</html>
