<div class="container-fluid">
<h2>Connexion entre {$dateDebut} et le {$dateFin} [ {$listeConnexions|@count} ]</h2>

{if $listeConnexions|@count > 0}
<table class="table table-hover table-striped">

{foreach from=$listeConnexions key=userName item=unEleve}
	<tr>
		<th colspan="5" style="text-align:left">{$unEleve[0].groupe} - {$unEleve[0].nom} {$unEleve[0].prenom}</th>
	</tr>
	<tr>
		<td>Date</td>
		<td>Heure</td>
		<td>IP</td>
		<td>hôte</td>
	</tr>
	{foreach from=$unEleve item=uneConnexion}
		<tr>
			<td>{$uneConnexion.date}</td>
			<td>{$uneConnexion.heure}</td>
			<td>{$uneConnexion.ip}</td>
			<td>{$uneConnexion.host}</td>
		</tr>
	{/foreach}

{/foreach}
</table>
{else}
	<p>Aucune connexions entre le <strong>{$dateDebut}</strong> et le <strong>{$dateFin}</strong></p>
{/if}

</div>
