<h2>{$eleve.nom} {$eleve.prenom}</h2>
<p id="photoEleve"><img src="../photos/{$eleve.photo}.jpg" alt="{$matricule}" title="{$eleve.nom }{$matricule}" height="140px" 
	style="position:absolute;right:0;top:-110px;cursor:pointer" class="photo draggable"></p>
<form name="form" method="POST" action="index.php" id="formulaire">
<input type="hidden" name="action" value="delibes">
<input type="hidden" name="mode" value="individuel">
<input type="hidden" name="etape" value="enregistrer">
<input type="hidden" name="classe" value="{$classe}">
<input type="hidden" name="matricule" value="{$matricule}">
<table class="tableauAdmin">
	<tr>
		<th>Cours</th>
		<th>&nbsp;</th>
		<th style="width:4em">Déc.</th>
		<th style="width:4em">Juin</th>
		<th style="width:30%">Remarque Déc</th>
		<th style="width:30%">Remarque Juin</th>
	</tr>

	{foreach from=$listeCours key=coursGrp item=unCours}
		<tr class="{$unCours.statut}">
		<td style="width:30%" class="tooltip" title="{$unCours.libelle} -> {$unCours.prenom} {$unCours.nom}">
				 {$unCours.statut}: {$unCours.libelle}</td>
		<td>{$unCours.nbheures}h</td>
		{foreach from=$listePeriodes item=periode}
			<td class="cote 
				{if ($listeSituations.$coursGrp.$periode.sitDelibe < 50) && ($listeSituations.$coursGrp.$periode.sitDelibe|trim != '') }echec{/if}">
				{$listeSituations.$coursGrp.$periode.sitDelibe|default:'&nbsp;'}</td>
		{/foreach}
		
		<td class="remarqueDelibe" title="{$listeRemarques.$matricule.$coursGrp.2|default:''}">
			{$listeRemarques.$matricule.$coursGrp.2|default:'&nbsp;'|truncate:80}</td>
		<td class="remarqueDelibe" title="{$listeRemarques.$matricule.$coursGrp.5|default:''}">
			{$listeRemarques.$matricule.$coursGrp.5|default:'&nbsp;'|truncate:80}</td>
		</tr>
	{/foreach}
	
	<tr class="conclusionDelibe">
		<td>Moyennes</td>
		<td>&nbsp;</td>
		<td class="cote {if {$delibe[2].moyenne} && {$delibe[2].moyenne} < 50}echec{/if}">
			<strong>{$delibe[2].moyenne|default:'&nbsp;'}</strong>
		</td>
		<td class="cote {if {$delibe[5].moyenne} && {$delibe[5].moyenne} < 50}echec{/if}">
			<strong>{$delibe[5].moyenne|default:'&nbsp;'}</strong></td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="conclusionDelibe">
		<td>Nb Echecs</td>
		<td>&nbsp;</td>
		<td class="cote">
		{if $delibe[2].nbEchecs > 0}
			<strong>{$delibe[2].nbEchecs}</strong>
			{else}
			&nbsp;
		{/if}	
		</td>
		<td class="cote">
		{if $delibe[5].nbEchecs > 0}
			<strong>{$delibe[5].nbEchecs}</strong>
			{else}
			&nbsp;
		{/if}
		</td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="conclusionDelibe">
		<td>Nb Heures Echec</td>
		<td>&nbsp;</td>
		<td class="cote">
		{if $delibe[2].nbHeuresEchec > 0}
			<strong>{$delibe[2].nbHeuresEchec}h</strong>
		{else}
		&nbsp;
		{/if}
		</td>
		<td>
		{if $delibe[5].nbHeuresEchec > 0}
			<strong>{$delibe[5].nbHeuresEchec}h</strong>
		{else}
		&nbsp;
		{/if}
		</td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="conclusionDelibe">
		<td>Cours en échec (déc)</td>
		<td>&nbsp;</td>		
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="2" style="font-size:0.8em">{if $delibe[2].nbHeuresEchec > 0}{$delibe[2].cours}{else}&nbsp;{/if}</td>
	</tr>
	<tr class="conclusionDelibe">
		<td>Cours en échec (juin)</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="2" style="font-size:0.8em">{if $delibe[5].nbHeuresEchec > 0}{$delibe[5].cours}{else}&nbsp;{/if}</td>
	</tr>
	<tr class="conclusionDelibe">
		<td>Mention Initiale</td>
		<td>&nbsp;</td>
		<td class="cote"><strong>{$mentions[2]|default:'&nbsp;'}</strong></td>
		<td class="cote"><strong>{$mentions[5]|default:'&nbsp;'}</strong></td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="conclusionDelibe" style="background-color:#FCD97D">
		<td>Mention Finale</td>
		<td>
		{if $estTitulaire}
			<img src="images/lock.png" alt="X" id="lock" style="float:right; cursor:pointer">
		{else}
			&nbsp;
		{/if} 
		</td>
		{foreach from=$listePeriodes item=periode}
			<td class="cote {if isset($mentionsAttribuees.$periode) && $mentionsAttribuees.$periode == 'I'} echec{/if}">
				{if $estTitulaire}
				<input type="text" name="mentions_{$periode}" value="{$mentionsAttribuees.$matricule.$annee.$periode|default:''}" 
						class="inputMention" size="3" maxlength="6">
				{else}
					<strong>{$mentionsAttribuees.$matricule.$annee.$periode|default:'&nbsp;'}</strong>
				{/if}
			</td>
		{/foreach}

		<td colspan="2">
		{if $estTitulaire}
			<input type="submit" name="submit" value="Enregistrer" id="submit">
			<input type="reset" name="annuler" id="annuler" value="Annuler">
		{else}
			&nbsp; 
		{/if}
		</td>
	</tr>
</table>
</form>

<script type="text/javascript">
{literal}
var modifie = false;
var locked = true;
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
	
	function modification () {
	if (!(modifie)) {
		modifie = true;
		window.onbeforeunload = function(){
			return confirm (confirmationBeforeUnload);
		}}
	}
	
	$(document).ready(function(){
	
	$("#photoEleve").draggable();
	
	$(".inputMention").each(function(index){
			$(this).attr("readonly",true);
		});
	$("#submit").hide();
		
	$(".inputMention").keyup(function(e){
	var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
	if ((key > 31) || (key == 8)) {
		modification();
		$(this).val($(this).val().toUpperCase());
		}
	})
	
	$("#lock").click(function(){
		if (locked) {
			$(".inputMention").attr("readonly",false);
			$(this).attr("src", "images/unlock.png");
			$("#submit").show();
			}
			else {
			$(".inputMention").attr("readonly",true);
			$(this).attr("src", "images/lock.png");
			$("#submit").show();
			};
		locked = !(locked);
		})

	$("#submit").click(function(){
		$(this).val("Un moment").addClass("patienter");
		$(this).next().html("<img src='../images/wait.gif' alt='wait'>");
		window.onbeforeunload = function(){};
		$.blockUI();
		$("#wait").show();
	})
	
	$("#annuler").click(function(){
	if (confirm(confirmationReset)) {
		$("#formulaire")[0].reset();
		modifie = false;
		window.onbeforeunload = function(){};
		return false
	}
	})
	
	})
{/literal}
</script>
