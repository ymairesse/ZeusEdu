<h3>Liste des utilisateurs du module</h3>

<table class="tableauAdmin">
	<tr>
	<th>&nbsp;</th>
	<th>Nom</th>
	<th>Statut</th>
	<th>&nbsp;</th>
	</tr>
{foreach from=$usersList key=cetAcronyme item=user}
	<tr>
		<td>
			{if $cetAcronyme != $acronyme}
			<a href="index.php?action=users&amp;mode=delUser&amp;acronyme={$cetAcronyme}"><img src="images/suppr.png" alt="X" title="Supprimer"></a>
			{else}
				&nbsp;
			{/if}
		</td>

		<td>
		{$user.nomPrenom}</a>
		</td>
		<td>{$user.status}</td>
		<td>
			{if $cetAcronyme != $acronyme}
			<a href="index.php?action=users&amp;mode=editUser&amp;acronyme={$cetAcronyme}"><img src="images/editer.png" alt="edit" title="Modifier"></a>
			{else}
				&nbsp;
			{/if}
		</td>
	</tr>
{/foreach}
</table>

