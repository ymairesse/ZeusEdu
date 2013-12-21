<h3>Activation/désactivation des applications</h3>
<table class="tableauAdmin">
	<tr>
		<th>Application</th>
		<th>Activée</th>
		<th>Enregistrement</th>
	</tr>
{foreach from=$enregistrement item=uneAppli}
	<tr bgcolor="{cycle values="#eeeeee,#d0d0d0"}">
		<td>{$uneAppli.nomLong}</td>
		<td style="text-align:center">{if $uneAppli.active}X{else}-{/if}</td>
		<td style="text-align:center">{$uneAppli.status}</td>
	</tr>
{/foreach}
</table>
