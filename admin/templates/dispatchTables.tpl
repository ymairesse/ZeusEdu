<h1>Attribution des tables aux applications</h1>
<form name="dispatchTables" method="POST" action="index.php">
	<input type="submit" name="submit" value="Enregistrer">
	<input type="reset" name="reset" value="Annuler">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
<table class="tableauBull">
	<tr>
		<th>Nom de la table</th>
		<th>Application</th>
	</tr>
	{foreach from=$listeAssocTablesEtApplis key=nomTable item=appli}
	<tr{if $appli == Null} class="erreur"{/if}>
		<td>{$nomTable}</td>
		<td>
			<select name="table_{$nomTable}"
			{foreach from=$listeApplis key=cetteAppli item=details}
				<option value="{$cetteAppli}"{if $cetteAppli == $appli} selected="selected"{/if}>{$details.nomLong}</option>
			{/foreach}
			</select>
		</td>
		{/foreach}
	</tr>
</table>
</form>