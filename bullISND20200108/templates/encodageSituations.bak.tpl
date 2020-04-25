<script type="text/javascript">
{literal}
$(document).ready(function(){
	$("input").tabEnter();
	});
{/literal}
</script>
<span style="display:none"><img src="../images/wait.gif" alt="wait"></span>
<h2 title="cours {$intituleCours.cours_ID} - {$intituleCours.option}">Bulletin {$bulletin} - 
	{$intituleCours.nom} {$intituleCours.heures}h -> {$intituleCours.classes}</h2>

<form name="situations" id="situations" action="index.php" method="POST">
	<input type="reset" name="annuler" id="annuler" value="Annuler">
	<input type="submit" name="enregistrer" id="enregistrer" value="Enregistrer">
	<input type="hidden" name="action" value="gestSituations">
	<input type="hidden" name="mode" value="enregistrer">
	<input type="hidden" name="bulletin" value="{$bulletin}">
	<input type="hidden" name="cours" value="{$cours}">

<table class="tableauBull">
<tr>
	<th>Classe</th>
	<th>Nom de l'élève</th>
	<th>Situation %</th>
	<th>Examen %</th>
	<th>Proposition<br>Étoile</th>
	<th>Crochets</th>
	<th>Situation<br>délibé %</th>
</tr>
{foreach from=$listeEleves key=eleve_ID item=unEleve}
	{assign var="cours_ID" value=$unEleve.cours_ID}
	<tr>
		<td>{$unEleve.classe_nom}</td>
		<td>{$unEleve.nom_eleve}</td>
		<td class="{$listeSituations.$eleve_ID.$bulletin.echec}">{$listeSituations.$eleve_ID.$bulletin.pourcent|number_format:1} </td>
		<td>
			{if $listeCotesExamen.$eleve_ID != '-'}
				{$listeCotesExamen.$eleve_ID|number_format:1}
			{else} 
				{$listeCotesExamen.$eleve_ID}
			{/if}
		<td>{if $listeCotesExamen.$eleve_ID > $listeSituations.$eleve_ID.$bulletin.pourcent}
			<input type="checkbox" name="etoile_eleve-{$eleve_ID}_cours-{$cours_ID}" 
				value="{$listeCotesExamen.$eleve_ID}*">
			{$listeCotesExamen.$eleve_ID} *
			{else}&nbsp;
			{/if}
		</td>
		<td><input type="checkbox" name="crochet_eleve-{$eleve_ID}_cours-{$cours_ID}" value="[]">[]</td>
		<td><input size="5" type="text" name="sitDelibe_eleve{$eleve_ID}_cours_{$COURS_id}" value=""></td>
	</tr>
{/foreach}
</table>

</form>

