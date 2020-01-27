<h3 style="clear:both">La table "{$table}" va être vidée: veuillez confirmer</h3>
<form method="POST" action="{$smarty.server.SCRIPT_NAME}">
	<input name="mode" value="Confirmer" type="submit">
	<input name="mode" value="Annuler" type="reset" onclick="javascript:history.go(-1)">
	<input name="table" value="{$table}" type="hidden">
	<input name="action" value="clear" type="hidden">
</form>
<hr />
<h4>Contenu actuel de la table <strong>"{$table}"</strong></h4>
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
