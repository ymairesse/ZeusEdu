{if isset($listeElevesAdd)}
<select name="listeElevesAdd[]" id="listeElevesAdd" size="20" multiple="multiple" class="form-control">
	{foreach from=$listeElevesAdd key=leMatricule item=unEleve}
	<option value="{$leMatricule}" title="{$leMatricule}">{$unEleve.classe} {$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
{/if}
