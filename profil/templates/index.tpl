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

	{if (isset($message))}
	<div class="alert alert-dismissable alert-{$message.urgence|default:'info'}
		{if (!(in_array($message.urgence,array('danger','warning'))))} auto-fadeOut{/if}">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
		<h4>{$message.title}</h4>
		<p>{$message.texte}</p>
	</div>
	{/if}

</div>  <!-- container -->

<img src="../images/bigwait.gif" id="wait" style="display:none" alt="wait">

{* La valeur de $corpsPage est définie dans index.php ou les sous-modules php *}
<div id="corpsPage">
{if isset($corpsPage)}
	{include file="$corpsPage.tpl"}
{else}
	{include file="../../templates/corpsPageVide.tpl"}
{/if}
</div>

{include file="../../templates/footer.tpl"}

<script type="text/javascript">
	
window.setTimeout(function() {
    $(".auto-fadeOut").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove(); 
	    });
	}, 3000);


$(document).ready (function() {

	// selectionner le premier champ de formulaire dans le corps de page ou dans le sélecteur si pas de corps de page; sauf les datepickers
	if ($("#corpsPage form").length != 0)
		$("#corpsPage form input:visible:enabled").not('.datepicker').first().focus();
		else
		$("form input:visible:enabled").not('.datepicker').first().focus();
		
	$("*[title]").tooltip();
	
	$(".pop").popover({
		trigger:'hover'
		});
	$(".pop").click(function(){
		$(".pop").not(this).popover("hide");
		})
		
	$("input").not(".autocomplete").attr("autocomplete","off");
	
})

</script>

</body>
</html>
