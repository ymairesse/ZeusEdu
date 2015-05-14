<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{$titreApplication}</title>

<link rel="stylesheet" href="menu.css" type="text/css" media="screen">
<link rel="stylesheet" href="screen.css" type="text/css" media="screen">
<link rel="stylesheet" href="print.css" type="text/css" media="print">

<script type="text/javascript" src="js/jquery-2.1.3.min.js"></script>
<link type="text/css" media="all" rel="stylesheet" href="bootstrap/css/bootstrap.css">
<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>

</head>

<body>

{if isset($avertissementIP)	}
	{include file="avertissementIP.tpl"}
{/if}

<div class="vertical-align">

	<div class="container">
		{if isset($alias)}
		<span class="glyphicon glyphicon-star" style="color:red"></span>
		{/if}

		<div class="col-md-offset-2 col-md-9 col-sm-12 col-xs-12">
			
			{foreach from=$applisDisponibles key=k item=v}
				<div class="sousPrg btn btn-primary" title="{$v.nomLong}">
					<a href="{$v.URL}"><img src="images/{$v.icone}" alt="{$k}" style="float:left">
					<span class="titreSousPrg">{$v.nomLong}</span></a>
				</div>
			{/foreach}
	
			<div id="titreAppli" style="clear:both">{$titre}</div>

		</div>  <!-- col-md... -->

	</div>  <!-- container -->

</div>

{include file="footer.tpl"}

<script type="text/javascript">

var titreGeneral = $("#titreAppli").text();

$(document).ready(function(){

	$(".sousPrg").mouseenter(function(){
		var texte = $(this).attr("title");
		$("#titreAppli").html(texte);
		}).mouseleave(function(){
			$("#titreAppli").html(titreGeneral);
			})		

	$(".sousPrg").click(function(){
		var link = $(this).children('a').attr('href');
		window.location.assign(link+"/index.php");
		})

})

</script>
</body>
</html>
