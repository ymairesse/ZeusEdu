<select name="matricule" id="selectEleve" class="form-control">
	<option value="">Choisir un élève</option>
	{foreach from=$listeEleves key=leMatricule item=unEleve}
	<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected{/if}>{$unEleve}</option>
	{/foreach}
</select>
