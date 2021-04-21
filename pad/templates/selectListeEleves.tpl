
<div class="form-group">
<select name="matricule[]" id="selectEleve" class="form-control" multiple style="min-height:35em; overflow:auto;">
	{foreach from=$listeEleves key=leMatricule item=unEleve}
	<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected="selected"{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
</div>
