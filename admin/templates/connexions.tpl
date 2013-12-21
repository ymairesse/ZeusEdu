<table class="tableauAdmin">
	<tr>
		<th>User</td>
		<th>Date</td>
		<th>Heure</td>
		<th>Accès</th>
	</tr>
	{foreach from=$derniersConnectes item=unNom}
	<tr>
		<td>{$unNom.user}</td>
		<td>{$unNom.date|date_format:"%d/%m/%Y"}</td>
		<td>{$unNom.heure}</td>
		<td title="{$unNom.ip}">{$unNom.host}</td>
	</tr>
	{/foreach}
</table>
