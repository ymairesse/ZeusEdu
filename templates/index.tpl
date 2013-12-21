<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<title>{$titreApplication}</title>

<link rel="stylesheet" href="menu.css" type="text/css" media="screen">
<link rel="stylesheet" href="screen.css" type="text/css" media="screen">
<link rel="stylesheet" href="print.css" type="text/css" media="print">
<link rel="stylesheet" href="js/jquery-ui-themes-1.10.3/themes/sunny/jquery-ui.css" media="screen, print">
<link rel="stylesheet" href="js/ymtooltip.css" type="text/css" media="screen,print">

<script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script type="text/javascript" src="js/jquery.enter2tab.js"></script>
<script type="text/javascript" src="js/toTop/jquery.ui.totop.js"></script>
<script type="text/javascript" src="js/menuBas.js"></script>
<script type="text/javascript" src="js/toTop/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.10.3/ui/minified/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/jquery.align.js"></script>
<script type="text/javascript" src="js/jquery.ymtooltip.js"></script>

<style type="text/css">
{literal}
#menu {	
	position: absolute;
	width: 800px;
	height: 640px;
	left: 50%;
	top: 40%;
	margin-left: -400px;
	margin-top: -160px;
}

{/literal}
</style>
<script type="text/javascript">
{literal}
$(document).ready(function(){
	var titreGeneral = $("#titreAppli").text();
	
	$(".sousPrg a img").mouseenter(function(){
		var texte = $(this).attr("title");
		$("#titreAppli").html(texte);
		}).mouseleave(function(){
			$("#titreAppli").html(titreGeneral);
			})
		
	});
{/literal}
</script>
</head>
<body>
<div id="texte">
<div id="menu">
	<ul>
	{foreach from=$applisDisponibles key=k item=v}
	{if $v.userStatus neq 'none'}
	<li class="sousPrg">
		<a href="{$v.URL}"><img src="images/{$v.icone}" alt="{$k}" title="{$v.nomLong}"></a>
	</li>
	{/if}
	{/foreach}
	</ul>
<div id="titreAppli" style="clear:both; display:block">{$titreApplication}</div>
</div>
</div>
{include file="footer.tpl"}
{if isset($avertissementIP)	}
	{include file="avertissementIP.tpl"}
{/IF}

<script type="text/javascript">
{literal}
	$(document).ready(function(){
		
		$("*[title], .tooltip").tooltip();
		
		$.blockUI.defaults.message = 'Veuillez patienter';
		
		$("#avertissement").dialog({
			modal: true,
			width: 400,
			buttons: {
				Ok: function() {
					$( this ).dialog("close" );
					}
				}
			});
		
		})
{/literal}
</script>
</body>
</html>
