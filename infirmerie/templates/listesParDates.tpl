<h2>Listes des visites entre le {$dateDebut} et le {$dateFin}</h2>

{if $listeVisites|@count > 0}

	<table class="table table-hover table-striped">
		<thead>
			<tr>
			<th>Classe</th>
			<th>Nom de l'élève</th>
			<th style="width:1em;">&nbsp;</th>
			<th>Heure</th>
			<th>Motif</th>
			<th>Traitement</th>
			<th>Suite</th>
			</tr>
		</thead>
	{foreach from=$listeVisites key=date item=lesEleves}
		<tr>
			<th colspan="7" style="text-align:left">Le {$date|date_format:'%d/%m/%Y'}</th>
		</tr>
		{foreach from=$lesEleves key=matricule item=visitesEleve}
			{if $visitesEleve|@count > 1} <tr>{/if}
			{foreach from=$visitesEleve key=consultID item=laVisite}
				<tr>
				<td>{$laVisite.classe}</td>
				<td>
					<a class="linkFiche"
						data-toggle="tooltip"
						data-title="<img src='../photos/{$listePhotos.$matricule}.jpg' alt='{$matricule}' style='width:100px'>"
						data-placement="right"
						data-container="body"
						data-html="true"
						data-matricule="{$matricule}"
						data-groupe="{$laVisite.classe}"
						href="index.php?action=wtf" target="_blank">
						{$laVisite.nom} {$laVisite.prenom}
					</a>
				</td>
				<td>
					<button type="button"
						class="btn btn-primary btn-xs btn-eleveInf"
						title="Vue popup"
						data-matricule="{$matricule}">
						<i class="fa fa-user"></i>
					</button>
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


<script type="text/javascript">

	$(document).ready(function(){

		$('[data-toggle="tooltip"]').tooltip();

	})

</script>
