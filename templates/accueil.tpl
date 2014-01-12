<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>{$titre}</title>

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

</head>
<body>
<div id="javascriptOff">
	<h3>Attention!</h3>
	<p>vous avez désactivé Javascript dans votre navigateur.</p>
	<p><strong>L'application ne fonctionnera pas!!</strong></p>
	<p><strong>Veuillez réactiver Javascript ou contacter votre administrateur.</strong></p>
</div>
<fieldset style="display: none; width:45em;" id="cadreFieldset" class="photo">
    <legend>Veuillez vous identifier</legend>
    <h1>{$titre}</h1>
    <form autocomplete="off" method="post" id="login" action="login.php" name="login">
        <p><label for="acronyme">Utilisateur</label>
        <input maxlength="3" size="5" name="acronyme" id="acronyme" tabindex="1" title="Au moins trois caractères">
        </p>
        <p><label for="mdp">Mot de passe</label>
        <input maxlength="20" size="10" name="mdp" id="mdp" type="password" tabindex="2" title="Au moins six caractères"></p>
        <p><a href="javascript:void(0)" id="renvoimdp" title="Récupérer un mot de passe">Ciel! J'ai oublié mon mot de passe</a></p>
        <p style="text-align: center"> <input value="Entrer" type="submit" tabindex="3" /></p>
    </form>
	
	<div id="dialogueRenvoiMdp" title="Nouveau mot de passe">
		<p>Voulez-vous recevoir un nouveau mot de passe pour <strong id="acro"></strong> sur votre adresse e-mail professionnelle?</p>
	</div>

<fieldset>
	<legend> Avertissement!</legend> 
	<p style="color:red"><img src="images/attention.png" alt="/!\" style="float:left; padding-right:1em">
	<P class="tooltip">
		<span class="tip">"Celui qui, sachant qu'il n'y est pas autorisé, accède à un système informatique ou s'y maintient, est puni d'un emprisonnement de trois mois à un an et d'une amende de vingt-six [euros] à vingt-cinq mille [euros] ou d'une de ces peines seulement."<br>(voir http://www.ejustice.just.fgov.be).</span>
	Cette application gère des données privées et strictement confidentielles. Toute tentative d'accès sans autorisation est punissable au sens de la loi 
	(<a href="http://www.ejustice.just.fgov.be/cgi_loi/change_lg.pl?language=fr&la=F&table_name=loi&cn=1867060801" target="_blank">Art. 550 bis du Code Pénal</a>).</p>
	<p>Votre adresse IP: <strong>{$identification.ip}</strong> {$identification.hostname}. Votre passage est enregistré.</p>
</fieldset>

	<div id="alertUserName" title="Erreur">
		Veuillez fournir votre nom d'utilisateur
	</div>
	
	<div id="inconnu" title="Erreur"></div>
	
	<div id="messageErreur" title="Erreur">
		<p>Nom d'utilisateur ou mot de passe incorrect</p>
		<p>Votre tentative d'accès, votre adresse IP et le nom de votre fournisseur d'accès ont été enregistrés.</p>
		<p>Les administrateurs ont été prévenus.</p>
	</div>	

{include file="footer.tpl"}
<script type="text/javascript">
{literal}
var close = "Fermer";

$(document).ready (function() {
	
	$("#javascriptOff").hide();
	$("#cadreFieldset").show();
	$("#cadreFieldset").vAlign().hAlign();
	
	$("input:enabled").eq(0).focus();
	
	$("#login").validate({
		rules: {
			acronyme: {required:true, minlength:3},
			mdp: {required:true,minlength:6}
			},
		errorElement: "span"
		});
	
	$("#alertUserName").dialog({
		autoOpen: false,
		modal: true,
		closeText: close,
		buttons: {
			"OK": function(){
				$(this).dialog("close");
				}
			}
		})
	
	$("#messageErreur").dialog({
		autoOpen: false,
		modal: true,
		width: 500,
		closeText: close,
		buttons: {
			"Ok": function() {
				$(this).dialog("close");
				}
		}
		})
	$("#inconnu").dialog({
		autoOpen: false,
		modal: true,
		closeText: close,
		buttons: {
			"Ok": function() {
				$(this).dialog("close");
				}
			}
		})
	
	
	$("#renvoimdp").click(function(){
		var acronyme = $("#acronyme").val().toUpperCase();
		if (acronyme == "")
			$("#alertUserName").dialog("open");
			else {
				$("#acro").text(acronyme);
				$("#dialogueRenvoiMdp").dialog("open");
				}
		return false;
		});

	$("#dialogueRenvoiMdp").dialog({
		autoOpen: false,
		width: 500,
		buttons: {
			"Non": function() {
				$(this).dialog("close");
				},
			"Oui": function() {
				var acronyme = $("#acronyme").val();
				$.get('inc/renvoimdp.inc.php',
					  {'acronyme': acronyme.toUpperCase()},
					  function (resultat) {
						$("#inconnu").text(resultat);
						$("#inconnu").dialog("open");
						}
					  )
				$(this).dialog("close");
				}
			}
		})
		
	$("*[title], .tooltip").tooltip();
		
	var erreur = document.location.search;
	if (erreur.indexOf("faux") > 0)
		$("#messageErreur").dialog("open");
		
	})
{/literal}
</script>
</body>
</html>
