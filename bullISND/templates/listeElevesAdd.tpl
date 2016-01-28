{if isset($listeElevesAdd)}
<select name="listeElevesAdd[]" id="listeElevesAdd" size="20" multiple="multiple" style="width:20em">
	{foreach from=$listeElevesAdd key=leMatricule item=unEleve}
	<option value="{$leMatricule}" title="{$leMatricule}">{$unEleve.classe} {$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
{/if}
