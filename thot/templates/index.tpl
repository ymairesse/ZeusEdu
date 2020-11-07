<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{$titre}</title>

{include file='../../javascript.js'}
{include file='../../styles.sty'}

<script src="js/fbLike/facebook-reactions.js"></script>
<link rel="stylesheet" href="js/fbLike/stylesheet.css" media="screen">
<link rel="stylesheet" href="css/filetree.css" type="text/css">

<style type="text/css">


#fichiersIcones .conteneur {
	float: left;
	padding: 0 1em;
	margin: 0.5em;
	cursor: pointer;
	word-wrap: break-word;
	width: 8em;
	height: 8em;
	overflow: auto;
	}

#fichiersIcones  .nomFichier {
	font-size: 9pt;
	width: 10em;
	}

#fichiersIcones .conteneur a {
	font-weight: normal;
	color: #00f;
}

#fichiersIcones  .fileImage {
	background-image: url('images/file.png');
	background-repeat: no-repeat;
	background-position: center;
	height: 4em;
	width: 4em;
	}

/* #fichiersIcones  .conteneur .ext_pdf {
	background-image: url('css/images/pdf.png');
	background-repeat: no-repeat;
	background-position: center;
	background-size: 100%;
	height: 4em;
	width: 4em;
} */

#fichiersIcones  .folderImage {
	background-image: url('images/folder.png');
	background-repeat: no-repeat;
	background-position: center;
	height: 4em;
	width: 4em;
	}

#fichiersIcones  .fileName {
	width: 8em;
	font-size: 8pt;

}

#fichiersIcones  .conteneur.active {
	background-color: #cce;
}

</style>

</head>
<body>

{include file="menu.tpl"}

<div class="container-fluid">

	{if isset($selecteur)}
		{include file="$selecteur.tpl"}
	{/if}

	{if (isset($message))}
	<div class="alert alert-dismissable alert-{$message.urgence|default:'info'}
		{if (!(in_array($message.urgence,array('danger','warning'))))} auto-fadeOut{/if}">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
		<h4><span class="glyphicon
			{if in_array($message.urgence,array('success','info'))}glyphicon-ok{/if}
			{if in_array($message.urgence,array('danger','warning'))}glyphicon-exclamation-sign{/if}
			"></span> {$message.title}</h4>
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

setTimeout(function() {
    $(".auto-fadeOut").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove();
	    });
	}, 3000);

$(document).ready (function() {

	// selectionner le premier champ de formulaire dans le corps de page ou dans le sélecteur si pas de corps de page; sauf les datepickers
	if ($("#corpsPage form").length != 0)
		$("#corpsPage form input:visible:enabled").not('.datepicker,.timepicker').first().focus();
		else
		$("form input:visible:enabled").not('.datepicker,.timepicker').first().focus();

	$("*[title]").tooltip();

	$(".pop").popover({
		trigger:'hover'
		});

	$(".pop").click(function(){
		$(".pop").not(this).popover("hide");
		})

	$("input").tabEnter();

	$("input").not(".autocomplete").attr("autocomplete","off");

})

</script>

</body>
</html>
