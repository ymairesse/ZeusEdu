{if isset($listeEleves)}
<select name="matricule" id="selectEleve">
	{foreach from=$listeEleves key=leMatricule item=unEleve}
	<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
{/if}
