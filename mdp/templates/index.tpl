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

		{* La valeur de $corpsPage est définie dans index.php ou les sous-modules php *}
		<div id="corpsPage">
		{if isset($corpsPage)}
			{include file="$corpsPage.tpl"}
		{/if}
		</div>

	</div>  <!-- container -->

{include file="../../templates/footer.tpl"}

<script type="text/javascript">

window.setTimeout(function() {
	$(".auto-fadeOut").fadeTo(500, 0).slideUp(500, function(){
		$(this).remove();
		});
	}, 3000);

$(document).ready (function() {

	$("input:enabled").eq(0).focus();

	$("*[title]").tooltip();

	$(".pop").popover({
		trigger:'hover'
		});

})

</script>

</body>

</html>
