<div id="resultat">
<h3 style="clear:both" title="{$infoPerso.matricule}">
	{$infoPerso.nom} {$infoPerso.prenom} : {$infoPerso.classe} | Bulletin n° {$bulletin}</h3>
	<span class="fauxBouton couleur">Désactiver la couleur</span>
<div id="tabsul">
	<ul>
		<li><a href="#tabs-cotes">Cotes</a></li>
		{if $attitudes}
			<li><a href="#tabs-attitudes">Attitudes</a></li>
		{/if}		
		<li><a href="#tabs-remarques">Remarques toutes périodes</a></li>
	</ul>
	
	<div id="tabs-cotes">
		{include file="tabCotes.tpl"}
	</div>
	
	{if isset($attitudes)}
	<div id="tabs-attitudes">
		{include file="tabAttitudes.tpl"}
	</div>
	{/if}
	
	<div id="tabs-remarques">
		<table class="tableauTitu" style="width:100%">
			<tr>
			<th style="width:3em">Bulletin</th>
			<th style="text-align:center">Remarques</th>
			</tr>
		{foreach from=$listePeriodes item=periode}
			<tr>
				<th>{$periode}</th>
				<td style="font-size:0.8em; padding:0.4em 1em">{$listeRemarquesTitu.$matricule.$periode|default:'&nbsp;'}</td>
			</tr>
		{/foreach}
		</table>
	</div>
</div>
<hr style="clear:both">
	<form name="avisTitu" id="avisTitu" action="index.php" method="POST" style="border-radius: 15px; box-shadow: 1px 1px 12px #555;">
	<img src="../photos/{$infoPerso.photo}.jpg" title="{$infoPerso.matricule}" alt="{$infoPerso.matricule}"
		style="width: 100px; float:right" class="photo">
	<h4>Avis du titulaire et du Conseil de Classe pour la période {$bulletin}</h4>
		{if isset($mentions.$matricule.$annee.$bulletin)}
		<p>Mention accordée <strong>{$mentions.$matricule.$annee.$bulletin|default:'-'}</strong>.</p>
		{/if}
		 <textarea name="commentaire" id="commentaire" rows="7" cols="80">{$remarqueTitu|default:'&nbsp;'}</textarea>
			  <br>
			  <input type="submit" name="Enregistrer" value="Enregistrer" id="enregistrer">
			  <input type="reset" name="Annuler" value="Annuler"><br>
			  <input type="hidden" name="action" value="titu">
			  <input type="hidden" name="mode" value="remarques">
			  <input type="hidden" name="etape" value="enregistrer">
			  <input type="hidden" name="bulletin" value="{$bulletin}">
			  <input type="hidden" name="matricule" value="{$matricule}">
			  <input type="hidden" name="classe" value="{$classe}">
	</form>
</div>

<script type="text/javascript">
var periode={$bulletin};
{literal}
	$(document).ready(function(){

	$(".photo").draggable();
	
	$("#tabsul").tabs();

	$("#tabsAttitudes").tabs().show();
	$('#tabsAttitudes').tabs( "option", "active", periode-1);
	 
	 $("#avisTitu").submit(function(){
		$.blockUI();
		$("#wait").show();
		})
		
	$(".couleur").click(function(){
		if ($(this).text() == 'Désactiver la couleur') {
			$(".mentionS").removeClass("mentionS").addClass("xmentionS");
			$(".mentionAB").removeClass("mentionAB").addClass("xmentionAB");
			$(".mentionB").removeClass("mentionB").addClass("xmentionB");
			$(".mentionBplus").removeClass("mentionBplus").addClass("xmentionBplus");
			$(".mentionTB").removeClass("mentionTB").addClass("xmentionTB");
			$(".mentionTBplus").removeClass("mentionTBplus").addClass("xmentionTBplus");
			$(".mentionE").removeClass("mentionE").addClass("xmentionE");
			$(this).text("Activer la couleur");
			}
			else {
				$(".xmentionS").removeClass("xmentionS").addClass("mentionS");
				$(".xmentionAB").removeClass("xmentionAB").addClass("mentionAB");
				$(".xmentionB").removeClass("xmentionB").addClass("mentionB");
				$(".xmentionBplus").removeClass("xmentionBplus").addClass("mentionBplus");
				$(".xmentionTB").removeClass("xmentionTB").addClass("mentionTB");
				$(".xmentionTBplus").removeClass("xmentionTBplus").addClass("mentionTBplus");
				$(".xmentionE").removeClass("xmentionE").addClass("mentionE");
				$(this).text("Désactiver la couleur");
				}
		})
	})
{/literal}

</script>
