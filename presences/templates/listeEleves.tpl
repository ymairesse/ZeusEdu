<select name="matricule" id="selectEleve">
	<option value="">Choisir un élève</option>
	{foreach from=$listeElevesClasse key=leMatricule item=unEleve}
	<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
