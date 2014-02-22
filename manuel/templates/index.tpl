<!doctype html>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
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
	location.href = "#{$cible}";
	
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
