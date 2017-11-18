{if isset($listeEleves)}
<select name="matricule" id="selectEleve" class="form-control">
	<option value="">Tous les élèves</option>
	{foreach from=$listeEleves key=leMatricule item=unEleve}
		<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected="selected"{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
{/if}
