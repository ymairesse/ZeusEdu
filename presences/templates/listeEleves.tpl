<select name="matricule" id="selectEleve">
	<option value="">Choisir un élève</option>
	{foreach from=$listeEleves key=leMatricule item=unEleve}
	<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected="selected"{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
