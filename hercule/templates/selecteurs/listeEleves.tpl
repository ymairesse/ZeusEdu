{if isset($listeEleves)}

<select name="matricule" id="selectEleve" class="form-control">
	<option value="">Choisir un élève</option>
	{if isset($listeEleves)}
		{foreach from=$listeEleves key=leMatricule item=unEleve}
		<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
		{/foreach}
	{/if}
</select>

{/if}
