<h2>Listes des visites entre le {$dateDebut} et le {$dateFin}</h2>

{if $listevisites|@count > 0}
<table class="tableauAdmin">
	<tr>
	<th>Classe</th>
	<th>Nom de l'élève</th>
	<th>Heure</th>
	<th>Motif</th>
	<th>Traitement</th>
	<th>Suite</th>
	</tr>
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
				<a href="index.php?action=parEleve&matricule={$matricule}" class="tooltip">
					<div class="tip"><img src="../photos/{$matricule}.jpg" alt="{$matricule}" style="width:100px"></div>
					{$laVisite.nom} {$laVisite.prenom}</a>
				<a href="index.php?action=parEleve&matricule={$matricule}" target="_blank" title="Ouvrir dans une nouvelle fenêtre">
					<img src="../images/eleve.gif" alt="+" style="float:right; border:0"></a></td>
			<td>{$laVisite.heure}</td>
			<td title="{$laVisite.motif}">{$laVisite.motif|truncate:50|default:'&nbsp;'}</td>
			<td title="{$laVisite.traitement}">{$laVisite.traitement|truncate:25|default:'&nbsp;'}</td>
			<td title="{$laVisite.aSuivre}">{$laVisite.aSuivre|truncate:15|default:'&nbsp;'}</td>
			</tr>
		{/foreach}
		{if $visitesEleve|@count > 1} </tr>{/if}
	{/foreach}
{/foreach}
</table>
{else}
	<p>Aucune visite à l'infirmerie entre le <strong>{$dateDebut}</strong> et le <strong>{$dateFin}</strong></p>
{/if}
