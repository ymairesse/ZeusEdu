<div class="container">
<h2>Listes des visites entre le {$dateDebut} et le {$dateFin}</h2>

{if $listevisites|@count > 0}
<table class="table table-hover table-striped">
	<thead>
		<tr>
		<th>Classe</th>
		<th>Nom de l'élève</th>
		<th>Heure</th>
		<th>Motif</th>
		<th>Traitement</th>
		<th>Suite</th>
		</tr>
	</thead>
{foreach from=$listevisites key=date item=lesEleves}
	<tr>
		<th colspan="6" style="text-align:left">Le {$date|date_format:'%d/%m/%Y'}</th>
	</tr>
	{foreach from=$lesEleves key=matricule item=visitesEleve}
		{if $visitesEleve|@count > 1} <tr>{/if}
		{foreach from=$visitesEleve key=consultID item=laVisite}
			<tr>
			<td>{$laVisite.classe}</td>
			<td>
				<form role="form" action="index.php" method="POST"
					class="popover-eleve microForm"
					data-container="body"
					data-html="true"
					data-content="<img src='../photos/{$matricule}.jpg' alt='{$matricule}' style='width:100px'>"
					>
					<button type="submit" class="btn btn-link">{$laVisite.nom} {$laVisite.prenom}</button>
					<input type="hidden" name="action" value="ficheEleve">
					<input type="hidden" name="matricule" value="{$matricule}">
				</form>
			</td>
			<td>{$laVisite.heure}</td>
			<td class="popover-eleve"
				data-container="body"
				data-html="true"
				data-placement="left"
				data-content="{$laVisite.motif}">
					{$laVisite.motif|truncate:50|default:'&nbsp;'}
			</td>
			<td class="popover-eleve"
				data-container="body"
				data-html="true"
				data-placement="left"
				data-content="{$laVisite.traitement}">
				{$laVisite.traitement|truncate:25|default:'&nbsp;'}
			</td>
			<td class="popover-eleve"
				data-container="body"
				data-html="true"
				data-placement="left"
				data-content="{$laVisite.aSuivre}">
				{$laVisite.aSuivre|truncate:15|default:'&nbsp;'}
			</td>
			</tr>
		{/foreach}
		{if $visitesEleve|@count > 1} </tr>{/if}
	{/foreach}
{/foreach}
</table>
{else}
	<p>Aucune visite à l'infirmerie entre le <strong>{$dateDebut}</strong> et le <strong>{$dateFin}</strong></p>
{/if}

</div>


<script type="text/javascript">

	$(document).ready(function(){

	$(".popover-eleve").mouseover(function(){
		$(this).popover('show');
		})
	$(".popover-eleve").mouseout(function(){
		$(this).popover('hide');
		})

	})

</script>
