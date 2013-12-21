<p><strong>Pas d'incompatibilité trouvée entre le fichiers CSV et la base de données.</strong></p>
<form name="form1" method="post" action="{$smarty.server.SCRIPT_NAME}">
	<p>Le fichier CSV a été transmis au serveur. Veuillez confirmer l'importation des données.</p>
	<p style="text-align:center">
	<input name="submit" value="Annuler" onclick="javascript:history.go(-1)" type="reset">
	<input name="table" value="{$table}" type="hidden">
	<input name="action" value="import" type="hidden">
	<input value="Confirmer" name="mode" type="submit"></p>
</form>
<hr />
<h4>Prévisualisation des données à importer</h4>
<table class="{$class}">
	<tr>
	{foreach from=$entete item=element}
		<th>{$element}</th>
	{/foreach}		
	</tr>

	{foreach from=$tableau item=ligne}
		<tr>{strip}
			{foreach from=$ligne item=element}
				<td>{$element}</td>
			{/foreach}
			{/strip}
		</tr>
	{/foreach}
</table>
