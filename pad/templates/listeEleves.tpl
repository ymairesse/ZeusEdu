{if isset($listeEleves)}
<div class="form-group">
<select name="matricule" id="selectEleve" class="form-control">
	<option value="">Sélection d'un élève</option>
	{foreach from=$listeEleves key=leMatricule item=unEleve}
	<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected="selected"{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
</div>
{/if}
